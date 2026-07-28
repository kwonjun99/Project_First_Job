# Day30 - Stateflow를 이용한 LKA ON/OFF 제어

## 학습 목표

- Stateflow 상태(State) 이해
- LKA ON/OFF 상태 제어
- Turn Signal 입력에 따른 상태 변화 구현
- 자동차 제어 로직 이해

---

## 실습 내용

이번 실습에서는 Stateflow를 이용하여

LKA의 ON/OFF 상태를 구현하였다.

실제 차량에서는

Turn Signal을 켜면

운전자가 차선 변경을 수행한다고 판단하여

LKA 기능을 일시적으로 비활성화한다.

차선 변경이 끝나고

Turn Signal이 꺼지면

LKA는 자동으로 다시 활성화된다.

---

## State 구성

LKA_ON

↓

LKA_OFF

---

## 상태 전환

TurnSignal == 1

↓

LKA_OFF

TurnSignal == 0

↓

LKA_ON

---

## State 내부 동작

LKA_ON

entry:

LKA = 1

LKA_OFF

entry:

LKA = 0

---

## Simulink 구성

Constant (Turn Signal)

↓

Stateflow

↓

Display

---

## 실습 결과

Turn Signal OFF

↓

Display = 1

(LKA 동작)

Turn Signal ON

↓

Display = 0

(LKA 비활성)

---

## 자동차에서의 활용

실제 차량에서는

운전자가 방향지시등을 켜면

차선 변경 의도를 판단한다.

LKA는 Steering 제어를 중단하고

운전자가 자유롭게 차선을 변경할 수 있도록 한다.

차선 변경 완료 후

Turn Signal이 꺼지면

LKA가 다시 활성화되어

차선 중앙을 유지한다.

---

## 오늘 배운 내용

✔ State

✔ Transition

✔ Entry Action

✔ Turn Signal Logic

✔ LKA ON/OFF Control

✔ 자동차 상태기반(State Machine) 제어