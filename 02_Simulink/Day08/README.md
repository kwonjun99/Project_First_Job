# Day08 - 다중 ECU 구조와 신호 통합

## 학습 목표

* 여러 개의 Subsystem 생성
* Mux를 이용한 다중 신호 통합
* Scope에서 여러 ECU 출력 비교

---

## 프로젝트 개요

차량은 속도 제어, 엔진 제어, 온도 모니터링 등 다양한 기능이 동시에 동작한다. 이번 실습에서는 Speed Controller와 RPM Controller를 각각 Subsystem으로 구현하고, Mux를 통해 하나의 Scope에서 동시에 확인하였다.

---

## 사용한 블록

* Subsystem
* Ramp
* Gain
* Constant
* Mux
* Scope

---

## 모델 구성

Speed Controller

↓

Mux

↓

Scope

RPM Controller

↓

Temperature(Constant)

---

## 실제 자동차 제어에서 활용

차량 ECU는 여러 기능 블록의 출력을 통합하여 차량 상태를 분석하고 제어한다. 속도와 RPM, 엔진 온도는 차량 상태를 판단하는 대표적인 데이터이며, 실제 개발 환경에서도 동시에 모니터링된다.

---

## 학습 내용

* 다중 Subsystem 구성
* 신호 통합
* Mux 활용
* Scope를 이용한 비교 분석

---

## 느낀 점

자동차 제어는 하나의 기능이 아니라 여러 ECU가 협력하여 동작한다는 점을 이해하였으며, Subsystem을 통해 실제 프로젝트와 유사한 구조를 설계할 수 있었다.
