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