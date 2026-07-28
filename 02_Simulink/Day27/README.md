# Day27 - Adaptive Cruise Control (ACC) 기본 구조

## 학습 목표

- Adaptive Cruise Control(ACC)의 기본 원리 이해
- Switch 블록을 이용한 조건 분기
- 목표 속도 변경 방식 이해
- 자동차 속도 제어 로직 구현

---

## 실습 내용

이번 실습에서는 ACC의 가장 기본적인 구조를 Simulink로 구현하였다.

운전자가 원하는 목표속도는 100km/h로 설정하였다.

하지만 앞차가 가까워질 경우 목표속도를 60km/h로 자동 변경하도록 구현하였다.

Switch 블록을 이용하여

앞차가 없으면

100km/h

앞차가 있으면

60km/h

를 선택하도록 구성하였다.

---

## 블록 구성

Constant (100)

↓

Switch

↑

Constant (60)

↑

Constant (앞차 유무)

↓

Sum

↓

PID Controller

↓

Transfer Function

↓

Scope

↓

Feedback

---

## 실습 결과

앞차 없음

→ 목표속도 100km/h

앞차 있음

→ 목표속도 60km/h

Switch 블록이 조건에 따라 목표속도를 변경하는 것을 확인하였다.

---

## 자동차에서의 활용

실제 ACC에서는 Constant 대신

- Radar
- Camera
- LiDAR

센서를 사용하여 앞차와의 거리를 측정한다.

측정된 거리에 따라 목표속도를 변경하여 차량이 안전거리를 유지하도록 제어한다.

---

## 오늘 배운 내용

✔ Switch 블록

✔ 조건 분기

✔ 목표속도 변경

✔ ACC 기본 원리

✔ 센서 기반 제어 흐름