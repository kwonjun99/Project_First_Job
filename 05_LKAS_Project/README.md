# Lane Keeping Assist System

### Dual PID & Stateflow Gain Scheduling

MATLAB/Simulink와 Stateflow를 이용해 차량이 차선 중앙을 따라 주행하도록 하는 **LKAS(Lane Keeping Assistance System)**를 구현한 대학 수업 팀 프로젝트다.

카메라 기반 Lane Boundary 정보에서 차량의 **Lateral Offset과 Relative Yaw Angle**을 계산하고, 두 오차를 각각 PID Controller로 제어해 최종 Steering Angle을 생성하도록 구성했다.

---

## 1. 프로젝트 개요

* **구분:** University Team Project
* **주제:** Lane Keeping Assistance System
* **개발 환경:** MATLAB / Simulink / Stateflow
* **주요 제어:** Lateral PID + Yaw PID
* **주요 검증 항목:** Lateral Offset / Yaw Error / Steering Angle
* **시나리오:** 직선, S-Curve, 좌우회전, U-Turn 등

전체 시스템 흐름은 다음과 같다.

```text
Driving Scenario
      ↓
Lane Sensor Data
      ↓
Error Calculator
      ↓
Lateral Offset / Yaw Error
      ↓
Dual PID Controller
      ↓
Stateflow Gain Scheduling
      ↓
Steering Angle
      ↓
Lateral Vehicle Model
```

---

## 2. 프로젝트 구조

```text
05_LKAS_Project/
├── README.md
│
├── model/
│   ├── LKAS_Project.slx
│   └── LKAS_Project_Scenario.mat
│
├── scripts/
│   ├── init_LKAS.m
│   └── export_LKAS_result.m
│
├── Images/
│   ├── Result/
│   ├── Scenario/
│   └── Simulink Model/
│
├── results/
│   └── lkas_metrics.csv
│
├── docs/
│   └── LKAS 최종 1.pdf
│
└── provided/
    └── esp_control.c
```

---

## 3. Lateral Vehicle Model

차량의 횡방향 거동을 표현하기 위해 Bicycle Model 기반의 횡방향 차량 모델을 사용했다.

주요 차량 파라미터:

```text
Vehicle Mass        : 2045 kg
Yaw Inertia         : 5428 kg·m²
Front CG Distance   : 1.488 m
Rear CG Distance    : 1.712 m
Front Cornering Stiffness : 38925 N/rad
Rear Cornering Stiffness  : 38255 N/rad
Control Period      : 0.1 s
```

차량 동역학 모델과 ESP Controller 일부는 수업에서 제공된 모델을 활용했고, 이를 기반으로 LKAS 제어 로직과 시나리오를 구성했다.

---

## 4. Error Calculator

Driving Scenario의 Lane Boundary 정보를 이용해 차량의 차선 중심 기준 오차를 계산했다.

주요 제어 오차:

```text
Lateral Offset
→ 차량이 차선 중앙으로부터 얼마나 벗어났는지 계산

Relative Yaw Angle
→ 차량 진행 방향과 차선 방향의 차이 계산
```

좌·우 Lane Boundary 데이터를 이용해 차선 중심을 계산하고 이를 차량 위치와 비교해 횡방향 오차를 생성했다.

---

## 5. Dual PID Controller

LKAS Controller는 두 개의 PID Controller로 구성했다.

```text
Lateral Offset
      ↓
Lateral PID
      │
      ├──────────┐
                 ▼
          Steering Command
                 ▲
      ┌──────────┘
      │
Yaw Error
      ↓
Yaw PID
```

Lateral PID는 차량의 횡방향 위치 오차를 줄이고, Yaw PID는 차량의 진행 방향을 차선 방향과 일치시키는 역할을 한다.

두 제어 결과를 종합해 최종 Steering Angle을 생성했다.

---

## 6. Stateflow & Gain Scheduling

도로 형상과 차량 속도에 따라 같은 PID Gain만 사용할 경우 제어 성능이 달라질 수 있어 Stateflow를 이용해 Gain을 조정했다.

프로젝트에서는 다음과 같은 구간을 기준으로 PID Gain을 튜닝했다.

```text
Straight        : 약 30 km/h
S-Curve         : 약 25 km/h
Left/Right Turn : 약 20 km/h
U-Turn          : 약 15 km/h
```

각 구간에서 시뮬레이션 Scope를 확인하면서 PID Gain을 조정하고 이전 결과와 비교하는 방식으로 튜닝했다.

---

## 7. 시뮬레이션 결과

기존 프로젝트 결과:

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

횡방향 편차는 약 **±14 cm 이내**로 유지됐으며, Steering Angle도 약 **±8° 이내**에서 제어됐다.

Yaw Error는 대부분 ±5° 근처에서 유지됐지만 일부 구간에서는 최대 약 `+5.53°`까지 증가했다.

복합 곡선 구간에서 단순 PID 기반 제어의 한계가 나타났으며, 이를 통해 속도와 도로 곡률에 따라 제어기 Gain 조정이 필요하다는 점을 확인했다.

---

## 8. 결과 이미지

기존 프로젝트에서 저장한 Simulink 모델, Scenario 및 결과 이미지를 사용했다.

```text
Images/
├── Result/
├── Scenario/
└── Simulink Model/
```

주요 결과는 다음 신호를 중심으로 확인했다.

* Lateral Offset
* Relative Yaw Angle
* Steering Angle
* 차량 주행 궤적
* Stateflow / Gain Scheduling
* S-Curve Tuning 전후 결과

---

## 9. 한계점

프로젝트 진행 과정에서 다음과 같은 한계를 확인했다.

* 고속 주행 구간 검증 부족
* 복잡한 곡률에서 PID 성능 저하
* Clothoid Curve 미적용
* 센서 노이즈 및 인식 지연 단순화
* 기상 및 조도 조건 미반영
* 실제 차량 검증 미수행

향후에는 Gain Scheduling 고도화 또는 MPC와 같은 예측 제어 방식 적용을 고려할 수 있다.

---

## 10. 프로젝트에서 배운 점

이 프로젝트를 통해 종방향 제어와 다른 **차량 횡방향 제어 구조**를 경험했다.

특히:

```text
Lane Detection
↓
Error Calculation
↓
Lateral / Yaw Control
↓
Steering Command
↓
Vehicle Response
```

흐름을 Simulink로 구성하면서 차선 유지 제어의 기본 구조를 이해할 수 있었다.

또한 하나의 PID Gain만 사용하는 것보다 차량 속도와 도로 형태에 따라 Gain을 조정하는 것이 중요하다는 점을 시뮬레이션을 통해 확인했다.

이 프로젝트는 이후 진행한 ACC, AEB, Integrated Vehicle Control 프로젝트와 함께 횡방향 및 종방향 차량 제어 경험을 보여주는 수업 프로젝트로 정리했다.
