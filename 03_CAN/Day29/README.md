# Day29 - CAN 로그 분석 미니 프로젝트

## 학습 목표

- 실제 CAN 로그 분석
- 원인 추론
- 품질 보고서 작성

---

## 문제 상황

Cluster 속도계가 0 km/h를 표시한다.

---

## CAN 로그 분석

ECU는 Vehicle Speed를 100 km/h로 정상 송신한다.

따라서 ECU와 CAN 통신은 정상이다.

---

## 가능한 원인

- Cluster 오류
- DBC 불일치
- CAN ID 설정 오류
- Cluster Software 문제

---

## 점검 순서

1. CAN ID 확인
2. DBC 확인
3. Cluster 설정 확인
4. Software 확인

---

## 실무 보고서

증상

원인

조치

---
현상

ACK Error 없음

CRC Error 없음

Speed = 정상

Cluster = 0 km/h

->
원인

Cluster 오류

조치

Cluster CAN ID 설정, DBC, Software 확인

## 오늘 배운 내용

- CAN 로그 분석
- 품질 문제 분석
- 원인 추론
- 실무 보고서 작성