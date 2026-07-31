# Day13 - CAN Bit Error

## 학습 목표

- CAN Error Detection의 필요성 이해
- Bit Error의 개념 이해
- CAN이 통신 오류를 어떻게 감지하는지 학습

---

## CAN Error Detection

자동차 CAN은 신뢰성 높은 통신을 위해 여러 가지 오류 검출 기능을 제공한다.

대표적인 Error 종류

- Bit Error
- Stuff Error
- CRC Error
- Form Error
- ACK Error

---

## Bit Error

송신 ECU가 보낸 비트와 실제 CAN Bus에서 읽힌 비트가 다를 때 발생하는 오류이다.

예)

송신

1

↓

Bus

0

↓

Bit Error 발생

---

## 발생 원인

- 노이즈
- 배선 이상
- 접촉 불량
- 전자파 간섭

---

## 자동차에서의 활용

CAN Controller는 Bit Error를 감지하면 해당 메시지를 무시하지 않고 자동으로 재전송(Retry)한다.

이를 통해 ECU 간 데이터 신뢰성을 유지한다.

---

## 오늘 배운 내용

- CAN Error Detection
- Bit Error
- 통신 신뢰성
- Retry