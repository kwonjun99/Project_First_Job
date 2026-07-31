# Day18 - CAN과 LIN 비교

## 학습 목표

- CAN과 LIN의 차이 이해
- 자동차에서 두 통신을 함께 사용하는 이유 이해

---

## CAN

특징

- 고속 통신
- 높은 신뢰성
- 여러 ECU가 동시에 통신 가능

사용 분야

- Engine ECU
- ABS
- EPS
- ADAS

---

## LIN

특징

- 저속 통신
- 저렴한 비용
- Master 1개와 여러 Slave 구조

사용 분야

- Power Window
- Side Mirror
- Power Seat
- Interior Lamp
- Sunroof

---

## CAN과 LIN 비교

| 항목 | CAN | LIN |
|------|------|------|
| 최대 속도 | 약 1 Mbps | 약 20 Kbps |
| 구조 | Multi-Master | Master-Slave |
| 비용 | 높음 | 낮음 |
| 사용 분야 | 핵심 제어 | 편의 장치 |

---
면접에서 자주 나오는 질문

Q. CAN과 LIN의 차이는 무엇인가요?

좋은 답변 예시

CAN은 빠르고 신뢰성이 높아 엔진·브레이크 같은 핵심 제어에 사용되며, LIN은 저렴한 단일 Master 구조로 창문이나 시트 같은 편의장치 제어에 사용됩니다.
## 오늘 배운 내용

- CAN
- LIN
- Master-Slave
- 차량 네트워크 구성