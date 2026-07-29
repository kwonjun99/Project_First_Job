# Day07 - DBC(Database CAN) 이해

## 학습 목표

- DBC(Database CAN)의 개념 이해
- DBC가 필요한 이유 이해
- CAN 데이터를 사람이 읽을 수 있는 값으로 변환하는 과정 학습

---

## DBC란?

DBC(Database CAN)는 CAN 메시지의 구조와 의미를 정의한 데이터베이스 파일이다.

CAN 데이터만으로는 각 Byte가 어떤 의미를 가지는지 알 수 없기 때문에 DBC를 사용한다.

---

## DBC에 포함되는 정보

- CAN ID
- Signal Name
- Start Bit
- Signal Length
- Scaling
- Offset
- Unit
- 송신 ECU
- 수신 ECU

---

## 예시

CAN ID

0x100

↓

Engine ECU

Byte0~1

↓

Engine Speed

Scaling

0.25

↓

RPM 계산

---

## 자동차에서의 활용

실제 자동차 개발에서는 Vector CANoe나 CANalyzer에서 DBC 파일을 불러와 CAN 로그를 자동으로 해석한다.

DBC가 없으면 CAN 데이터는 단순한 16진수(Byte)의 나열일 뿐이며, 사람이 의미를 파악하기 어렵다.

DBC를 통해

- 엔진 회전수(RPM)
- 차량 속도(Speed)
- 냉각수 온도(Coolant Temperature)
- 조향각(Steering Angle)

등을 실시간으로 확인할 수 있다.
DBC예시
Signal Name : Engine Speed

CAN ID      : 0x100

Start Bit   : 0

Length       : 16 bit

Scaling      : 0.25

Offset       : 0

Unit         : rpm

Sender ECU   : Engine ECU

Receiver ECU : Cluster ECU
---

## 오늘 배운 내용

- DBC(Database CAN)
- Signal 정의
- CAN 데이터 해석
- Scaling
- Offset
- 실제 자동차 CAN 분석 과정