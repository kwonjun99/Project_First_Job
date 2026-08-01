# Day21 - CANoe 기초

## 학습 목표

- CANoe의 역할 이해
- Trace Window 읽는 방법 학습
- CAN 로그 분석 기초 이해

---

## CANoe란?

CANoe는 Vector에서 개발한 자동차 네트워크 분석 및 테스트 프로그램이다.

자동차 ECU 간 CAN 통신을 모니터링하고 테스트하는 데 사용된다.

---

## 주요 기능

- CAN 메시지 모니터링
- Trace 분석
- ECU 시뮬레이션
- UDS 테스트
- 오류 분석

---

## Trace Window

Trace Window는 CAN 메시지를 시간 순서대로 표시한다.

예시

Time | ID | DLC | DATA

0.010 | 0x100 | 8 | 78 00 5F 64 00 00 00 00

---

## 로그 확인 순서

1. Time 확인
2. ID 확인
3. DLC 확인
4. DATA 확인
5. DBC와 비교하여 데이터 해석

---

## 오늘 배운 내용

- CANoe
- Trace Window
- CAN 로그 분석
- ECU 테스트