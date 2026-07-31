# Day11 - CAN Cycle Time

## 학습 목표

- CAN Cycle Time의 개념 이해
- Signal별 전송 주기 이해
- 실시간 데이터와 저속 데이터의 차이 이해

---

## Cycle Time이란?

Cycle Time은 CAN 메시지를 일정한 시간(ms) 간격으로 반복 전송하는 주기이다.

예)

Engine RPM

↓

10ms마다 전송

---

## 왜 필요한가?

자동차의 센서 값은 실시간으로 변한다.

RPM

Vehicle Speed

Steering Angle

등은 매우 빠르게 변화하기 때문에 짧은 주기로 전송해야 한다.

반면 Door Status나 Air Conditioning 상태는 자주 변하지 않으므로 긴 주기로도 충분하다.

---

## 예시

- Engine RPM → 10ms
- Vehicle Speed → 10ms
- Steering Angle → 20ms
- Door Status → 100ms
- Air Conditioning → 500ms

---

## 자동차에서의 활용

DBC 파일에는 각 CAN 메시지의 Cycle Time이 정의되어 있다.

ECU는 해당 주기에 맞추어 데이터를 송신하며, 다른 ECU는 이를 수신하여 제어에 활용한다.

Cycle Time을 적절히 설정하면 실시간 성능과 CAN Bus 부하를 균형 있게 유지할 수 있다.

---

## 오늘 배운 내용

- CAN Cycle Time
- 주기적 메시지 송신
- 실시간 데이터
- Bus Load
- Signal별 전송 주기