# Day16 - CAN Bus-Off Recovery

## 학습 목표

- Bus-Off Recovery 이해
- CAN Controller의 복구 과정 이해
- 자동차 CAN의 안정성 이해

---

## Bus-Off

오류가 너무 많이 발생하면 CAN Controller는 Bus-Off 상태가 된다.

이 상태에서는 CAN 메시지를 송신하지 않는다.

---

## Recovery

Bus-Off가 된 ECU는 일정 조건을 만족하면 다시 CAN Bus에 참여한다.

이를 Bus-Off Recovery라고 한다.

Recovery 이후 ECU는 정상적인 CAN 통신을 다시 수행한다.

---

## Recovery 과정

정상

↓

오류 증가

↓

Bus-Off

↓

일정 시간 대기

↓

Recovery

↓

Error Active

---

## 자동차에서의 활용

실제 차량에서는 순간적인 노이즈나 배선 문제로 인해 Bus-Off가 발생할 수 있다.

문제가 해결되면 CAN Controller가 자동으로 Recovery를 수행하여 ECU가 다시 네트워크에 참여한다.

이를 통해 차량은 일시적인 오류에도 안정적으로 동작할 수 있다.

---

## 오늘 배운 내용

- Bus-Off
- Recovery
- CAN Controller Reset
- 네트워크 재참여
- CAN 안정성