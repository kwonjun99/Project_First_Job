# Day04 - CAN DATA(Byte) 해석

## 학습 목표

- CAN DATA 영역의 구조 이해
- Byte 단위 데이터 해석
- 16진수 데이터를 실제 차량 정보로 변환
- ECU가 데이터를 주고받는 방식 이해

---

## CAN DATA

CAN 메시지의 DATA 영역은 최대 8Byte로 구성된다.

예)

09 C4 64 5A 00 00 00 00

각 Byte에는 차량 정보가 저장된다.

---

## 예시

Byte0 + Byte1

↓

RPM

Byte2

↓

Vehicle Speed

Byte3

↓

Engine Temperature

---

## 데이터 해석

09 C4

↓

0x09C4

↓

2500 RPM

64

↓

0x64

↓

100 km/h

5A

↓

0x5A

↓

90℃

---

## 자동차에서의 활용

실제 Engine ECU는

엔진 회전수(RPM)

차량 속도

냉각수 온도

스로틀 개도

등을 CAN DATA에 저장하여 전송한다.

다른 ECU는 필요한 Byte만 읽어 자신의 기능에 활용한다.

예를 들어

- Cluster ECU → RPM 표시
- Transmission ECU → 변속 제어
- ADAS ECU → 차량 속도 참조

---

## 오늘 배운 내용

- CAN DATA 구조
- Byte 단위 데이터 저장
- 16진수와 10진수 변환
- 차량 센서 데이터 해석
- ECU 간 데이터 공유 방식