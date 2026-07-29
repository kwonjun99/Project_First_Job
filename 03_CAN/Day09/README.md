# Day09 - 여러 Signal을 하나의 CAN Frame에 저장하기

## 학습 목표

- 하나의 CAN Frame에 여러 Signal이 저장되는 구조 이해
- ECU가 필요한 Signal만 읽는 원리 이해
- CAN 통신 효율 향상 방법 이해

---

## 하나의 CAN Frame

실제 자동차에서는 하나의 CAN Frame에 여러 Signal을 저장한다.

예)

RPM

Vehicle Speed

Coolant Temperature

Throttle Position

---

## 예시

Byte0~1

↓

RPM

Byte2

↓

Speed

Byte3

↓

Temperature

Byte4

↓

Throttle Position

---

## 왜 여러 Signal을 함께 저장할까?

CAN Bus의 통신 효율을 높이기 위해서이다.

여러 Signal을 하나의 Frame에 담으면 전송 횟수가 줄어들고 ECU들이 필요한 데이터만 선택하여 사용할 수 있다.

BUS Load 감소시키기 위해서.

---

## 자동차에서의 활용

Engine ECU는 하나의 CAN Frame 안에 여러 차량 정보를 함께 전송한다.

각 ECU는 같은 CAN Frame을 수신하더라도 필요한 Signal만 추출하여 사용한다.

예)

- Cluster ECU → RPM
- ABS ECU → Speed
- TCU → RPM + Speed

---

## 오늘 배운 내용

- CAN Frame 내부 Signal 배치
- 여러 Signal 동시 전송
- ECU별 Signal 선택
- CAN 통신 효율