# Day05 - Little Endian과 Big Endian

## 학습 목표

- Endian 개념 이해
- Big Endian과 Little Endian의 차이 이해
- 동일한 데이터가 저장 순서에 따라 달라지는 이유 이해
- 실제 자동차 CAN 통신에서 Endian이 왜 중요한지 이해

---

## Endian이란?

Endian은 여러 Byte로 이루어진 데이터를 메모리에 저장하는 순서를 의미한다.

자동차 ECU마다 사용하는 MCU 구조가 다를 수 있으므로, 데이터 저장 방식도 달라질 수 있다.

---

## Big Endian

Big Endian은 상위 Byte(MSB)를 먼저 저장한다.

예)

RPM = 4000

0x0FA0

↓

0F A0

---

## Little Endian

Little Endian은 하위 Byte(LSB)를 먼저 저장한다.

예)

RPM = 4000

0x0FA0

↓

A0 0F

---

## 자동차에서의 활용

실제 CAN 통신에서는 DBC(Database CAN) 파일에 각 Signal의 Endian이 정의되어 있다.

ECU는 해당 규칙에 따라 데이터를 해석해야 하며, Endian을 잘못 적용하면 완전히 다른 값으로 해석된다.

예를 들어 RPM 4000을 Little Endian으로 보내야 하는데 Big Endian으로 읽으면 잘못된 RPM 값이 계산된다.

---

## 오늘 배운 내용

- Endian
- Big Endian
- Little Endian
- Byte 순서
- CAN 데이터 저장 방식