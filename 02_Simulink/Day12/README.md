# Day12 - Relational Operator를 이용한 차량 상태 판단

## 학습 목표

* 비교 연산 수행
* 조건 판단 결과를 Switch와 연동
* 차량 경고 시스템의 기본 원리 이해

---

## 프로젝트 개요

차량은 속도, 엔진 RPM, 온도 등 다양한 값을 기준과 비교하여 정상 상태인지 위험 상태인지 판단한다. 이번 실습에서는 Relational Operator를 이용하여 속도가 제한 속도를 초과하는지 검사하고, 그 결과에 따라 다른 출력을 선택하는 모델을 구현하였다.

---

## 사용한 블록

* Constant
* Relational Operator
* Switch
* Display

---

## 모델 구성

Speed

↓

Relational Operator

↓

Switch

↓

Display

Limit Speed

---

## 실제 자동차 제어에서 활용

* 과속 경고
* 엔진 과열 감지
* RPM 제한
* 배터리 보호 로직

차량 ECU는 다양한 센서 값을 기준과 비교하여 제어 여부를 결정한다.

---

## 학습 내용

* 비교 연산(>, <, ==)
* Boolean 신호
* 조건 분기
* 차량 상태 판단

---

## 느낀 점

비교 연산과 조건 분기를 함께 사용하면 실제 자동차 ECU의 기본 판단 로직을 구현할 수 있다는 점을 이해하였다.
