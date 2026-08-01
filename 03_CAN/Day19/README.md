# Day19 - UDS (Unified Diagnostic Services)

## 학습 목표

- UDS의 개념 이해
- CAN과 UDS의 차이 이해
- 주요 UDS Service ID 학습

---

## UDS란?

UDS는 자동차 ECU를 진단하기 위한 표준 통신 프로토콜이다.

UDS는 CAN Bus를 통해 ECU와 통신하며 차량 점검, 고장 진단, ECU 정보 조회 등에 사용된다.

---

## 주요 Service ID

- 0x10 : Diagnostic Session Control
- 0x11 : ECU Reset
- 0x22 : Read Data By Identifier
- 0x2E : Write Data By Identifier
- 0x19 : Read DTC
- 0x14 : Clear DTC

---

## 자동차에서의 활용

정비소에서 OBD 진단기를 연결하면 UDS를 이용하여 ECU와 통신한다.

가능한 작업

- ECU 정보 조회
- 센서 데이터 조회
- 고장 코드(DTC) 읽기
- 고장 코드 삭제
- ECU 리셋

---

## CAN과 UDS의 차이

CAN은 데이터를 전달하는 통신 방식이고,

UDS는 CAN 위에서 동작하는 진단 프로토콜이다.

---

## 오늘 배운 내용

- UDS
- Service ID
- ECU 진단
- OBD 진단