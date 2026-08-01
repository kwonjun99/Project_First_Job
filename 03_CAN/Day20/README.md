# Day20 - OBD-II와 DTC

## 학습 목표

- OBD-II의 개념 이해
- DTC(Diagnostic Trouble Code) 이해
- CAN, UDS, OBD-II 관계 이해

---

## OBD-II

OBD-II는 차량 진단을 위한 국제 표준 시스템이다.

정비사는 OBD-II 커넥터를 통해 차량 ECU와 통신한다.

---

## OBD-II로 가능한 작업

- DTC 읽기
- DTC 삭제
- ECU 정보 조회
- 센서 데이터 조회
- 차량 정보(VIN) 조회

---

## DTC

DTC는 Diagnostic Trouble Code의 약자이며 차량의 고장 정보를 저장하는 코드이다.

예시

- P0300 : Misfire
- P0101 : MAF Sensor Error
- P0420 : Catalyst Efficiency

---

## DTC 분류

- P : Powertrain
- B : Body
- C : Chassis
- U : Network

---

## 통신 구조

OBD-II

↓

CAN

↓

UDS

↓

ECU

---

## 오늘 배운 내용

- OBD-II
- DTC
- 진단 시스템
- 차량 정비 통신