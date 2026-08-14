# Adaptive Cruise Control System

### Distance & Relative-Speed Based Longitudinal Control

## 프로젝트 개요

MATLAB/Simulink를 이용해 **선행차와의 상대거리와 상대속도를 기반으로 안전거리를 유지하는 ACC(Adaptive Cruise Control) 시스템**을 구현했다.

단순히 목표속도를 유지하는 Cruise Control과 달리 선행차가 존재할 경우 차량 간 거리를 고려해 가속과 감속 명령을 계산하도록 구성했다.

정상적인 차량 추종 상황과 급격하게 위험도가 증가하는 상황을 나누어 시뮬레이션하고, 상대거리·차량속도·가속도·TTC 등의 신호를 이용해 제어 성능을 확인했다.

최종 Simulink 모델은 `ACC_Project_Comfort.slx`로 정리했다.

---

## 사용 기술

* MATLAB
* Simulink
* Longitudinal Vehicle Control
* ACC Distance Control
* Relative Speed Control
* TTC Monitoring
* Scenario Validation
* MATLAB Result Logging
* Git / GitHub

---

## 시스템 구조

```text
Target Vehicle
      │
      ├──────→ Target Speed
      │
      └──────→ Target Position
                     │
                     ▼
Ego Vehicle ──→ Relative Distance
      │              │
      └──────→ Relative Speed
                     │
                     ▼
                ACC Controller
                     │
                     ▼
            Acceleration Command
                     │
                     ▼
                Ego Vehicle
```

ACC Controller에서는 현재 상대거리와 목표 안전거리의 차이, 그리고 선행차와의 상대속도를 이용해 차량의 종방향 가속도 명령을 결정하도록 구성했다.

---

## 주요 구현 내용

### 1. 상대거리 계산

Ego Vehicle과 Target Vehicle의 위치를 이용해 차량 간 상대거리를 계산했다.

```text
d_rel = x_target - x_ego
```

상대거리가 감소할수록 Ego Vehicle이 선행차에 접근하고 있다는 것을 의미한다.

---

### 2. Desired Distance

차량 속도가 높아질수록 더 긴 안전거리가 필요하도록 시간 간격 기반의 목표거리를 사용했다.

```text
d_des = d0 + T_gap × v_ego
```

이를 통해 고정거리 기준이 아니라 **Ego Vehicle의 속도에 따라 목표 안전거리가 변하는 ACC 구조**를 구성했다.

---

### 3. Relative Speed

선행차와 Ego Vehicle의 속도 차이도 제어에 사용했다.

```text
v_rel = v_target - v_ego
```

예를 들어:

```text
Target = 20 m/s
Ego    = 25 m/s

v_rel = -5 m/s
```

이면 Ego Vehicle이 선행차에 접근하고 있기 때문에 감속이 필요한 상황으로 판단할 수 있다.

---

### 4. ACC Control

ACC는 거리 오차와 상대속도를 함께 이용해 가속도 명령을 생성하도록 구성했다.

```text
Distance Error
      │
      ├────────────┐
                   ▼
              ACC Control
                   ▲
      ┌────────────┘
      │
Relative Speed
                   │
                   ▼
          Acceleration Command
```

상대거리가 충분할 때는 가속할 수 있고, 선행차와 가까워지거나 접근속도가 커질 경우 감속 명령을 발생시키도록 구성했다.

---

## Normal Following Scenario

정상적인 선행차 추종 상황에서는 Ego Vehicle이 Target Vehicle에 접근한 뒤 목표 안전거리 부근에서 상대속도를 줄이며 추종하도록 검증했다.

확인한 주요 신호:

```text
Ego Speed
Target Speed
Relative Distance
Desired Distance
Acceleration Command
TTC
Control Mode
```

거리만 확인하는 것이 아니라 속도와 가속도 응답을 함께 확인해 ACC가 불필요하게 급가속하거나 급감속하지 않는지도 확인했다.

---

## Emergency Scenario

일반적인 ACC 추종보다 더 위험한 상황에서도 상대거리와 차량 제어 명령을 검증했다.

최종 Emergency Scenario 결과:

```text
Minimum Relative Distance : 29.429 m
Acceleration Range        : -6.0 ~ 2.0 m/s²
Collision                 : NO
```

급격한 위험 상황에서 감속 명령이 발생했고 최종적으로 선행차와의 충돌 없이 시뮬레이션을 종료했다.

---

## 결과 그래프

프로젝트에서는 Normal / Emergency Scenario에 대해 다음 결과를 각각 저장했다.

```text
Speed Response
Distance Response
Acceleration Response
TTC Response
Control Mode
```

이를 통해 한 개의 결과 신호만 보는 것이 아니라 **차량 속도 → 거리 → 제어 명령 → 위험도**의 흐름을 함께 확인했다.

---

## 문제 해결 및 개선 과정

### 단순 속도 제어에서 거리 제어로 확장

처음에는 Ego Vehicle의 속도 자체를 제어하는 데 집중했지만, ACC에서는 선행차가 존재하기 때문에 목표속도만 따라가는 방식으로는 충분하지 않았다.

따라서:

```text
Vehicle Speed
```

뿐 아니라:

```text
Relative Distance
Desired Distance
Relative Speed
```

를 함께 제어 입력으로 사용하도록 구조를 확장했다.

이를 통해 종방향 제어에서 단순 속도 추종과 차량 간 거리 제어의 차이를 이해할 수 있었다.

### 정상 상황과 위험 상황 분리 검증

한 가지 시나리오에서만 동작 여부를 확인하지 않고 Normal / Emergency 상황을 분리했다.

각 시나리오에서:

```text
속도
거리
가속도
TTC
제어 상태
```

를 비교하면서 제어기가 다른 주행 조건에서도 적절하게 동작하는지 확인했다.

---

## 프로젝트 결과

```text
ACC Distance Control 구현
        ↓
Relative Speed 반영
        ↓
Desired Distance 계산
        ↓
Normal Scenario 검증
        ↓
Emergency Scenario 검증
        ↓
Minimum Distance = 29.429 m
        ↓
Collision = NO
```

ACC 제어기를 통해 선행차와의 상대거리와 상대속도를 고려한 종방향 제어를 구현하고, 정상 및 긴급 상황에서 차량 거동을 검증했다.

---

## 프로젝트를 통해 배운 점

이 프로젝트를 통해 Cruise Control처럼 차량 속도 하나만 제어하는 것과 ACC처럼 **주변 차량과의 상대적인 상태를 이용해 제어하는 것의 차이**를 이해했다.

특히 상대거리와 상대속도가 동시에 차량의 가감속 판단에 영향을 준다는 점을 Simulink 모델과 결과 그래프를 통해 확인했다.

이후 AEB 프로젝트에서는 TTC 기반의 긴급제동 로직을 별도로 구현했고, 최종 Integrated Vehicle Control 프로젝트에서는:

```text
Cruise
↓
ACC
↓
AEB
↓
Supervisory Control
```

구조로 확장해 각 제어기의 역할과 우선순위를 하나의 시스템 안에서 통합했다.
