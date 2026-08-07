# AEB Project

MATLAB/Simulink와 Stateflow를 이용해서 AEB(Autonomous Emergency Braking) 시스템을 단계별로 구현하는 프로젝트다.

처음부터 제동 로직을 한 번에 넣기보다는 차량 모델 → TTC 계산 → 위험 단계 판단 → 제동 명령 연결 → 시나리오 검증 순서로 하나씩 확인하면서 진행했다.

---

## 1. 프로젝트 목표

AEB의 기본 동작을 직접 모델링하고, Target Vehicle과의 충돌 위험이 커질수록 단계적으로 제동이 개입하도록 구현하는 것이 목표다.

현재 AEB 상태는 다음 4단계로 구성했다.

```text
NORMAL
  ↓
WARNING
  ↓
PARTIAL_BRAKE
  ↓
FULL_BRAKE
```

최종적으로 확인할 항목은 다음과 같다.

- 충돌 발생 여부
- 최소 상대거리
- TTC(Time To Collision)
- 각 AEB 모드 진입 시점
- 최대 감속도
- 제동 후 Ego 차량 속도 변화
- 정지거리
- 충돌이 발생할 경우 충돌 속도 감소량

---

## 2. 프로젝트 구조

```text
06_AEB_Project/
├── model/
│   ├── AEB_Project.slx
│   └── init_AEB.m
├── scripts/
├── images/
├── results/
├── docs/
└── README.md
```

---

# Phase 1. 차량 모델 및 Open-loop 검증

## 3. Target Vehicle 모델

Target Vehicle은 입력 속도를 이용해서 위치를 계산하도록 구성했다.

```text
v_target_cmd
     │
     ├──────────────→ v_target
     │
     ▼
Integrator
IC = x_target0
     │
     ▼
x_target
```

Target 차량의 위치 관계는 다음과 같다.

```text
dx_target / dt = v_target
```

---

## 4. Ego Vehicle 모델

Ego Vehicle은 가속도 명령을 입력받고, 가속도를 적분해서 속도를 만들고 다시 속도를 적분해서 위치를 계산하도록 구성했다.

```text
a_cmd
  │
  ▼
Saturation
  │
  ▼
Speed Integrator
  │
  ├──────────────→ v_ego
  │
  ▼
Position Integrator
  │
  ▼
x_ego
```

관계식은 다음과 같다.

```text
dv_ego / dt = a_cmd
dx_ego / dt = v_ego
```

Ego 차량 속도가 음수가 되는 것을 막기 위해 Speed Integrator의 Lower Limit은 `0`으로 설정했다.

---

## 5. 상대거리와 Closing Speed

상대거리는 다음과 같이 계산했다.

```text
d_rel = x_target - x_ego
```

Closing Speed는 다음과 같이 계산했다.

```text
v_closing = v_ego - v_target
```

```text
v_closing > 0  → Ego가 Target에 접근 중
v_closing = 0  → 상대거리 변화 없음
v_closing < 0  → 차량 사이 거리가 멀어짐
```

---

## 6. Open-loop 초기 조건

첫 검증은 정지해 있는 Target Vehicle을 향해 Ego Vehicle이 일정한 속도로 접근하는 상황으로 설정했다.

```matlab
Ts   = 0.05;
Tsim = 8;

v_ego0 = 20;
x_ego0 = 0;

v_target0 = 0;
x_target0 = 100;

a_cmd_test = 0;

a_max  = 2.0;
a_full = -6.0;
```

초기 상대거리가 `100 m`, Closing Speed가 `20 m/s`이므로 예상 충돌시간은 다음과 같다.

```text
100 / 20 = 5초
```

---

## 7. Open-loop 결과

실제 시뮬레이션 결과:

```text
Target speed range: 0.000 ~ 0.000 m/s
Ego speed range: 20.000 ~ 20.000 m/s
Closing speed range: 20.000 ~ 20.000 m/s
Relative distance range: -60.000 ~ 100.000 m
Open-loop collision: YES
Collision time: 5.000 s
```

이론적으로 계산한 충돌시간과 Simulink 결과가 동일하게 `5초`로 나왔다.

이 단계의 충돌은 오류가 아니라 AEB 적용 전 성능을 비교하기 위한 기준값이다.

**Phase 1 결과: PASS**

---

# Phase 2. TTC 계산

## 8. TTC 계산

충돌 위험도를 판단하기 위해 TTC(Time To Collision)를 추가했다.

```text
TTC = d_rel / v_closing
```

MATLAB Function 블록은 다음과 같이 구현했다.

```matlab
function TTC = calculateTTC(d_rel, v_closing)
%#codegen

if d_rel <= 0
    TTC = 0;

elseif v_closing > 0.1
    TTC = d_rel / v_closing;

else
    TTC = 99;
end
```

Target Vehicle에 접근하고 있지 않을 때는 `TTC = 99`로 처리해서 0으로 나누는 문제와 불필요한 AEB 개입을 방지했다.

---

## 9. TTC 임계값

초기 임계값은 다음과 같이 설정했다.

```matlab
TTC_warning = 4.0;
TTC_partial = 3.0;
TTC_full    = 2.0;

d_full = 15;
```

현재 Open-loop 시나리오에서는 다음과 같이 TTC가 줄어드는 것을 확인했다.

| 시간 | 상대거리 | TTC |
|---:|---:|---:|
| 0 s | 100 m | 5 s |
| 1 s | 80 m | 4 s |
| 2 s | 60 m | 3 s |
| 3 s | 40 m | 2 s |
| 4 s | 20 m | 1 s |
| 5 s | 0 m | 0 s |

예상 위험 단계 진입 시점은 다음과 같다.

```text
약 1초 → WARNING
약 2초 → PARTIAL_BRAKE
약 3초 → FULL_BRAKE
```

TTC 결과가 예상값과 일치하는 것을 확인했다.

**Phase 2 결과: PASS**

---

# Phase 3. Stateflow AEB 위험 단계 판단

## 10. AEB 상태 구성

Stateflow Chart에 다음 4개 상태를 만들었다.

| State | aeb_mode |
|---|---:|
| NORMAL | 1 |
| WARNING | 2 |
| PARTIAL_BRAKE | 3 |
| FULL_BRAKE | 4 |

각 상태에서는 다음과 같이 출력값을 지정했다.

```text
NORMAL
entry:
aeb_mode = 1;
```

```text
WARNING
entry:
aeb_mode = 2;
```

```text
PARTIAL_BRAKE
entry:
aeb_mode = 3;
```

```text
FULL_BRAKE
entry:
aeb_mode = 4;
```

---

## 11. State Transition 조건

기본 Transition은 다음과 같이 설정했다.

```text
NORMAL → WARNING
[TTC <= TTC_warning]
```

```text
WARNING → PARTIAL_BRAKE
[TTC <= TTC_partial]
```

```text
PARTIAL_BRAKE → FULL_BRAKE
[TTC <= TTC_full || d_rel <= d_full]
```

위험한 상황에서 중간 단계를 기다리지 않고 바로 높은 단계로 진입할 수 있도록 직접 Transition도 추가했다.

```text
NORMAL → PARTIAL_BRAKE
[TTC <= TTC_partial]
```

```text
NORMAL → FULL_BRAKE
[TTC <= TTC_full || d_rel <= d_full]
```

```text
WARNING → FULL_BRAKE
[TTC <= TTC_full || d_rel <= d_full]
```

Transition 우선순위는 위험도가 높은 상태를 먼저 판단하도록 구성했다.

```text
NORMAL
1순위 FULL_BRAKE
2순위 PARTIAL_BRAKE
3순위 WARNING
```

```text
WARNING
1순위 FULL_BRAKE
2순위 PARTIAL_BRAKE
```

Stateflow는 `Ts = 0.05 s`의 Discrete 방식으로 동작하도록 설정했다.

**Phase 3 결과: PASS**

---

# Phase 4. 실제 AEB 제동 연결

## 12. 목표

Phase 3까지는 위험도를 판단하기만 했고, 실제 Ego Vehicle 입력에는 제동 명령이 연결되지 않았다.

Phase 4에서는 다음 Closed-loop 구조를 만들었다.

```text
d_rel / v_closing
       │
       ▼
TTC Calculation
       │
       ▼
AEB Mode Logic
       │
    aeb_mode
       ▼
AEB Brake Command
       │
   a_cmd_aeb
       ▼
Ego Vehicle
       │
       └──→ 다시 d_rel / v_closing 계산
```

---

## 13. 제동 명령

초기 제동값은 다음과 같이 잡았다.

```text
NORMAL         →  0.0 m/s²
WARNING        →  0.0 m/s²
PARTIAL_BRAKE  → -3.0 m/s²
FULL_BRAKE     → -6.0 m/s²
```

처음에는 `Multiport Switch`를 이용해서 `aeb_mode`를 제동값으로 변환하려고 했다.

---

## 14. 문제 발생 - Multiport Switch 제어 입력 오류

시뮬레이션 실행 시 다음 오류가 발생했다.

```text
Multiport Switch의 제어 포트 값 '0'이
'1'과 '4' 사이에 있지 않습니다.
```

Multiport Switch는 `One-based contiguous`로 설정되어 있었기 때문에 제어 입력으로 `1, 2, 3, 4`만 받을 수 있었다.

Stateflow의 초기 상태는 NORMAL이고 `aeb_mode = 1`로 설정했지만, 시뮬레이션 초기 계산 시점에서 순간적으로 `0`이 전달되는 문제가 발생했다.

처음에는 다음 방법을 시도했다.

```text
1. aeb_mode Initial value = 1 설정
2. Stateflow Default Transition → NORMAL 확인
3. aeb_mode 앞에 Saturation [1, 4] 추가
```

하지만 동일한 오류가 계속 발생했다.

---

## 15. 해결 - MATLAB Function 기반 Brake Command로 변경

초기값 처리 때문에 Multiport Switch에 계속 의존하는 것보다, 비정상 입력도 직접 처리할 수 있도록 Brake Command 부분을 MATLAB Function 블록으로 변경했다.

최종 구조:

```text
aeb_mode
   │
   ▼
Brake Command Logic
MATLAB Function
   │
   ▼
a_cmd_aeb
```

코드는 다음과 같다.

```matlab
function a_cmd_aeb = brakeCommand(aeb_mode)
%#codegen

switch round(aeb_mode)

    case 1
        % NORMAL
        a_cmd_aeb = 0.0;

    case 2
        % WARNING
        a_cmd_aeb = 0.0;

    case 3
        % PARTIAL_BRAKE
        a_cmd_aeb = -3.0;

    case 4
        % FULL_BRAKE
        a_cmd_aeb = -6.0;

    otherwise
        % 초기화 또는 비정상 mode 입력
        a_cmd_aeb = 0.0;

end
```

`otherwise`를 넣어서 시뮬레이션 시작 순간 `aeb_mode = 0`이 들어오더라도 오류를 발생시키지 않고 NORMAL과 동일한 `0 m/s²`를 출력하도록 했다.

이 방식으로 바꾸면서 Multiport Switch와 임시로 추가했던 `AEB Mode Limit` 블록은 제거했다.

---

## 16. 최종 Phase 4 연결

기존 Open-loop에서 사용하던 `Test Acceleration Command`와 Ego Vehicle의 연결을 제거했다.

최종 연결은 다음과 같다.

```text
AEB Mode Logic
      │
   aeb_mode
      ├────────→ aeb_mode_log
      ├────────→ AEB Mode Scope
      │
      ▼
AEB Brake Command
      │
   a_cmd_aeb
      ├────────→ a_cmd_log
      ├────────→ Brake Command Scope
      │
      ▼
Ego Vehicle
```

이제 Ego Vehicle의 가속도는 고정값이 아니라 AEB 위험 단계에 따라 결정된다.

---

## 17. Phase 4 확인 항목

Closed-loop AEB에서 확인할 항목:

```text
Mode range
Acceleration command range
Ego speed range
Collision YES / NO
Minimum relative distance
```

검증 코드는 다음과 같다.

```matlab
run("model/init_AEB.m");

out = sim("AEB_Project");

mode = out.get("aeb_mode_log");
aCmd = out.get("a_cmd_log");
vEgo = out.get("v_ego_log");
dRel = out.get("d_rel_log");

fprintf("\n===== AEB PHASE 4 =====\n");

fprintf("Mode range: %.0f ~ %.0f\n", ...
    min(mode.Data(:)), max(mode.Data(:)));

fprintf("Acceleration range: %.3f ~ %.3f m/s^2\n", ...
    min(aCmd.Data(:)), max(aCmd.Data(:)));

fprintf("Ego speed range: %.3f ~ %.3f m/s\n", ...
    min(vEgo.Data(:)), max(vEgo.Data(:)));

collisionIdx = find(dRel.Data(:) <= 0, 1, "first");

if isempty(collisionIdx)
    fprintf("Collision: NO\n");
else
    fprintf("Collision: YES\n");
    fprintf("Collision time: %.3f s\n", ...
        dRel.Time(collisionIdx));
end

fprintf("Minimum relative distance: %.3f m\n", ...
    min(dRel.Data(:)));
```

실제 결과값은 다음 다중 시나리오 검증 단계에서 함께 정리한다.

---

# 현재 진행 상황

```text
Phase 1. 차량 모델 / Open-loop 검증          ✅
Phase 2. TTC 계산                            ✅
Phase 3. Stateflow 위험 단계 판단            ✅
Phase 4. AEB 제동 명령 연결                  ✅ 구현
Phase 5. 복귀 로직 / 다중 시나리오 검증      진행 예정
Phase 6. 결과 자동 저장 및 최종 정리         예정
```

---

# 다음 단계

Phase 5에서는 하나의 정지 차량 상황만 보는 것이 아니라 다음 시나리오를 만들어 AEB 성능을 비교할 예정이다.

```text
Scenario 1
정지 차량 접근

Scenario 2
저속 차량 접근

Scenario 3
선행 차량 급제동
```

또한 실제 제동으로 TTC가 다시 증가했을 때 FULL_BRAKE에 계속 고정되지 않도록 복귀 조건과 히스테리시스를 추가할 예정이다.
