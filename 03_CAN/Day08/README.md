# Day08 - Start Bit와 Signal Length

## 학습 목표

- Start Bit의 의미 이해
- Signal Length의 의미 이해
- CAN Frame에서 Signal의 위치를 파악하는 방법 학습

---

## Start Bit란?

Start Bit는 CAN 데이터에서 Signal이 시작되는 위치(Bit 번호)를 의미한다.

예를 들어

RPM은 Byte0부터 시작하므로

Start Bit = 0

Speed는 Byte2부터 시작하므로

Start Bit = 16

Temperature는 Byte3부터 시작하므로

Start Bit = 24

이다.

---

## Signal Length란?

Signal Length는 해당 Signal이 사용하는 Bit의 개수이다.

예)

RPM

Byte0 + Byte1

↓

16 bit

Speed

↓

8 bit

Temperature

↓

8 bit

---

## 자동차에서의 활용

DBC 파일에는 모든 Signal의 Start Bit와 Length가 정의되어 있다.

CAN 분석 프로그램은 이 정보를 이용하여 CAN DATA에서 원하는 Signal을 정확히 추출한다.

예를 들어

Engine ECU가 전송한 하나의 CAN Frame 안에는 RPM, Speed, Temperature 등 여러 Signal이 함께 저장될 수 있으며, Start Bit와 Length를 이용해 각각의 데이터를 분리한다.

---

## 오늘 배운 내용

- Start Bit
- Signal Length
- CAN Frame 내부 Signal 배치
- DBC Signal 정의 방법