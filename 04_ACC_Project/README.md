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

#Feature5

PID 출력에 Saturation을 적용하여
실제 차량처럼 가속/감속 제한을 구현하였다.

Feature6

차량 속도를 적분하여
차량 위치를 계산하였다.

앞차 위치와 내 차량 위치의 차이를
상대거리로 계산하였다.