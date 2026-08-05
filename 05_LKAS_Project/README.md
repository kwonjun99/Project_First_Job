# Lane Keeping Assist System with Gain-Scheduled Dual PID Control

## 1. Project Overview

본 프로젝트는 MATLAB/Simulink 및 Stateflow를 이용하여 구현한 Lane Keeping Assist System(LKAS) 프로젝트입니다.

차량의 횡방향 편차와 상대 요각 오차를 각각 PID 제어하고, 두 제어 출력을 결합하여 최종 조향각 명령을 생성합니다.

또한 차량의 전역 위치와 주행 구간을 Stateflow에서 판단하여 목표 종방향 속도와 PID 게인을 변경하는 Gain Scheduling 제어 구조를 구현하였습니다.

---

## 2. Development Environment

- MATLAB R2024b
- Simulink
- Stateflow
- Control System Toolbox
- Simulink Control Design

---

## 3. System Architecture

제어기는 다음 입력을 사용합니다.

| Signal | Description |
|---|---|
| `lateral_deviation` | 차선 중심과 차량 사이의 횡방향 편차 |
| `relative_yaw_angle` | 차량 방향과 차선 기준 방향 사이의 상대 요각 |
| `V_x` | 차량 종방향 속도 |
| `X` | 차량의 전역 X 좌표 |
| `Y` | 차량의 전역 Y 좌표 |

주요 출력은 다음과 같습니다.

| Signal | Description |
|---|---|
| `Steering_Angle` | 최종 조향각 명령 |
| `Longitudinal_Velocity` | Stateflow가 결정한 목표 종방향 속도 |

전체 제어 흐름은 다음과 같습니다.

```text
Vehicle Position (X, Y)
        |
        v
Stateflow Gain Scheduling
        |
        +---- Lateral PID Gains
        +---- Yaw PID Gains
        +---- Target Velocity

Lateral Deviation ---> Lateral PID ----+
                                       +---> Saturation ---> Steering Angle
Relative Yaw Angle --> Yaw PID --------+
```

![Controller Architecture](images/controller_architecture.png)

---

## 4. Lateral Control

횡방향 편차를 줄이기 위해 PID 제어기를 구성하였습니다.

```text
e_y
 |
 +--> Kp_lat * e_y
 |
 +--> Ki_lat * integral(e_y)
 |
 +--> Kd_lat * derivative(e_y)
 |
 v
Lateral Control Output
```

PID 출력에는 차량 속도에 따라 계산되는 Gain Factor를 적용하여 속도 변화에 따른 조향 민감도를 조정하였습니다.

![Lateral PID](images/lateral_pid.png)

---

## 5. Yaw Angle Control

차량 진행 방향과 차선 방향 사이의 상대 요각 오차를 줄이기 위해 별도의 PID 제어기를 구성하였습니다.

```text
e_psi
 |
 +--> Kp_yaw * e_psi
 |
 +--> Ki_yaw * integral(e_psi)
 |
 +--> Kd_yaw * derivative(e_psi)
 |
 v
Yaw Control Output
```

Lateral PID와 Yaw PID의 출력을 합산한 후 Saturation을 적용하여 최종 조향각을 생성합니다.

![Yaw PID](images/yaw_pid.png)

---

## 6. Gain Scheduling with Stateflow

Stateflow는 차량의 현재 위치 `X`, `Y`를 이용하여 주행 구간을 판별합니다.

각 상태에서는 다음 파라미터를 변경합니다.

- Target longitudinal velocity
- Lateral PID gains
- Yaw PID gains

확인된 주행 상태는 다음과 같습니다.

| State | Target Velocity |
|---|---:|
| `Speed_15` | 15 km/h |
| `Speed_20` | 20 km/h |
| `Speed_30` | 30 km/h |
| `Speed_50` | 50 km/h |

상태 전환은 `check_position()` 함수를 이용해 차량이 지정된 좌표와 허용 반경 내에 도달했는지를 판단하여 수행합니다.

![Stateflow Gain Scheduling](images/stateflow_gain_scheduling.png)

---

## 7. Steering Command

최종 조향각은 다음과 같이 생성됩니다.

```text
Steering Angle
=
Lateral PID Output
+
Yaw PID Output
```

합산된 조향 명령에는 Saturation을 적용하여 과도한 조향 입력을 제한합니다.

---

## 8. Simulation Results

다음 항목을 이용하여 LKAS 성능을 평가합니다.

- Lateral deviation
- Relative yaw angle
- Steering angle
- Longitudinal velocity
- Vehicle trajectory

### 8.1 Lateral Deviation

![Lateral Error](images/lateral_error.png)

### 8.2 Relative Yaw Angle

![Yaw Error](images/yaw_error.png)

### 8.3 Steering Angle

![Steering Angle](images/steering_angle.png)

### 8.4 Longitudinal Velocity

![Longitudinal Velocity](images/longitudinal_velocity.png)

### 8.5 Vehicle Path

![Vehicle Path](images/vehicle_path.png)

---

## 9. Performance Metrics

| Metric | Result |
|---|---:|
| Maximum lateral deviation | TBD |
| RMS lateral deviation | TBD |
| Maximum relative yaw error | TBD |
| Maximum steering angle | TBD |
| Steady-state lateral error | TBD |

결과값은 시뮬레이션 로그 분석 후 업데이트할 예정입니다.

---

## 10. Key Contributions

- Lateral deviation 및 yaw angle을 이용한 병렬 복합 PID 제어 구현
- Stateflow 기반 위치별 목표 속도 및 PID Gain Scheduling
- 차량 속도 기반 Gain Factor 적용
- Steering Angle Saturation 적용
- 차량 위치 기반 주행 시나리오 전환 구현

---

## 11. Limitations and Future Work

- PID 적분기 Anti-windup 적용
- Steering rate limit 추가
- 미분항 Low-pass filter 적용
- Stateflow 좌표 및 PID 게인의 외부 파라미터화
- 직선 및 곡선 구간별 정량적 성능 비교
- 차량 경로 Animation 및 GIF 생성
- CAN 신호 기반 제어기 인터페이스 확장