# Day22 - CAN 로그 분석

## 학습 목표

- CAN Trace 로그 해석
- DBC를 이용한 데이터 해석
- 실제 물리값 계산

---

## 로그 분석 순서

1. Time 확인
2. ID 확인
3. DLC 확인
4. DATA 확인
5. DBC 적용
6. 실제 물리값 계산

---

## 예시

Time : 0.010

ID : 0x100

DLC : 8

DATA : 78 00 5F 64 00 00 00 00

↓

0x78 = 120

↓

Speed = 120 km/h

---

## 실무에서의 활용

품질 및 제어 엔지니어는 CANoe Trace 로그를 분석하여 ECU가 정상적으로 데이터를 송수신하는지 확인한다.

DBC 파일을 기준으로 DATA를 실제 물리값으로 변환하여 차량 상태를 분석한다.

---

## 오늘 배운 내용

- CAN Trace
- DBC 적용
- Hex → Decimal 변환
- CAN 로그 해석