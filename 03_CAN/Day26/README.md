# Day26 - CAN Troubleshooting

## 학습 목표

- CAN 통신 문제 분석 방법 이해
- CANoe Trace를 이용한 원인 분석
- 품질 직무에서 사용하는 점검 순서 학습

---

## 점검 순서

1. CAN ID 확인
2. Cycle Time 확인
3. DLC 확인
4. DATA 확인
5. Error 확인
6. DBC 비교

---

## 주요 원인

### ACK Error

- 수신 ECU 미응답
- ECU 전원 문제
- 배선 문제

### CRC Error

- 노이즈
- 데이터 손상

### Cycle Time 이상

- ECU 소프트웨어 문제
- 송신 주기 설정 오류

### ID 불일치

- DBC 설정 오류
- ECU 설정 오류

---

## 실무 적용

품질 엔지니어는 CANoe Trace를 분석하여 통신 장애의 원인을 찾고 ECU 설정, 배선, 네트워크 상태를 확인한다.
실제 면접 질문

"속도계가 0km/h인데 차량은 달리고 있습니다. 어떻게 확인하시겠습니까?"

좋은 답변 예시

먼저 CANoe Trace에서 Speed 메시지(ID)가 정상적으로 송신되는지 확인합니다. 이후 Cycle Time, DLC, DATA를 DBC와 비교하고, ACK Error나 CRC Error 같은 통신 오류가 있는지 확인하여 ECU 문제인지 CAN Bus 문제인지 구분하겠습니다.

---
퀴즈
ID : 없음

ACK Error : 계속 발생

CRC Error : 없음

가능한 원인

수신 ECU 전원 OFF
수신 ECU 고장
CAN 배선 단선
커넥터 접촉 불량

ACK Error만 계속 발생하고 CRC Error가 없다면 수신 ECU가 응답하지 않는 상황을 가장 먼저 의심한다.

## 오늘 배운 내용

- CAN Troubleshooting
- CANoe Trace 분석
- Cycle Time 확인
- Error 분석