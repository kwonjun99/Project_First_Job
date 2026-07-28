# Day25 - P Controller와 정상상태 오차(Steady-State Error)

## 학습 목표

- P Controller의 원리 이해
- Closed Loop Control 구성
- 정상상태 오차(Steady-State Error) 확인
- 왜 PI 제어가 필요한지 이해

---

# 모델 구성

Constant(100)

↓

Sum(+,-)

↓

PID Controller
P = 1
I = 0
D = 0

↓

Saturation
Upper = 100
Lower = 0

↓

Transfer Function

1 / (s+1)

↓

Scope

↓

Feedback → Sum(-)

---

# 실습 결과

목표속도

100 km/h

실제 출력

약 50 km/h

---

# 왜 50이 나오는가?

P Controller는

출력이 증가할수록

오차(Error)가 감소한다.

오차가 감소하면

P Controller 출력도 감소한다.

따라서

제어입력과 출력이 평형을 이루는 지점에서

더 이상 출력이 증가하지 않는다.

이를

Steady State Error

(정상상태 오차)

라고 한다.

---

# 핵심 개념

Error

= Target − Output

Controller

u = P × Error

Error가 0이 되기 전에

Controller 출력도 감소하므로

목표값에 완전히 도달하지 못한다.

---

# 자동차 제어와 연결

Cruise Control

속도 제어

ACC

Throttle Control

Motor Speed Control

에서는

P Controller만 사용하지 않는다.

대부분 PI 또는 PID를 사용한다.

---

# 오늘 배운 내용

✔ Closed Loop Control

✔ Error 계산

✔ P Controller

✔ 정상상태 오차

✔ 왜 PI가 필요한지
