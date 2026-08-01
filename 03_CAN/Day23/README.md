# Day23 - DBC 파일 읽기

## 학습 목표

- DBC 파일 구조 이해
- Message와 Signal 구분
- Start Bit와 Length 이해

---

## DBC란?

DBC(Database CAN)는 CAN 데이터를 사람이 이해할 수 있도록 정의한 파일이다.

---

## Message

BO_

메시지 정보

- CAN ID
- DLC
- Sender

---

## Signal

SG_

신호 정보

- Signal Name
- Start Bit
- Length
- Factor
- Offset
- Unit

---
문제

SG_ RPM

8|16

(1,0)

rpm

정답

항목	답
Signal	RPM
Start Bit	8
Length	16 bit
Unit	rpm
## 실무 활용

CANoe Trace 로그를 DBC와 함께 분석하여 Speed, RPM, Temperature 등 실제 물리값으로 변환한다.

---

## 오늘 배운 내용

- DBC
- Message
- Signal
- Start Bit
- Length
- Unit