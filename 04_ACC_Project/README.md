# Adaptive Cruise Control Project

## Feature 1 - Vehicle Speed Control

### 목표

PID Controller를 이용하여 차량이 목표 속도(100 km/h)를 추종하도록 구현하였다.

---

## 모델 구성

Target Speed

↓

PID Controller

↓

Vehicle Model (Transfer Function)

↓

Vehicle Speed

↓

Feedback

---

## 사용 블록

- Constant
- Sum
- PID Controller
- Transfer Function
- Scope

---

## 전달함수

G(s) = 1 / (2s + 1)

---

## PID 초기값

P = 1

I = 0

D = 0

---

## 결과

차량 속도가 100 km/h에 안정적으로 수렴하는 것을 확인하였다.

(Feature 2에서 PID를 추가 튜닝할 예정)

# Feature 2 - Lead Vehicle Model

## 목표

앞차 속도를 추가하여 ACC의 기본 구조를 구현하였다.

---

## 추가된 블록

- Constant (Lead Vehicle Speed)
- Manual Switch

---

## 동작

Switch 위

↓

운전자 목표속도(100km/h)

Switch 아래

↓

앞차 속도(80km/h)

---

## 결과

ACC가 운전자 속도와 앞차 속도 중 하나를 선택할 수 있는 기본 구조를 완성하였다.

# Feature 3 - Distance Decision Logic

## 목표

앞차와의 거리를 이용하여 목표 속도를 자동으로 변경하도록 구현하였다.

---

## 사용 블록

- Constant (Distance)
- Compare To Constant
- Switch

---

## 조건

Distance < 30m

↓

Lead Vehicle Speed

Distance ≥ 30m

↓

Driver Target Speed

---

## 결과

거리 조건에 따라 목표 속도가 자동으로 변경되는 기본 ACC 판단 로직을 구현하였다.

Feature4

Signal Editor를 이용하여 앞차 거리가
시간에 따라 변하는 시나리오를 구현하였다.

## Feature 5

### Signal Naming

프로젝트의 가독성을 높이기 위해 주요 신호 이름을 지정하였다.

Target_Speed

Vehicle_Speed

또한 Target Speed와 Vehicle Speed를 각각 Scope에서 확인할 수 있도록 구성하였다.

## Feature 6

### PID Tuning

P Controller에서 PI Controller로 변경하였다.

P = 0.8

I = 0.2

D = 0

Vehicle Speed가 보다 부드럽게 목표속도에 수렴하도록 개선하였다.

또한 Mux를 이용하여 Target Speed와 Vehicle Speed를 하나의 Scope에서 비교하였다.

# Feature 7

## ACC ON / OFF

이번 기능에서는 운전자가 ACC를 사용할지 직접 운전할지를 선택할 수 있도록 Manual Switch를 추가하였다.

### 구성

Distance
↓

Compare (<30)

↓

Switch

↓

Target_Speed

↓

Manual Switch

↓

Sum

↓

PID

↓

Vehicle

### 동작

- Manual Switch ON
  - ACC가 계산한 Target Speed 사용

- Manual Switch OFF
  - Driver Target Speed(100km/h) 사용

이를 통해 ACC 사용 여부를 자유롭게 전환할 수 있도록 구성하였다.

---

# Feature 8

## Stateflow 준비

다음 단계에서는 Manual Switch를 Stateflow가 자동으로 제어하도록 만들 예정이다.

이번 Feature에서는 Stateflow Chart를 생성하고

ACC_OFF

↓

ACC_ON

상태를 설계하였다.

현재는 Manual Switch가 동작하지만 다음 단계부터 Stateflow가 이를 대신하게 된다.

# Feature 9

## Stateflow 기반 ACC 상태 제어

### 목적

기존에는 Manual Switch를 직접 클릭하여 ACC를 ON/OFF하였다.

실제 차량에서는 운전자 입력과 브레이크 입력을 기반으로 ACC가 자동으로 상태를 변경한다.

이를 위해 Stateflow를 추가하였다.

---

### 상태

ACC_OFF

ACC_ON

---

### 상태 전이

ACC_Button == 1

↓

ACC_ON

Brake == 1

↓

ACC_OFF

---

### 출력

ACC_Enable (Boolean)

ACC_OFF → false

ACC_ON → true

다음 Feature에서는 ACC_Enable을 Manual Switch와 연결하여 자동으로 ACC를 제어할 예정이다.

# Feature 10

## Stateflow와 속도 제어 연결

기존 Manual Switch를 제거하고 일반 Switch를 사용하였다.

Stateflow에서 생성한 ACC_Enable 신호를 이용하여

ACC OFF

→ Driver Target Speed

ACC ON

→ ACC Target Speed

를 자동으로 선택하도록 구현하였다.

이로써 운전자 입력 없이 ACC 상태에 따라 목표속도가 자동으로 변경된다.

# Feature 11

## Ego Vehicle Position Calculation

### 목적

Adaptive Cruise Control은 단순히 속도만 제어하는 시스템이 아니라 차량의 위치를 기반으로 앞차와의 상대거리를 계산한다.

이번 Feature에서는 Ego Vehicle(자차)의 위치를 계산하였다.

---

### 구성

Vehicle_Speed

↓

Integrator

↓

Ego_Position

---

### 동작원리

차량 속도를 적분하면 이동거리가 계산된다.

Position = ∫ Velocity dt

이를 이용하여 자차의 위치(Ego Position)를 계산하였다.

---

### 확인

Vehicle Speed Scope

↓

속도 확인

Ego Position Scope

↓

차량 위치가 시간에 따라 계속 증가하는 것을 확인

# Feature 12

## Lead Vehicle Position Calculation

### 목적

앞차의 위치를 계산하기 위해 Lead Vehicle Speed를 적분하였다.

이를 통해 Ego Vehicle과 Lead Vehicle의 실제 상대거리를 계산할 준비를 완료하였다.

---

### 구성

Lead Vehicle Speed

↓

Integrator

↓

Lead_Position

↓

Scope

---

### 원리

Lead Vehicle의 속도를 적분하여 위치를 계산하였다.

Lead Position = ∫ Lead Speed dt

다음 Feature에서는

Actual Distance

=

Lead Position

-

Ego Position

을 구현할 예정이다.
# Feature 13

## Actual Distance Calculation

### 목적

기존에는 Repeating Sequence를 이용하여
앞차와의 거리를 가상으로 생성하였다.

이번 Feature에서는

Lead Position

-

Ego Position

을 이용하여 실제 상대거리를 계산하였다.

---

### 구성

Lead Speed

↓

Integrator

↓

Lead Position

↓

+

↓

Sum

↓

Actual Distance

↑

-

↓

Ego Position

---

### 계산식

Actual Distance

=

Lead Position

-

Ego Position

---

### 확인

Repeating Sequence

↓

가상거리

Actual Distance

↓

실제 계산거리

두 값을 비교하여

향후 Repeating Sequence를 제거할 준비를 완료하였다.