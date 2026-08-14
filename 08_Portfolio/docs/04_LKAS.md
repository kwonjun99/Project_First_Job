# Lane Keeping Assist System

### Dual PID & Stateflow Gain Scheduling

## 프로젝트 개요

MATLAB/Simulink와 Stateflow를 이용해 차량이 차선 중심을 따라 주행하도록 하는 **LKAS(Lane Keeping Assistance System)**를 구현한 대학 수업 팀 프로젝트다.

Driving Scenario의 Lane Boundary 정보를 이용해 차량의 **Lateral Offset과 Relative Yaw Angle**을 계산하고, 두 오차를 각각 PID Controller로 제어해 Steering Angle을 생성하도록 구성했다.

직선, S-Curve, 좌·우회전, U-Turn이 포함된 도로 시나리오에서 차량의 횡방향 제어 성능을 확인했다.

---

## 사용 기술

* MATLAB
* Simulink
* Stateflow
* Bicycle Model
* Lateral Vehicle Dynamics
* PID Control
* Gain Scheduling
* Driving Scenario

---

## 시스템 구조

```text
Driving Scenario
       ↓
Lane Sensor Data
       ↓
Error Calculator
       ↓
Lateral Offset / Relative Yaw Angle
       ↓
Lateral PID + Yaw PID
       ↓
Stateflow Gain Scheduling
       ↓
Steering Angle
       ↓
Lateral Vehicle Model
```

차선 센서에서 얻은 좌·우 Lane Boundary를 이용해 차량의 차선 중심 기준 오차를 계산하고, 이를 조향 제어 입력으로 사용했다.

---

## Dual PID Controller

제어기는 횡방향 위치와 차량 진행 방향을 동시에 고려하기 위해 두 개의 PID Controller로 구성했다.

```text
Lateral Offset
      ↓
Lateral PID
      │
      ├───────────┐
                  ▼
            Steering Command
                  ▲
      ┌───────────┘
      │
Relative Yaw
      ↓
Yaw PID
```

Lateral PID는 차량의 차선 중심 편차를 줄이고, Yaw PID는 차량 진행 방향과 차선 방향의 차이를 줄이는 역할을 한다.

두 제어 출력을 이용해 최종 Steering Angle을 생성했다.

---

## Stateflow Gain Scheduling

도로 형태와 차량 속도에 따라 PID 응답 특성이 달라지는 점을 고려해 Stateflow 기반 Gain Scheduling을 적용했다.

기존 프로젝트에서는 다음과 같은 주행 구간을 기준으로 PID Gain을 조정했다.

```text
Straight        : 약 30 km/h
S-Curve         : 약 25 km/h
Left/Right Turn : 약 20 km/h
U-Turn          : 약 15 km/h
```

각 구간에서 시뮬레이션 결과를 비교하면서 PID Gain을 반복적으로 조정했다.

---

## 차량 모델

Bicycle Model 기반의 횡방향 차량 모델을 사용했다.

주요 파라미터:

```text
Vehicle Mass        : 2045 kg
Yaw Inertia         : 5428 kg·m²
Front CG Distance   : 1.488 m
Rear CG Distance    : 1.712 m
Front Cornering Stiffness : 38925 N/rad
Rear Cornering Stiffness  : 38255 N/rad
Control Period      : 0.1 s
```

차량 동역학 모델 및 일부 ESP 관련 구성요소는 수업에서 제공된 모델을 활용했고, 이를 기반으로 LKAS 제어 구조와 시나리오를 구성했다.

---

## 시뮬레이션 결과

당시 프로젝트 발표자료에 기록된 결과는 다음과 같다.

```text
Lateral Offset
Maximum : +10.67 cm
Minimum : -13.64 cm

Yaw Error
Maximum : +5.53 deg
Minimum : -4.64 deg

Steering Angle
Maximum : +7.94 deg
Minimum : -6.27 deg
```

횡방향 편차는 약 **±14 cm 이내**에서 유지됐으며, Steering Angle도 약 **±8° 범위**에서 제어됐다.

Yaw Error는 대부분 ±5° 근처에서 유지됐으나 일부 구간에서는 최대 약 `+5.53°`까지 증가했다.

이를 통해 복합 곡선 구간에서는 단순 PID 제어만으로 일정한 성능을 유지하기 어렵고, 속도와 도로 형태에 따른 Gain 조정이 중요하다는 점을 확인했다.

---

## 결과 분석

프로젝트에서는 다음 신호를 중심으로 LKAS 성능을 평가했다.

```text
Lateral Offset
Relative Yaw Angle
Steering Angle
Vehicle Trajectory
Stateflow / Gain Scheduling
```

S-Curve 구간에서는 PID Gain 튜닝 전후 결과를 비교하면서 횡방향 추종 성능을 개선했다.

---

## 프로젝트 한계

현재 프로젝트는 수업 환경의 시뮬레이션 모델을 기반으로 구현했기 때문에 다음과 같은 한계가 있다.

* 고속 주행 구간 검증 부족
* 복잡한 곡률에서 PID 제어 성능 저하
* Clothoid Curve 미적용
* 센서 노이즈 및 지연 단순화
* 날씨 및 조도 조건 미반영
* 실차 검증 미수행

향후에는 Gain Scheduling을 세분화하거나 MPC와 같은 예측 제어 방법을 적용해 곡선 구간 성능을 개선할 수 있다.

---

## 프로젝트를 통해 배운 점

이 프로젝트를 통해 ACC/AEB와 같은 종방향 제어와 다른 **차량 횡방향 제어 구조**를 경험했다.

특히:

```text
Lane Information
↓
Error Calculation
↓
Lateral / Yaw Control
↓
Steering Command
↓
Vehicle Response
```

의 흐름을 Simulink에서 구성하면서 차선 유지 제어의 기본 구조를 이해할 수 있었다.

또한 하나의 고정 PID Gain으로 모든 도로 조건을 처리하기보다 차량 속도와 도로 형상에 따라 제어기 특성을 조정하는 것이 중요하다는 점을 확인했다.

이 프로젝트는 이후 진행한 ACC, AEB, Integrated Vehicle Control 프로젝트와 함께 **횡방향 및 종방향 차량 제어 경험**을 보여주는 수업 프로젝트로 정리했다.

---

> **Note:** 본 문서의 정량 결과는 당시 수업 프로젝트 발표자료에 기록된 원본 시뮬레이션 결과를 기준으로 정리했다. 현재 환경에서는 기존 Driving Scenario Bus 객체 의존성으로 인해 동일 모델의 완전한 재실행은 수행하지 않았다.
