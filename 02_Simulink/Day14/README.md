# Day14 - Entry, During, Exit Action

## 학습 목표

* Entry Action 이해
* During Action 이해
* Exit Action 이해
* 상태 내부 동작 작성

---

## 프로젝트 개요

State는 단순히 이름만 있는 것이 아니라 상태에 들어갈 때(entry), 유지 중(during), 나갈 때(exit) 각각 다른 동작을 수행할 수 있다. 이를 이용해 실제 자동차 ECU의 제어 로직을 표현할 수 있다.

---

## 실습 내용

* RUNNING 상태 생성
* entry / during / exit 작성
* 상태 내부 동작 확인

---

## 실제 자동차 제어에서 활용

* 엔진 시동 시 RPM 초기화
* 주행 중 속도 및 RPM 업데이트
* 시동 종료 시 센서 값 초기화
* LKA 활성화 및 해제 시 제어 변수 초기화

---

## 오늘 배운 내용

* entry Action
* during Action
* exit Action
* State 내부 로직

---

## 느낀 점

Stateflow는 단순한 블록 연결이 아니라 자동차의 실제 동작 순서를 설계하는 도구임을 이해하였다. 앞으로 LKA, ACC, 기어 제어와 같은 프로젝트를 구현할 때 핵심적으로 사용될 수 있음을 확인하였다.
