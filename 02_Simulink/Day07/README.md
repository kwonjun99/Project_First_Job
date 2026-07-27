# Day07 - Subsystem을 이용한 ECU 모듈화

## 학습 목표

* Subsystem의 개념 이해
* 여러 블록을 하나의 기능 단위로 구성
* Simulink 모델의 가독성과 유지보수 향상

---

## 프로젝트 개요

실제 자동차 제어 시스템은 하나의 거대한 모델이 아니라 엔진, 제동, 조향 등 기능별로 나누어 개발한다. 이번 실습에서는 Ramp와 Gain 블록을 하나의 Subsystem으로 구성하여 ECU 모듈화 방식을 학습하였다.

---

## 사용한 블록

* Ramp
* Gain
* Subsystem
* Scope

---

## 모델 구성

Vehicle Speed Controller (Subsystem)

↓

Scope

---

## 실제 자동차 제어에서 활용

현대자동차와 현대모비스에서는 엔진 제어, 변속 제어, 제동 제어 등을 각각 독립적인 Subsystem으로 설계한다. 이를 통해 여러 개발자가 동시에 작업할 수 있고 유지보수가 쉬워진다.

---

## 학습 내용

* Create Subsystem
* Subsystem 이름 변경
* 기능별 모델 분리
* 모듈화 설계

---

## 느낀 점

Subsystem을 사용하면 복잡한 모델을 기능별로 정리할 수 있으며, 실제 자동차 ECU 개발 방식과 동일한 구조를 경험할 수 있었다.
