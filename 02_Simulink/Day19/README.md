# Day19 - Cruise Control Error Calculation

## 목표

Cruise Control(ACC)의 기본 원리를 이해하였다.

목표 속도(Target Speed)와 현재 속도(Current Speed)의 차이를 계산하여 차량이 얼마나 가속 또는 감속해야 하는지를 계산하는 구조를 구현하였다.

---

## 모델 구성

Constant(Target Speed)

↓

Constant(Current Speed)

↓

Sum(Error)

↓

Gain(Control Output)

↓

Display

---

## 학습 내용

- Target Speed
- Current Speed
- Error Calculation
- Gain
- Feedback Control

---

## 자동차에서 사용하는 곳

ACC(Adaptive Cruise Control)

↓

목표속도와 현재속도의 차이를 계산

↓

Throttle 제어량 생성

↓

차량 가속

---

## 느낀 점

자동차 제어는 단순히 속도를 입력하는 것이 아니라 목표와 현재 상태의 차이를 계산하여 제어량을 결정한다는 점을 이해하였다.