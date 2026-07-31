# Day12 - CAN Event Message

## 학습 목표

- Periodic Message와 Event Message의 차이 이해
- Event 방식이 필요한 이유 이해
- 실제 차량에서 어떤 Signal이 Event 방식인지 이해

---

## Periodic Message

일정한 주기로 계속 전송하는 CAN 메시지이다.

예)

- Engine RPM
- Vehicle Speed
- Steering Angle

---

## Event Message

상태가 변하는 순간에만 전송하는 CAN 메시지이다.

예)

- Door Open
- Gear Position
- Airbag Deploy
- Hazard Lamp

---

## 자동차에서의 활용

자동차는 CAN Bus 사용량을 줄이기 위해 Event Message를 적극적으로 사용한다.

문이 계속 닫혀 있는 상태에서는 Door Status를 반복해서 보내지 않고,

문이 열리거나 닫히는 순간에만 메시지를 전송한다.

반면 Engine RPM과 Vehicle Speed는 실시간 제어가 필요하므로 일정한 주기로 반복 전송한다.

RPM은 왜 Periodic인가?
"엔진 회전수는 실시간으로 계속 변하기 때문에 ECU들이 항상 최신 값을 받아야 하므로 Periodic Message를 사용한다."
---

## 오늘 배운 내용

- Periodic Message
- Event Message
- CAN Bus Load 감소
- 실시간 제어와 이벤트 기반 통신