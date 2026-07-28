# Day29 - Lane Keeping Assist(LKA) 기본 제어

## 학습 목표

- Lane Keeping Assist(LKA)의 기본 원리 이해
- 차선 오차(Lane Error) 계산
- Gain을 이용한 Steering 제어
- 차량이 차선 중앙으로 복귀하는 과정 이해

---

## 실습 내용

이번 실습에서는 차량이 차선 중앙을 유지하도록 하는 가장 기본적인 LKA 제어기를 구성하였다.

차선 중앙은 0m로 가정하고,

차량이 오른쪽 또는 왼쪽으로 벗어나면

오차(Error)를 계산하여

Steering 입력을 생성한다.

---

## 블록 구성

Constant (Lane Center = 0)

↓

Sum (Lane Error)

↓

Gain (Steering Gain)

↓

Transfer Function

↓

Scope

↓

Feedback

---

## 제어 원리

Lane Error

= 목표 차선 - 현재 차량 위치

오차가 발생하면

Gain을 통해 Steering Angle을 계산한다.

Steering이 발생하면

차량은 다시 차선 중앙으로 복귀한다.

---

## 실습 결과

Gain 값이 작으면

차량은 천천히 복귀한다.

Gain 값이 너무 크면

차량이 좌우로 흔들리며

Overshoot가 발생한다.

적절한 Gain을 선택해야

안정적인 차선 유지가 가능하다.

---

## 자동차에서의 활용

LKA는

전방 카메라가 차선을 인식하고

차량 위치를 계산한 뒤

Steering ECU에 조향 명령을 전달한다.

실제 현대자동차와 HL만도에서도

동일한 기본 구조를 사용한다.

---

## 오늘 배운 내용

✔ Lane Error

✔ Steering Gain

✔ Feedback Control

✔ LKA 기본 원리

✔ Gain에 따른 차량 응답 변화