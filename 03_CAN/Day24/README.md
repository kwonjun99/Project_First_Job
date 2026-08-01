# Day24 - DBC와 CAN 로그 해석

## 학습 목표

- DBC와 CAN 로그를 함께 읽기
- Factor와 Offset 적용하기
- 실제 물리값 계산하기

---

## 로그 해석 순서

1. CAN ID 확인
2. DBC에서 Signal 찾기
3. Start Bit 확인
4. Length 확인
5. Raw Data 추출
6. Factor 적용
7. Offset 적용
8. 실제 물리값 계산

---

## 예제

DATA

78 B8 0B 5F

↓

Speed

0x78 = 120 km/h

↓

RPM

0x0BB8 = 3000 rpm
//RPM은 0~8000rpm 정도까지 표현해야 하므로 8bit(0~255) 로는 부족하다. 따라서 16bit(Byte1~2) 를 사용한다.

↓

Temp

95 - 40 = 55℃

---

## 실무 활용

자동차 품질 및 제어 엔지니어는 CANoe Trace와 DBC를 이용하여 ECU가 정상적인 데이터를 송수신하는지 확인한다.

---

## 오늘 배운 내용

- Raw Data
- Factor
- Offset
- Physical Value
- DBC 적용