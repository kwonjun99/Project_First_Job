# Day06 - CAN Signal Scaling & Offset

## 학습 목표

- CAN Signal Scaling 이해
- Offset의 역할 이해
- CAN 데이터를 실제 물리량으로 변환하는 방법 학습
- DBC 파일의 Signal 정의 방식 이해

---

## Scaling이란?

CAN은 정수(Byte)만 전송할 수 있기 때문에 소수점이 있는 데이터를 표현하기 위해 Scaling을 사용한다.

공식

실제값 = CAN값 × Scaling

예)

CAN = 355

Scaling = 0.1

↓

35.5℃

---

## Offset이란?

Offset은 계산된 값에 기준값을 더하거나 빼는 기능이다.

공식

실제값 = CAN값 × Scaling + Offset

예)

CAN = 120

Scaling = 1

Offset = -40

↓

80℃

---

## 자동차에서의 활용

실제 차량에서는 거의 모든 CAN Signal이 Scaling과 Offset을 사용한다.

예)

- Engine RPM
- Vehicle Speed
- Coolant Temperature
- Steering Angle
- Battery Voltage

이 값들은 DBC(Database CAN) 파일에 정의되어 있으며, ECU는 해당 규칙에 따라 CAN 데이터를 실제 물리량으로 변환한다.

---

## 오늘 배운 내용

- Scaling
- Offset
- Signal 변환
- DBC Signal 개념
- CAN 데이터의 실제 물리량 해석