# Integrated Longitudinal Vehicle Control

MATLAB/Simulink와 Stateflow를 이용해서 Cruise Control, ACC, AEB를 하나의 종방향 차량 제어 시스템으로 통합한 프로젝트다.

이전 프로젝트에서는 ACC와 AEB를 각각 구현했다면, 이번 프로젝트에서는 차량 저항을 포함한 Vehicle Plant 위에서 Cruise / ACC / AEB가 상황에 따라 우선순위를 바꾸며 동작하도록 구성했다.

---

## 1. 프로젝트 목표

최종 목표는 다음 세 가지 상황을 하나의 제어 시스템에서 처리하는 것이다.

```text
일반 주행
→ Cruise Control

선행차 접근
→ ACC

충돌 위험 증가
→ AEB Override
```

최종 제어 구조:

```text
Cruise Controller ─────┐
                       ▼
                Nominal Arbitration
                       MIN
                       ▲
ACC Controller ─────────┘
                       │
                   a_nominal
                       │
                       ├────────────┐
                                    ▼
                              Safety Arbitration
                                    MIN
                                    ▲
AEB Supervisor ─────────────────────┘
                                  a_aeb
                                    │
                                    ▼
                                  a_final
                                    │
                                    ▼
                           Ego Vehicle Plant
```

---

## 2. 개발 환경

- MATLAB
- Simulink
- Stateflow
- Git / GitHub
- macOS

---

## 3. 프로젝트 구조

```text
07_Vehicle_Control/
├── model/
│   ├── Vehicle_Control.slx
│   └── init_vehicle_control.m
│
├── scripts/
│   └── run_vehicle_control_final.m
│
├── images/
│   ├── normal_acc_following_speed.png
│   ├── normal_acc_following_distance.png
│   ├── normal_acc_following_ttc.png
│   ├── normal_acc_following_control_commands.png
│   ├── normal_acc_following_supervisor_mode.png
│   ├── target_hard_braking_speed.png
│   ├── target_hard_braking_distance.png
│   ├── target_hard_braking_ttc.png
│   ├── target_hard_braking_control_commands.png
│   ├── target_hard_braking_supervisor_mode.png
│   ├── emergency_stationary_obstacle_speed.png
│   ├── emergency_stationary_obstacle_distance.png
│   ├── emergency_stationary_obstacle_ttc.png
│   ├── emergency_stationary_obstacle_control_commands.png
│   ├── emergency_stationary_obstacle_supervisor_mode.png
│   ├── comparison_minimum_distance.png
│   ├── comparison_minimum_ttc.png
│   └── comparison_final_speed.png
│
├── results/
│   ├── normal_acc_following_metrics.csv
│   ├── normal_acc_following_mode_transitions.csv
│   ├── target_hard_braking_metrics.csv
│   ├── target_hard_braking_mode_transitions.csv
│   ├── emergency_stationary_obstacle_metrics.csv
│   ├── emergency_stationary_obstacle_mode_transitions.csv
│   └── all_scenarios_metrics.csv
│
└── README.md
```

---

## 4. Vehicle Plant

단순하게 가속도를 적분하는 모델 대신 차량에 작용하는 종방향 힘을 이용해 Vehicle Plant를 구성했다.

```text
F_total = F_command - F_aero - F_roll
```

```text
a_ego = F_total / m
```

공기저항:

```text
F_aero = 0.5 * rho * Cd * A * v_ego^2
```

구름저항:

```text
F_roll = Crr * m * g
```

초기속도 `20 m/s` 기준 차량 저항:

```text
Aerodynamic drag   : 161.70 N
Rolling resistance : 235.44 N
Total resistance   : 397.14 N
```

---

## 5. Cruise Control

Cruise Controller는 PI 제어기로 구성했다.

```text
e_v = v_set - v_ego
```

```text
a_cruise = Kp_cruise * e_v + Ki_cruise * integral(e_v)
```

Gain:

```matlab
Kp_cruise = 0.80;
Ki_cruise = 0.15;
```

단독 Cruise 테스트 결과:

```text
Target speed      : 25.000 m/s
Initial speed     : 20.000 m/s
Final speed       : 25.027 m/s
Final speed error : -0.027 m/s
Cruise command    : 0.211 ~ 2.000 m/s^2
```

차량 저항이 존재하기 때문에 정상상태에서도 작은 양의 가속도 명령이 유지되는 것을 확인했다.

---

## 6. ACC

Desired Distance:

```text
d_des = d0 + T_gap * v_ego
```

파라미터:

```matlab
d0    = 5.0;
T_gap = 1.8;
```

거리 오차:

```text
e_d = d_rel - d_des
```

상대속도:

```text
v_rel = v_target - v_ego
```

ACC 명령:

```text
a_acc = Kp_acc * e_d + Kv_acc * v_rel
```

Gain:

```matlab
Kp_acc = 0.08;
Kv_acc = 0.40;
```

ACC 명령 제한:

```text
-3.0 <= a_acc <= 2.0 m/s^2
```

---

## 7. Cruise / ACC Arbitration

Cruise와 ACC 중 더 보수적인 가속도 명령을 선택했다.

```text
a_nominal = min(a_cruise, a_acc)
```

예:

```text
Cruise = +1.5 m/s^2
ACC    = -1.0 m/s^2

a_nominal = -1.0 m/s^2
```

---

## 8. TTC 기반 AEB Supervisor

Closing Speed:

```text
v_closing = v_ego - v_target
```

TTC:

```text
TTC = d_rel / v_closing
```

AEB 기준:

```matlab
TTC_warning = 4.0;
TTC_partial = 3.0;
TTC_full    = 2.0;

d_full = 15.0;
```

Stateflow 상태:

```text
NORMAL
AEB_WARNING
AEB_PARTIAL
AEB_FULL
```

AEB 명령:

```text
NORMAL      : +2.0 m/s^2
WARNING     : +2.0 m/s^2
PARTIAL     : -3.0 m/s^2
FULL        : -6.0 m/s^2
```

NORMAL과 WARNING에서는 AEB가 Nominal Control을 방해하지 않고, 충돌 위험이 높아지면 PARTIAL / FULL 제동으로 Override하도록 구성했다.

---

## 9. Safety Arbitration

최종 차량 입력:

```text
a_final = min(a_nominal, a_aeb)
```

예:

```text
Nominal ACC command = -3.0 m/s^2
AEB FULL command    = -6.0 m/s^2

a_final = -6.0 m/s^2
```

---

# 10. Scenario 1 - Normal ACC Following

조건:

```text
Ego initial speed : 20 m/s
Target speed      : 18 m/s
Initial distance  : 80 m
Simulation time   : 20 s
```

측정 결과:

```text
Ego speed        : 18.169 ~ 22.262 m/s
Target speed     : 18.000 m/s
Minimum distance : 40.895 m
Final distance   : 40.895 m
Minimum TTC      : 15.917 s
Collision        : NO
```

이 시나리오에서는 ACC가 선행차를 추종했고 AEB는 실제 비상제동을 하지 않았다.

![Scenario 1 Speed](images/normal_acc_following_speed.png)

![Scenario 1 Distance](images/normal_acc_following_distance.png)

![Scenario 1 TTC](images/normal_acc_following_ttc.png)

![Scenario 1 Control](images/normal_acc_following_control_commands.png)

![Scenario 1 Supervisor](images/normal_acc_following_supervisor_mode.png)

---

# 11. Scenario 2 - Target Hard Braking

조건:

```text
Ego initial speed    : 22 m/s
Target initial speed : 22 m/s
Target final speed   : 5 m/s
Initial distance     : 65 m
Simulation time      : 15 s
```

Target은 2초부터 감속해서 3초에 `5 m/s`까지 감소하도록 구성했다.

측정 결과:

```text
Ego speed        : 0.000 ~ 23.549 m/s
Target speed     : 5.000 ~ 22.000 m/s
Minimum distance : 13.768 m
Final distance   : 25.890 m
Minimum TTC      : 2.844 s
Final command    : -6.000 ~ 2.000 m/s^2
Collision        : NO
```

Stateflow 전환:

```text
NORMAL
→ AEB_WARNING
→ AEB_PARTIAL
→ AEB_FULL
→ NORMAL
```

기존 측정 전환 시점:

```text
2.900 s → AEB_WARNING
4.150 s → AEB_PARTIAL
7.000 s → AEB_FULL
9.400 s → NORMAL
```

ACC가 먼저 대응하고, 위험이 증가하면서 AEB가 단계적으로 개입한 뒤 위험이 해소되면서 NORMAL로 복귀했다.

![Scenario 2 Speed](images/target_hard_braking_speed.png)

![Scenario 2 Distance](images/target_hard_braking_distance.png)

![Scenario 2 TTC](images/target_hard_braking_ttc.png)

![Scenario 2 Control](images/target_hard_braking_control_commands.png)

![Scenario 2 Supervisor](images/target_hard_braking_supervisor_mode.png)

---

# 12. Scenario 3 - Emergency Stationary Obstacle

조건:

```text
Ego initial speed : 20 m/s
Target speed      : 0 m/s
Initial distance  : 45 m
Initial TTC       : 2.25 s
Simulation time   : 10 s
```

시작부터 위험도가 높은 시나리오다.

측정 결과:

```text
Ego speed        : 0.000 ~ 20.000 m/s
Minimum distance : 8.561 m
Final distance   : 8.561 m
Minimum TTC      : 1.667 s
Final command    : -6.000 ~ -3.000 m/s^2
Collision        : NO
```

Stateflow는 WARNING을 기다리지 않고 높은 위험 단계로 직접 전환했다.

```text
0.100 s → AEB_PARTIAL
0.450 s → AEB_FULL
```

![Scenario 3 Speed](images/emergency_stationary_obstacle_speed.png)

![Scenario 3 Distance](images/emergency_stationary_obstacle_distance.png)

![Scenario 3 TTC](images/emergency_stationary_obstacle_ttc.png)

![Scenario 3 Control](images/emergency_stationary_obstacle_control_commands.png)

![Scenario 3 Supervisor](images/emergency_stationary_obstacle_supervisor_mode.png)

---

## 13. 시나리오 비교

| Scenario | 주요 제어 | 최소 상대거리 | 최소 TTC | 충돌 |
|---|---|---:|---:|---|
| Normal ACC Following | Cruise + ACC | **40.895 m** | **15.917 s** | **NO** |
| Target Hard Braking | ACC + AEB | **13.768 m** | **2.844 s** | **NO** |
| Emergency Stationary Obstacle | AEB Override | **8.561 m** | **1.667 s** | **NO** |

![Minimum Distance Comparison](images/comparison_minimum_distance.png)

![Minimum TTC Comparison](images/comparison_minimum_ttc.png)

![Final Speed Comparison](images/comparison_final_speed.png)

---

## 14. 결과 자동화

`run_vehicle_control_final.m`을 실행하면 세 시나리오를 자동으로 순서대로 실행한다.

```text
Scenario 1
→ Simulation
→ Metrics CSV
→ Mode Transition CSV
→ PNG

Scenario 2
→ 동일 과정

Scenario 3
→ 동일 과정

전체 결과
→ all_scenarios_metrics.csv
→ Comparison PNG
```

실행:

```matlab
cd("/Users/jun_mac/Documents/Project_First_Job/07_Vehicle_Control")

run("scripts/run_vehicle_control_final.m");
```

정상 완료 시:

```text
VEHICLE CONTROL FINAL EXPORT COMPLETED
```

가 출력된다.

---

## 15. 자동 저장 지표

`all_scenarios_metrics.csv`에는 다음 항목을 저장한다.

```text
Ego / Target speed
Initial / Minimum / Final relative distance
Desired distance
Distance error
Minimum TTC

Cruise command
ACC command
Nominal command
AEB command
Final command
Plant input

WARNING 진입시간
PARTIAL 진입시간
FULL 진입시간

각 Supervisor 상태 지속시간

Collision 여부
Collision time
Collision speed
```

추가로 `a_final`과 실제 Vehicle Plant 입력의 최대 차이를 계산해 최종 arbitration 신호가 실제 Plant까지 정상 전달되는지도 확인한다.

---

## 16. 구현 중 확인한 문제

### Cruise Controller 입력 포트

초기 Cruise 테스트에서 차량이 목표속도로 가속하지 않고 정지하는 문제가 있었다.

원인은 Cruise Controller의 `v_set`, `v_ego` 입력 포트 연결이 잘못되어 속도 오차가 반대로 계산되고 있었기 때문이다.

정상 식:

```text
e_v = v_set - v_ego
```

수정 후:

```text
Target speed      : 25.000 m/s
Final speed       : 25.027 m/s
Final speed error : -0.027 m/s
```

로 정상 추종을 확인했다.

### Vehicle Plant 입력 로그

통합 과정에서 Final Command와 Plant Input 로그가 다르게 출력된 적이 있었다.

실제 차량 동작은 정상적이었지만 `a_plant_input_log`가 이전 Nominal Control 선에 연결되어 있었고, 이후 Safety Arbitration 출력과 Ego Vehicle Plant 사이의 동일한 신호에서 Branch하도록 수정했다.

이 과정에서 제어기 출력만 보는 것이 아니라 실제 Plant 입력까지 확인하는 것이 중요하다는 점을 확인했다.

---

## 17. 프로젝트 한계

현재 모델은 종방향 제어 구조와 상위 제어 우선순위 검증에 초점을 맞췄다.

따라서 다음 요소는 단순화되어 있다.

- 실제 파워트레인 동특성
- 브레이크 액추에이터 지연
- 노면 마찰계수 변화
- 타이어 Slip
- 센서 노이즈 및 인식 지연
- 경사로
- 차량 질량 변화
- Cut-in 차량
- 실제 Euro NCAP 시험 조건

또한 Cruise / ACC / AEB Gain과 Threshold는 프로젝트 시나리오 기반으로 설정했으며 실제 양산 차량 Calibration 값은 아니다.

---

## 18. 프로젝트에서 배운 점

이번 프로젝트에서는 각 제어기를 개별적으로 만드는 것보다 여러 제어기의 역할과 우선순위를 하나의 시스템 안에서 정리하는 과정이 중요했다.

```text
Vehicle Plant
↓
Cruise PI
↓
ACC
↓
Nominal Arbitration
↓
TTC Calculation
↓
Stateflow AEB Supervisor
↓
Safety Arbitration
↓
Integrated Scenario Validation
↓
Result Automation
```

특히 일반 주행 제어와 안전 제어를 분리한 뒤, 충돌 위험이 높아질 때 AEB가 최종 명령을 Override하도록 구성하면서 상위 제어 구조를 직접 구현해볼 수 있었다.

---

## 19. 최종 결과

```text
Scenario 1
Normal ACC Following
→ Minimum Distance: 40.895 m
→ Collision: NO

Scenario 2
Target Hard Braking
→ Minimum Distance: 13.768 m
→ AEB FULL intervention
→ Collision: NO

Scenario 3
Emergency Stationary Obstacle
→ Minimum Distance: 8.561 m
→ AEB PARTIAL → FULL
→ Collision: NO
```

세 시나리오 모두 충돌 없이 종료했으며, 평상시에는 Cruise / ACC가 차량을 제어하고 충돌 위험이 높아질 경우 Stateflow 기반 AEB가 최종 차량 명령을 Override하는 통합 종방향 제어 시스템을 구현했다.
