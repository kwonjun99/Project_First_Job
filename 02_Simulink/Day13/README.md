# Day13 - Stateflow 기초와 상태(State) 개념

## 학습 목표

* Stateflow 인터페이스 이해
* State(상태) 생성
* Transition(상태 전환) 생성
* Default Transition 이해

---

## 프로젝트 개요

자동차 ECU는 단순히 계산만 수행하는 것이 아니라 차량의 현재 상태를 관리한다. 이번 실습에서는 Stateflow를 이용하여 OFF와 ON 상태를 만들고, 상태 간 전환(Transition)을 구현하였다.

---

## 실습 내용

* Stateflow Chart 생성
* OFF / ON 상태 생성
* Transition 연결
* Default Transition 설정

---

## 실제 자동차 제어에서 활용

* 시동 ON/OFF
* 기어(P/R/N/D) 전환
* 와이퍼 OFF/LOW/HIGH
* 방향지시등 제어
* LKA 및 ACC 활성화/비활성화

자동차 ECU는 이러한 상태를 State Machine으로 관리한다.

---

## 오늘 배운 내용

* State
* Transition
* Default Transition
* State Machine

---

## 느낀 점

Stateflow를 통해 자동차 시스템이 현재 상태를 기준으로 동작을 전환하는 방식을 이해하였다. 이는 ECU 소프트웨어 설계의 핵심 개념이라는 것을 배웠다.
