# Day10 - Error 기반 제어 신호 생성

## 학습 목표

* Error 신호를 Gain으로 증폭
* 제어 입력(Control Signal) 생성
* 피드백 제어 구조 이해

---

## 프로젝트 개요

오차(Error)가 계산되면 ECU는 그 크기에 따라 가속 또는 감속 명령을 생성한다. 이번 실습에서는 Gain 블록을 이용하여 Error를 제어 신호로 변환하는 과정을 구현하였다.

---

## 사용한 블록

* Constant
* Sum
* Gain
* Display

---

## 모델 구성

Target Speed

↓

Sum(+,-)

↓

Gain

↓

Display

Current Speed

---

## 실제 자동차 제어에서 활용

Cruise Control은 목표 속도와 현재 속도의 오차를 계산한 후 스로틀 개도를 조절한다. 오차가 크면 더 크게 가속하고, 오차가 작아질수록 제어 입력도 줄어든다. 이는 PID 제어의 기본 개념이기도 하다.

---

## 학습 내용

* Error Signal
* Gain Controller
* Control Signal
* Feedback Control

---

## 느낀 점

Feedback 제어의 첫 단계를 이해하였으며, 앞으로 PID 제어기와 ACC 프로젝트를 구현하기 위한 핵심 개념을 익힐 수 있었다.
