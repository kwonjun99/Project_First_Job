# Day18 - 자동차 상태 전환(State Transition)

## 목표

Stateflow를 이용하여

자동차가

주행 상태와 정지 상태를

자동으로 전환하는 로직을 구현한다.

---

# 실습 내용

## 모델 구성

State

```
Idle
Driving
```

Transition

```
Idle -> Driving

조건

speed > 0
```

```
Driving -> Idle

조건

speed == 0
```

---

## State Transition

Stateflow에서는

조건이 참(True)이 되면

다른 상태로 이동한다.

예)

```
speed = 0

Idle
```

↓

```
speed = 30

Driving
```

↓

```
speed = 0

Idle
```

자동차 ECU도 동일한 원리로 동작한다.

---

## Entry Action

Driving

```
entry:
disp("Driving")
```

Idle

```
entry:
disp("Idle")
```

State가 변경될 때마다

MATLAB Command Window에서

현재 상태를 확인하였다.

---

## Symbol Wizard

Transition에

```
speed
```

를 입력하면

Stateflow는

speed가 어떤 변수인지 알지 못한다.

이때

Symbol Wizard가 나타난다.

이번 실습에서는

```
speed

Class
↓

Data

Scope
↓

Input
```

으로 설정하였다.

이후

Stateflow 입력으로 사용할 수 있었다.

---

# 발생했던 오류

실습 중

다음 오류를 경험하였다.

```
Chart에 연결이 맞지 않는 기호가 있습니다.
```

원인

Stateflow 내부에서는

speed를 Input Data로 선언했지만

Simulink에서는

Stateflow 입력 포트를 연결하지 않았기 때문이다.

즉

Stateflow와 Simulink 사이의 연결이 없는 상태였다.

이 오류를 통해

Stateflow 내부 변수와

Simulink 신호는 반드시 연결되어야 함을 이해하였다.

---

# 자동차에서 실제 사용

차량 ECU는

단순 계산보다

현재 차량 상태를 먼저 판단한다.

예)

```
Engine OFF

↓

Engine ON

↓

Idle

↓

Driving

↓

Cruise

↓

Emergency

↓

Engine OFF
```

이러한 상태 변화는

거의 모두 Stateflow 기반 상태 머신으로 구현된다.

---

# 오늘 배운 내용

- State Transition
- Input Data
- Symbol Wizard
- Entry Action
- Stateflow와 Simulink 연결

---

# 느낀 점

오늘 실습을 통해

Stateflow는 단순 그림이 아니라

자동차 ECU의 상태를 직접 설계하는 도구라는 것을 이해하였다.

향후 LKA, ACC, AEB 프로젝트에서도

상태 전환 로직은 반드시 사용될 것이라고 생각한다.