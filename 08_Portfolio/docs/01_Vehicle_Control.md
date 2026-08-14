# Integrated Longitudinal Vehicle Control

### Cruise / ACC / AEB Supervisory Control

## 프로젝트 개요

MATLAB/Simulink와 Stateflow를 이용해 **Cruise Control, ACC, AEB를 하나의 종방향 차량 제어 시스템으로 통합**했다.

일반 주행에서는 Cruise와 ACC가 차량을 제어하고, 충돌 위험이 높아질 경우 AEB가 기존 제어 명령을 Override하도록 구성했다.

단순 제어기 구현에서 끝내지 않고, 차량 저항을 포함한 Vehicle Plant와 3개의 주행 시나리오를 구성해 통합 제어 시스템을 검증했다.

---

## 사용 기술

* MATLAB
* Simulink
* Stateflow
* PI Control
* ACC Distance Control
* TTC Calculation
* Supervisory Control
* Git / GitHub

---

## 시스템 구조

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
                       ▼
                Safety Arbitration
                       ▲
                       │
                 AEB Supervisor
                       │
                       ▼
                    a_final
                       │
                       ▼
                Ego Vehicle Plant
```

평상시에는 Cruise와 ACC 중 더 보수적인 명령을 선택하고, 위험 상황에서는 AEB가 최종 차량 명령을 Override하도록 구성했다.

---

## 주요 구현 내용

### 1. Vehicle Plant

차량 질량뿐 아니라 공기저항과 구름저항을 포함한 종방향 차량 모델을 구성했다.

```text
F_total = F_command - F_aero - F_roll
a_ego   = F_total / m
```

이를 통해 제어 명령이 0이어도 실제 차량이 저항에 의해 자연스럽게 감속하도록 구현했다.

### 2. Cruise Control

PI 제어기를 이용해 목표속도를 추종하도록 구현했다.

```text
e_v = v_set - v_ego
```

단독 테스트에서 `20 m/s → 25 m/s` 목표속도 추종을 확인했다.

```text
Final speed       : 25.027 m/s
Final speed error : -0.027 m/s
```

### 3. ACC

상대거리와 상대속도를 이용해 선행차와의 안전거리를 유지하도록 구현했다.

```text
d_des = d0 + T_gap × v_ego

e_d   = d_rel - d_des

a_acc = Kp × e_d + Kv × v_rel
```

Cruise가 가속을 요구하더라도 선행차와 가까워질 경우 ACC의 감속 명령이 우선되도록 구성했다.

### 4. AEB Supervisor

상대거리와 Closing Speed를 이용해 TTC를 계산했다.

```text
TTC = d_rel / v_closing
```

Stateflow를 이용해 위험도를 다음 4개 상태로 구분했다.

```text
NORMAL
AEB_WARNING
AEB_PARTIAL
AEB_FULL
```

긴급 상황에서는 모든 상태를 순차적으로 거치지 않고 높은 위험 상태로 직접 전환할 수 있도록 구성했다.

### 5. Control Arbitration

일반 종방향 제어:

```text
a_nominal = min(a_cruise, a_acc)
```

최종 안전 제어:

```text
a_final = min(a_nominal, a_aeb)
```

예를 들어 ACC의 최대 일반 제동이 `-3 m/s²`인 상황에서 AEB FULL이 발생하면:

```text
ACC       = -3 m/s²
AEB FULL  = -6 m/s²

Final     = -6 m/s²
```

가 되어 AEB가 차량 제어를 Override한다.

---

## 시나리오 검증

### Scenario 1 — Normal ACC Following

```text
Ego Initial Speed : 20 m/s
Target Speed      : 18 m/s
Initial Distance  : 80 m
```

결과:

```text
Final Ego Speed  : 약 18.17 m/s
Minimum Distance : 40.895 m
Minimum TTC      : 15.917 s
Collision        : NO
```

충분히 안전한 상황에서는 AEB가 비상제동하지 않고 ACC가 선행차를 추종했다.

---

### Scenario 2 — Target Hard Braking

```text
Ego Initial Speed    : 22 m/s
Target Initial Speed : 22 m/s
Target Final Speed   : 5 m/s
Initial Distance     : 65 m
```

선행차가 급감속하는 상황에서 다음과 같은 Supervisor 상태 전환을 확인했다.

```text
NORMAL
→ AEB_WARNING
→ AEB_PARTIAL
→ AEB_FULL
→ NORMAL
```

결과:

```text
Minimum Distance : 13.768 m
Minimum TTC      : 2.844 s
Maximum Braking  : -6.0 m/s²
Collision        : NO
```

ACC가 먼저 대응하고 위험도가 증가하면서 AEB가 단계적으로 개입했으며, 위험 해소 후 NORMAL 상태로 복귀했다.

---

### Scenario 3 — Emergency Stationary Obstacle

```text
Ego Initial Speed : 20 m/s
Target Speed      : 0 m/s
Initial Distance  : 45 m
Initial TTC       : 2.25 s
```

시작부터 충돌 위험이 높은 상황이므로 Supervisor가 빠르게:

```text
AEB_PARTIAL
→ AEB_FULL
```

로 전환되었다.

결과:

```text
Minimum Distance : 8.561 m
Minimum TTC      : 1.667 s
Maximum Braking  : -6.0 m/s²
Collision        : NO
```

AEB FULL 명령이 최종 차량 입력까지 정상적으로 전달되는 것을 확인했다.

---

## 문제 해결 경험

### Cruise 입력 연결 오류

초기 Cruise 테스트에서 차량이 목표속도로 가속하지 않고 정지하는 문제가 발생했다.

속도 오차를 확인한 결과:

```text
Expected : +5 m/s
Actual   : -25 m/s
```

가 출력되었고, `v_set`과 `v_ego` 입력 포트 연결 오류를 확인했다.

입력 신호를 직접 Logging하여 문제를 찾고 수정한 뒤 정상적인 목표속도 추종을 확인했다.

### Final Command / Plant Input 검증

통합 과정에서 최종 제어 명령과 Vehicle Plant 입력 로그가 다르게 나타나는 문제도 발생했다.

최종 Arbitration 출력부터 Plant 입력까지 신호를 직접 비교했고, Logging Branch가 잘못된 신호에 연결되어 있음을 확인했다.

수정 후:

```text
Final command : -6.000 ~ -3.000 m/s²
Plant input   : -6.000 ~ -3.000 m/s²
```

로 일치하는 것을 검증했다.

---

## 결과 요약

| Scenario             | 주요 제어        |  최소 상대거리 |   최소 TTC | 충돌 |
| -------------------- | ------------ | -------: | -------: | -- |
| Normal ACC Following | Cruise + ACC | 40.895 m | 15.917 s | NO |
| Target Hard Braking  | ACC + AEB    | 13.768 m |  2.844 s | NO |
| Emergency Obstacle   | AEB Override |  8.561 m |  1.667 s | NO |

3개의 시나리오 모두 충돌 없이 종료했으며, **일반 주행 제어와 긴급 안전 제어의 역할을 분리하고 상황에 따라 제어 우선순위를 전환하는 통합 종방향 제어 시스템**을 구현했다.

---

## 프로젝트를 통해 배운 점

처음에는 Cruise, ACC, AEB를 각각 구현하는 것에 집중했지만, 이번 프로젝트를 진행하면서 실제 시스템에서는 각 제어기의 성능뿐 아니라 **제어기 사이의 우선순위와 상위 제어 로직이 중요하다는 점**을 배웠다.

특히 Stateflow를 이용한 상태 기반 제어와 Arbitration 구조를 직접 구성하면서 여러 ADAS 기능을 하나의 시스템으로 통합하는 과정을 경험했다.
