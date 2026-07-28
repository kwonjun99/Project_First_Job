# Day26 - PI Controller로 정상상태 오차 제거

## 학습 목표

- Integral(I) 제어 이해
- PI Controller 구성
- 정상상태 오차 제거
- 자동차 Cruise Control 원리 이해

---

# 모델

Constant

↓

Sum

↓

PID

P = 1

I = 1

D = 0

↓

Saturation

↓

Transfer Function

↓

Scope

↓

Feedback

---

# 실습 결과

목표속도

100 km/h

출력

약 100 km/h

---

# 왜 100까지 올라가는가?

Integral Controller는

Error를 계속 누적한다.

Error가 조금이라도 남아있으면

계속 제어입력을 증가시킨다.

그래서

결국 Error = 0

이 된다.

---

# P Controller와 비교

P Controller

↓

빠르다

↓

하지만 오차가 남는다.

PI Controller

↓

조금 느리다.

↓

하지만 목표값까지 정확히 도달한다.

---

# 자동차에서 사용되는 곳

Cruise Control

ACC

Motor Speed

Electric Steering

Brake Pressure Control

---

# 오늘 이해해야 하는 핵심

P

→ 현재 오차만 본다.

I

→ 과거 오차를 계속 기억한다.

그래서

남은 오차를 끝까지 없앤다.

---

# 최종 정리

P

빠르다.

오차가 남는다.

PI

느리지만

오차가 없다.

실제 자동차에서는

PI 또는 PID를 사용한다.
