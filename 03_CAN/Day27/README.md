# Day27 - CANoe Test Scenario

## 학습 목표

- CANoe 테스트 절차 이해
- PASS / FAIL 판정 방법 학습
- 품질 테스트 흐름 이해

---

## 테스트 순서

1. CANoe 실행
2. DBC 적용
3. Signal 송신
4. Physical Value 확인
5. Cluster 표시 확인
6. PASS / FAIL 판정

---

## 확인 항목

- CAN ID
- Cycle Time
- DATA
- Physical Value
- Cluster 표시

---

## PASS 조건

송신한 값과 Cluster 표시 값이 동일하면 PASS이다.

---

## FAIL 조건

송신한 값과 Cluster 표시 값이 다르면 FAIL이다.

---

## 실무 활용

품질 엔지니어는 CANoe를 이용하여 ECU와 Cluster 간 데이터가 정확하게 표시되는지 검증하고 테스트 리포트를 작성한다.

---

## 오늘 배운 내용

- CANoe Test
- PASS / FAIL
- Cluster 검증
- 테스트 리포트 작성