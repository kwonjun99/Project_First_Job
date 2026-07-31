# Day17 - CAN FD

## 학습 목표

- CAN FD의 개념 이해
- 기존 CAN과 CAN FD의 차이 이해
- CAN FD가 필요한 이유 이해

---

## 기존 CAN

기존 CAN은 최대 8Byte의 데이터를 전송할 수 있다.

일반적인 ECU 간 통신에는 충분하지만 ADAS와 전기차에는 한계가 있다.

---

## CAN FD

CAN FD(Flexible Data-rate)는 기존 CAN을 확장한 통신 방식이다.

특징

- 최대 64Byte 전송
- 더 높은 통신 속도
- 대용량 데이터 처리 가능

---

## CAN와 CAN FD 비교

| 항목 | CAN | CAN FD |
|------|-----|--------|
| 최대 데이터 | 8 Byte | 64 Byte |
| 최대 속도 | 약 1 Mbps | 최대 8 Mbps |

---

## 자동차에서의 활용

CAN FD는 다음과 같은 시스템에서 많이 사용된다.

- ADAS
- 전기차(BMS)
- 인버터
- 모터 제어
- 자율주행 센서

---

## 오늘 배운 내용

- CAN FD
- 64Byte 데이터
- 고속 통신
- 차세대 차량 네트워크