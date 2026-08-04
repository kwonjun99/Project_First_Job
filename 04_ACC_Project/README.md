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