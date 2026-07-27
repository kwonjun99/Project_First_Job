# Day09 - 목표 속도와 현재 속도의 오차(Error) 계산

## 학습 목표

* 목표값(Target)과 현재값(Current)의 차이 계산
* Sum 블록을 이용한 Error 생성
* 자동차 제어에서 Error의 의미 이해

---

## 프로젝트 개요

자동차 ECU는 목표 속도와 현재 속도를 계속 비교하여 오차(Error)를 계산한다. 이번 실습에서는 Sum 블록을 이용해 목표 속도와 현재 속도의 차이를 계산하는 모델을 구현하였다.

---

## 사용한 블록

* Constant
* Sum
* Display

---

## 모델 구성

Target Speed → Sum(+,-)

Current Speed → Sum(+,-)

↓

Display

---

## 실제 자동차 제어에서 활용

ACC(Adaptive Cruise Control), Cruise Control, LKA, ESC 등 대부분의 자동차 제어기는 목표값과 현재값의 오차를 계산한 후 제어 명령을 생성한다.

---

## 학습 내용

* Target Value
* Current Value
* Error Calculation
* Sum Block

---

## 느낀 점

자동차 제어는 단순히 속도를 측정하는 것이 아니라 목표값과 비교하여 오차를 계산하는 과정이 핵심이라는 점을 이해하였다.
