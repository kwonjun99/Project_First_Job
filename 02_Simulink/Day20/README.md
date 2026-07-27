# Day20 - Saturation

## 목표

제어 출력의 최대 및 최소 값을 제한하는 Saturation Block의 역할을 이해하였다.

---

## 모델 구성

Constant

↓

Gain

↓

Saturation

↓

Display

---

## 학습 내용

- Saturation Block
- Upper Limit
- Lower Limit
- 출력 제한
- 안전 제어

---

## 자동차에서 사용하는 곳

Throttle Command

Brake Pressure

Motor Torque

Steering Angle

PWM Duty

모든 제어 출력은 허용 가능한 범위를 넘지 않도록 Saturation을 적용한다.

---

## 실제 차량 예시

Throttle 계산 결과가 250%가 되어도 차량은 100% 이상의 스로틀을 사용할 수 없다.

따라서 Saturation을 통해 최대 출력으로 제한한다.

---

## 느낀 점

자동차 제어에서는 계산 결과보다 차량이 실제 수행 가능한 범위를 고려하는 것이 매우 중요하며, Saturation은 이를 보장하는 핵심 블록이라는 것을 이해하였다.