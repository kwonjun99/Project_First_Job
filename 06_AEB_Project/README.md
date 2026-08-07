AEB Project

MATLAB/Simulink와 Stateflow를 이용해서 AEB(Autonomous Emergency Braking) 시스템을 단계별로 구현하는 프로젝트다.

처음부터 제동 로직을 바로 넣기보다는 차량 모델 → TTC 계산 → 위험 단계 판단 → 실제 제동 연결 순서로 하나씩 검증하면서 진행했다.

1. 프로젝트 목표

AEB 시스템의 기본 동작을 직접 모델링하고, 충돌 위험이 커질수록 단계적으로 제동이 개입하도록 구현하는 것이 목표다.

최종 동작 순서는 아래와 같이 잡았다.

NORMAL
  ↓
WARNING
  ↓
PARTIAL_BRAKE
  ↓
FULL_BRAKE

최종적으로 확인할 항목은 다음과 같다.

충돌 발생 여부

최소 상대거리

TTC(Time To Collision)

각 AEB 모드 진입 시점

최대 감속도

제동 후 정지 여부

충돌이 발생할 경우 충돌 속도 감소량

2. 프로젝트 구조

06_AEB_Project/
├── model/
│   ├── AEB_Project.slx
│   └── init_AEB.m
├── scripts/
├── images/
├── results/
├── docs/
└── README.md

Phase 1. 차량 모델 및 Open-loop 검증

3. Target Vehicle 모델

Target Vehicle은 입력 속도를 적분해서 위치를 계산하도록 구성했다.

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

Target 차량 위치는 다음 관계를 가진다.

dx_target / dt = v_target

4. Ego Vehicle 모델

Ego Vehicle은 가속도 명령을 입력받고, 가속도를 적분해서 속도를 만들고 다시 속도를 적분해서 위치를 계산하도록 구성했다.

a_cmd
  │
  ▼
Saturation
  │
  ▼
Integrator
  │
  ├──────────────→ v_ego
  │
  ▼
Integrator
  │
  ▼
x_ego

관계식은 다음과 같다.

dv_ego / dt = a_cmd
dx_ego / dt = v_ego

속도가 음수가 되는 것을 막기 위해 속도 Integrator의 Lower Limit은 0으로 설정했다.

5. 상대거리와 Closing Speed

상대거리는 다음과 같이 계산했다.

d_rel = x_target - x_ego

Closing Speed는 다음과 같이 계산했다.

v_closing = v_ego - v_target

해석은 다음과 같다.

v_closing > 0  → Ego가 Target에 접근 중
v_closing = 0  → 상대거리 변화 없음
v_closing < 0  → 두 차량 사이 거리가 멀어짐

6. 초기 조건

첫 번째 검증은 정지 차량을 향해 Ego 차량이 일정한 속도로 접근하는 상황으로 설정했다.

Ts   = 0.05;
Tsim = 8;

v_ego0 = 20;
x_ego0 = 0;

v_target0 = 0;
x_target0 = 100;

a_cmd_test = 0;

a_max  = 2.0;
a_full = -6.0;

초기 상대거리는 100 m, Closing Speed는 20 m/s이므로 이론적인 충돌 시간은 다음과 같다.

100 / 20 = 5초

7. Open-loop 결과

실제 Simulink 결과는 다음과 같았다.

Target speed range: 0.000 ~ 0.000 m/s
Ego speed range: 20.000 ~ 20.000 m/s
Closing speed range: 20.000 ~ 20.000 m/s
Relative distance range: -60.000 ~ 100.000 m
Open-loop collision: YES
Collision time: 5.000 s

이론값과 시뮬레이션 결과가 동일하게 5초로 나왔다.

이 단계에서는 AEB 제어가 없기 때문에 충돌하는 것이 정상이다. 이후 제어기를 적용했을 때 이 결과와 비교하기 위한 기준값으로 사용한다.

Phase 1 결과: PASS

Phase 2. TTC 계산

8. TTC 계산 목적

충돌 위험도를 판단하기 위해 TTC(Time To Collision)를 추가했다.

TTC = d_rel / v_closing

단, Closing Speed가 0 이하일 때는 실제로 충돌 위험이 없기 때문에 큰 값으로 처리했다.

9. TTC MATLAB Function

Simulink의 MATLAB Function 블록을 이용해서 구현했다.

function TTC = calculateTTC(d_rel, v_closing)
%#codegen

if d_rel <= 0
    TTC = 0;
elseif v_closing > 0.1
    TTC = d_rel / v_closing;
else
    TTC = 99;
end

TTC = 99는 Target 차량에 접근하지 않는 상태를 나타내기 위해 사용했다.

10. TTC 기준값

초기 AEB 기준은 다음과 같이 잡았다.

TTC_warning = 4.0;
TTC_partial = 3.0;
TTC_full    = 2.0;

d_full = 15;

현재 Open-loop 조건에서는 예상 TTC가 다음과 같이 감소한다.

시간

상대거리

TTC

0 s

100 m

5 s

1 s

80 m

4 s

2 s

60 m

3 s

3 s

40 m

2 s

4 s

20 m

1 s

5 s

0 m

0 s

따라서 예상 위험 단계 진입 시점은 다음과 같다.

약 1초 → WARNING
약 2초 → PARTIAL_BRAKE
약 3초 → FULL_BRAKE

TTC 계산 결과가 예상값과 일치하는 것을 확인했다.

Phase 2 결과: PASS

Phase 3. Stateflow AEB 위험 단계 판단

11. Stateflow 구성

TTC 값을 이용해서 AEB 위험 단계를 구분하기 위해 Stateflow Chart를 추가했다.

상태는 총 4개로 구성했다.

NORMAL
WARNING
PARTIAL_BRAKE
FULL_BRAKE

각 상태는 숫자로도 출력하도록 했다.

State

aeb_mode

NORMAL

1

WARNING

2

PARTIAL_BRAKE

3

FULL_BRAKE

4

12. State 출력값

각 State 내부에서는 다음과 같이 aeb_mode 값을 출력한다.

NORMAL

entry:
aeb_mode = 1;

WARNING

entry:
aeb_mode = 2;

PARTIAL_BRAKE

entry:
aeb_mode = 3;

FULL_BRAKE

entry:
aeb_mode = 4;

초기 상태는 NORMAL로 설정했다.

13. State Transition 조건

기본적인 위험 단계 전환은 TTC 값에 따라 설정했다.

NORMAL → WARNING
[TTC <= TTC_warning]

WARNING → PARTIAL_BRAKE
[TTC <= TTC_partial]

PARTIAL_BRAKE → FULL_BRAKE
[TTC <= TTC_full || d_rel <= d_full]

급격하게 위험한 상황에서는 중간 단계를 순차적으로 기다리지 않고 바로 높은 위험 단계로 진입할 수 있도록 직접 전환도 추가했다.

NORMAL → PARTIAL_BRAKE
[TTC <= TTC_partial]

NORMAL → FULL_BRAKE
[TTC <= TTC_full || d_rel <= d_full]

WARNING → FULL_BRAKE
[TTC <= TTC_full || d_rel <= d_full]

14. Transition 우선순위

하나의 State에서 여러 조건이 동시에 참이 될 수 있기 때문에 위험도가 높은 전환을 우선하도록 설정했다.

NORMAL 상태의 전환 우선순위:

1순위 → FULL_BRAKE
2순위 → PARTIAL_BRAKE
3순위 → WARNING

WARNING 상태의 전환 우선순위:

1순위 → FULL_BRAKE
2순위 → PARTIAL_BRAKE

예를 들어 TTC가 1초라면 WARNING, PARTIAL, FULL 조건을 모두 만족하기 때문에 FULL_BRAKE가 가장 먼저 선택되어야 한다.

15. Stateflow Sample Time

Stateflow는 제어 주기와 맞추기 위해 Discrete 방식으로 설정했다.

Update method: Discrete
Sample time: Ts

현재:

Ts = 0.05;

이므로 0.05초마다 AEB 위험 단계를 판단한다.

16. Phase 3 검증

Stateflow 출력 aeb_mode를 Scope와 To Workspace에 연결해서 모드 변화를 확인했다.

예상 모드 전환은 다음과 같다.

0초     → NORMAL
약 1초  → WARNING
약 2초  → PARTIAL_BRAKE
약 3초  → FULL_BRAKE

이 단계에서는 아직 Stateflow 출력이 실제 Ego Vehicle의 가속도 명령에 연결되지 않았다.

따라서 차량은 기존과 동일하게 약 5초에 충돌한다.

이 단계의 목적은 제동 성능 확인이 아니라 충돌 위험을 올바른 단계로 판단하는지 확인하는 것이다.

Phase 3 결과: PASS

현재 진행 상황

Phase 1. 차량 모델 / Open-loop 검증     ✅
Phase 2. TTC 계산                       ✅
Phase 3. Stateflow 위험 단계 판단       ✅
Phase 4. 실제 AEB 제동 연결             진행 예정
Phase 5. 다양한 시나리오 검증           예정
Phase 6. 결과 자동 저장 및 최종 정리    예정

다음 단계

Stateflow에서 계산한 aeb_mode를 실제 제동 명령으로 변환한다.

초기 제동값은 다음과 같이 설정할 예정이다.

NORMAL         →  0.0 m/s²
WARNING        →  0.0 m/s²
PARTIAL_BRAKE  → -3.0 m/s²
FULL_BRAKE     → -6.0 m/s²

이 제동 명령을 Ego Vehicle의 a_cmd에 연결하고, Open-loop에서 발생했던 5초 충돌이 제거되는지 확인한다.