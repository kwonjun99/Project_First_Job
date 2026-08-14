# Autonomous Emergency Braking System

### TTC-based AEB Control with Stateflow

## 프로젝트 개요

MATLAB/Simulink와 Stateflow를 이용해 **TTC(Time To Collision) 기반 AEB 제어 시스템**을 구현했다.

Ego Vehicle과 Target Vehicle의 상대거리와 상대속도를 이용해 충돌 위험도를 계산하고, 위험 수준에 따라 Stateflow에서 제동 단계를 전환하도록 구성했다.

정지 차량, 저속 선행차, 선행차 급제동 상황을 각각 시나리오로 구성해 제어기의 충돌 회피 성능을 검증했다.

---

## 사용 기술

* MATLAB
* Simulink
* Stateflow
* TTC Calculation
* State-based Control
* Emergency Braking Logic
* Scenario Validation
* MATLAB Automation
* Git / GitHub

---

## 시스템 구조

```text
Ego Vehicle ─────────────┐
                        │
Target Vehicle ──────────┤
                        ▼
                Relative Distance
                Relative Speed
                        │
                        ▼
                 TTC Calculation
                        │
                        ▼
                 Stateflow AEB
          NORMAL / WARNING
        PARTIAL_BRAKE / FULL_BRAKE
                        │
                        ▼
                  Brake Command
                        │
                        ▼
                   Ego Vehicle
```

---

## 주요 구현 내용

### 1. TTC 계산

Ego Vehicle이 Target Vehicle에 접근하는 경우 상대거리와 Closing Speed를 이용해 TTC를 계산했다.

```text
TTC = Relative Distance / Closing Speed
```

차량이 접근하지 않는 경우에는 불필요한 AEB 동작을 방지하도록 TTC 계산 조건을 분리했다.

이를 통해 단순 거리 기준만 사용하는 것이 아니라 **현재 상대속도를 함께 고려해 충돌 위험도를 판단**하도록 구성했다.

---

### 2. Stateflow 기반 AEB 상태 제어

충돌 위험도에 따라 AEB 동작을 다음 네 단계로 구분했다.

```text
NORMAL
   ↓
WARNING
   ↓
PARTIAL_BRAKE
   ↓
FULL_BRAKE
```

각 상태에서는 위험 수준에 맞는 제동 명령을 출력한다.

```text
NORMAL
→ 일반 주행

WARNING
→ 충돌 위험 경고

PARTIAL_BRAKE
→ 부분 제동

FULL_BRAKE
→ 최대 비상 제동
```

위험도가 빠르게 증가하는 상황에서는 높은 제동 상태로 전환할 수 있도록 구성했다.

---

### 3. AEB Release / Hysteresis Logic

TTC가 임계값 근처에서 반복적으로 변하면 Stateflow 상태가 계속 전환될 수 있기 때문에, 진입 조건과 해제 조건을 분리했다.

```text
Activation Threshold
≠
Release Threshold
```

이를 통해 위험이 충분히 감소한 경우에만 낮은 단계로 복귀하도록 구성해 상태 전환의 안정성을 높였다.

---

### 4. Emergency Brake Command

Stateflow의 위험 상태에 따라 실제 차량에 적용할 제동 명령을 출력하도록 구성했다.

FULL_BRAKE 상태에서는 최대:

```text
-6 m/s²
```

수준의 비상 제동을 적용했다.

제어기의 상태만 확인하는 것이 아니라 실제 Ego Vehicle 속도와 상대거리 변화까지 함께 검증했다.

---

## 시나리오 검증

### Scenario 1 — Stationary Target

조건:

```text
Target Speed : 0 m/s
Ego Speed    : 최대 20 m/s
```

정지 차량을 향해 Ego Vehicle이 접근하는 상황이다.

Stateflow에서 다음 상태들이 모두 확인되었다.

```text
NORMAL
WARNING
PARTIAL_BRAKE
FULL_BRAKE
```

결과:

```text
Minimum Relative Distance : 11.097 m
Acceleration Range        : -6 ~ 0 m/s²
Collision                 : NO
```

충돌 위험이 증가하면서 AEB가 단계적으로 개입했고 정지 차량과의 충돌을 회피했다.

---

### Scenario 2 — Slow Target Vehicle

조건:

```text
Target Speed : 10 m/s
Ego Speed    : 최대 25 m/s
```

Ego Vehicle이 더 느린 선행차를 빠르게 추종하는 상황을 구성했다.

결과:

```text
Minimum Relative Distance : 11.049 m
Acceleration Range        : -6 ~ 0 m/s²
Collision                 : NO
```

상대속도에 의해 TTC가 감소하면서 AEB가 개입했고 선행차와의 충돌을 방지했다.

---

### Scenario 3 — Target Hard Braking

주행 중인 Target Vehicle이 급감속하는 상황을 구성했다.

```text
Target Speed : 5 ~ 22 m/s
Ego Speed    : 0 ~ 22 m/s
```

결과:

```text
Minimum Relative Distance : 11.659 m
Acceleration Range        : -6 ~ 0 m/s²
Collision                 : NO
```

선행차의 급격한 속도 감소에 따라 TTC가 감소하고 AEB가 제동 명령을 발생시키는 것을 확인했다.

---

## 결과 요약

| Scenario            | Target 조건  |  최소 상대거리 |   최대 제동 | 충돌 |
| ------------------- | ---------- | -------: | ------: | -- |
| Stationary Target   | 0 m/s      | 11.097 m | -6 m/s² | NO |
| Slow Target         | 10 m/s     | 11.049 m | -6 m/s² | NO |
| Target Hard Braking | 22 → 5 m/s | 11.659 m | -6 m/s² | NO |

세 가지 시나리오 모두에서 충돌 없이 시뮬레이션을 종료했다.

---

## 결과 자동화

시나리오를 반복해서 수동 실행하지 않도록 MATLAB 스크립트 `run_AEB_final.m`을 구성했다.

```text
Scenario 선택
     ↓
Simulink 실행
     ↓
신호 Logging
     ↓
성능 지표 계산
     ↓
PNG 저장
     ↓
CSV 저장
     ↓
MAT 결과 저장
```

이를 통해 각 시나리오의 결과를 같은 기준으로 비교할 수 있도록 정리했다.

---

## 문제 해결 경험

### 단순 TTC 조건의 한계

초기에는 TTC 임계값만 이용해 상태를 전환했지만, 임계값 근처에서 위험도가 변할 경우 Stateflow 상태가 불안정하게 전환될 가능성이 있었다.

이를 개선하기 위해 AEB 진입 조건과 해제 조건을 분리하고 Hysteresis 개념을 적용했다.

그 결과 위험도가 충분히 감소한 경우에만 이전 상태로 복귀하도록 로직을 정리할 수 있었다.

### 제동 상태와 실제 차량 동작 검증

Stateflow의 상태가 정상적으로 전환되는 것만으로 제어 성능을 판단하지 않고 다음 신호들을 함께 확인했다.

```text
TTC
Relative Distance
Ego Speed
Target Speed
AEB Mode
Acceleration Command
```

이를 통해 AEB 상태 변화가 실제 차량 감속과 충돌 회피로 이어지는지 검증했다.

---

## 프로젝트를 통해 배운 점

이 프로젝트를 통해 AEB는 단순히 특정 거리에서 브레이크를 작동시키는 기능이 아니라, **상대거리와 상대속도로 위험도를 계산하고 상태 기반으로 제동 수준을 결정하는 제어 문제**라는 점을 이해했다.

특히 Stateflow를 이용해:

```text
위험도 계산
↓
상태 판단
↓
제동 단계 결정
↓
차량 동작 검증
```

과정을 직접 구성하면서 상태 기반 안전 제어 로직을 경험했다.

이후 Integrated Vehicle Control 프로젝트에서는 이 AEB 구조를 ACC 및 Cruise Control과 통합해 **AEB가 일반 종방향 제어보다 높은 우선순위로 동작하는 Supervisory Control 구조**로 확장했다.
