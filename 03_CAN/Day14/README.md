# Day14 - CRC Error와 ACK Error

## 학습 목표

- CRC Error 이해
- ACK Error 이해
- CAN 오류 검출 방식 학습

---

## CRC Error

CRC(Cyclic Redundancy Check)는 데이터가 전송 중 손상되었는지를 검사하는 오류 검출 방식이다.

송신 ECU와 수신 ECU는 각각 CRC 값을 계산한다.

두 CRC 값이 다르면 CRC Error가 발생한다.

---

## ACK Error

ACK(Acknowledgement)는 수신 ECU가 메시지를 정상적으로 받았다는 응답이다.

어떤 ECU도 ACK를 보내지 않으면 ACK Error가 발생한다.

---

## 자동차에서의 활용

CAN Controller는

- Bit Error
- CRC Error
- ACK Error

등을 자동으로 감지하며 오류가 발생하면 메시지를 재전송한다.

이를 통해 자동차 네트워크의 높은 신뢰성을 유지한다.

---

## 오늘 배운 내용

- CRC Error
- ACK Error
- 데이터 무결성
- 수신 확인(ACK)
- CAN 재전송