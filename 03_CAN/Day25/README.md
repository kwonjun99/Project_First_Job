# Day25 - CAN Error Log Analysis

## 학습 목표

- CAN 오류 로그 읽기
- Error 종류 이해
- CAN 재전송 과정 이해

---

## 주요 Error

- ACK Error
- CRC Error
- Bit Error
- Stuff Error
- Form Error

---

## ACK Error

수신 ECU가 ACK를 보내지 않은 경우 발생한다.

CAN Controller는 자동으로 메시지를 다시 전송한다.

---

## CRC Error

데이터가 전송 중 손상되었음을 의미한다.

---

## Bit Error

송신한 비트와 읽은 비트가 다를 경우 발생한다.

---

## 로그 분석 순서

TX

↓

Error 발생

↓

Retry

↓

TX Success

---

## 실무 활용

품질 엔지니어는 CANoe Trace에서 Error 발생 시점과 종류를 분석하여 통신 문제의 원인을 찾는다.

---

## 오늘 배운 내용

- ACK Error
- CRC Error
- Bit Error
- Retry
- Error Log Analysis
