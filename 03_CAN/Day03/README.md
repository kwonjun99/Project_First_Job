# Day03 - CAN Arbitration

## 학습 목표

- CAN Arbitration 이해
- CAN ID와 우선순위 이해
- 여러 ECU가 동시에 통신하는 원리 이해

---

## Arbitration이란?

CAN Bus는 하나의 통신선을 여러 ECU가 공유한다.

동시에 여러 ECU가 데이터를 전송하려고 하면

Arbitration을 수행한다.

---

## Arbitration 규칙

CAN ID가 작을수록

우선순위가 높다.

예)

0x080

↓

Airbag

↓

가장 먼저 전송

---

## 예시

Airbag

0x080

↓

Engine

0x100

↓

ABS

0x200

↓

Cluster

0x300

---

## 자동차에서의 활용

실제 차량에서는

Airbag

Brake

Steering

Engine

순으로

높은 우선순위를 가진다.

Door ECU

Window ECU

Lamp ECU

등은

우선순위가 낮다.

---

## 오늘 배운 내용

✔ Arbitration

✔ CAN ID

✔ Priority

✔ ECU 통신 순서

✔ CAN Bus 충돌 방지 원리