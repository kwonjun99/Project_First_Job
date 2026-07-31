# Day15 - CAN Error Counter와 Bus-Off

## 학습 목표

- CAN Error Counter 이해
- Error Active / Passive 이해
- Bus-Off 기능 이해

---

## Error Counter

CAN Controller는 통신 오류가 발생할 때마다 Error Counter를 증가시킨다.

오류 종류

- Bit Error
- CRC Error
- ACK Error

등

---

## CAN 상태

1. Error Active

정상 통신

2. Error Passive

오류 증가

통신 가능

3. Bus-Off

오류가 너무 많아 CAN Controller가 자동으로 통신을 중지한다.

---

## 자동차에서의 활용

고장난 ECU가 계속 잘못된 메시지를 보내면 차량 전체 네트워크에 영향을 줄 수 있다.

CAN은 Bus-Off 기능을 통해 해당 ECU를 네트워크에서 분리하여 시스템의 안정성을 유지한다.

---

## 오늘 배운 내용

- Error Counter
- Error Active
- Error Passive
- Bus-Off
- 네트워크 보호