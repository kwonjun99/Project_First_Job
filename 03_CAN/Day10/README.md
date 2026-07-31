# Day10 - CAN Sender와 Receiver

## 학습 목표

- CAN Sender와 Receiver 이해
- ECU 간 데이터 흐름 이해
- 실제 차량에서 데이터가 어떻게 공유되는지 이해

---

## Sender

Sender는 CAN 메시지를 전송하는 ECU이다.

예)

Engine ECU

↓

RPM

Speed

Temperature

---

## Receiver

Receiver는 CAN 메시지를 수신하는 ECU이다.

예)

Cluster ECU

↓

RPM 표시

Transmission ECU

↓

변속 계산

ABS ECU

↓

속도 계산

---

## 하나의 Sender

Engine ECU는

하나의 CAN 메시지를 여러 ECU에게 동시에 전송한다.

Cluster ECU

Transmission ECU

ADAS ECU

ABS ECU

등은 필요한 Signal만 읽는다.

Engine ECU (Sender)

↓

CAN Bus

↓

Cluster ECU

Transmission ECU

ABS ECU

ADAS ECU
---

## 자동차에서의 활용

실제 차량에서는

Engine ECU가 송신한 데이터를

계기판

변속기

ADAS

브레이크 시스템

공조 시스템

등이 동시에 사용한다.

이를 통해 ECU 간 데이터 공유가 이루어진다.

---

## 오늘 배운 내용

- Sender
- Receiver
- ECU 데이터 흐름
- CAN Broadcast 구조