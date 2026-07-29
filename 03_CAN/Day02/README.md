# Day02 - CAN Frame 구조 이해

## 학습 목표

- CAN Frame 구조 이해
- CAN ID의 의미 이해
- DLC(Data Length Code) 이해
- DATA 영역이 실제 차량 데이터를 저장하는 방식 이해

---

## CAN Frame

CAN 메시지는 여러 필드(Field)로 구성된다.

대표적으로

- CAN ID
- DLC
- DATA

를 사용한다.

---

## CAN ID

CAN ID는

메시지를 송신하는 ECU를 구분하기 위한 식별자이다.

예를 들어

0x100

↓

Engine ECU

0x200

↓

Transmission ECU

0x300

↓

ABS ECU

처럼 ECU마다 고유한 ID를 가진다.

---

## DLC

DLC(Data Length Code)는

DATA 영역의 크기를 의미한다.

예를 들어

DLC = 8

이면

8Byte의 데이터를 전송한다.

---

## DATA

DATA에는

실제 차량 정보가 저장된다.

예시

RPM

Speed

Temperature

Brake Pressure

Steering Angle

등이 저장된다.

---

## 오늘 배운 내용

✔ CAN Frame

✔ CAN ID

✔ DLC

✔ DATA

✔ ECU 간 데이터 송수신 원리

---

## 자동차 제어와의 연관성

자동차의 ECU는

CAN Frame을 이용하여

차량 속도

엔진 RPM

온도

브레이크 상태

등의 데이터를 실시간으로 주고받는다.

CAN Frame을 이해하는 것은

자동차 제어 소프트웨어 개발의 가장 기본적인 과정이다.

#quiz
RPM

3500

Speed

120

Temperature

95
CAN 형태로 적어보기.
->
ID

0x100

DLC

8

DATA

0D AC 78 5F 00 00 00 00