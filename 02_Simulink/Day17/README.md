# Day17 - Stateflow 기초

## 목표

Simulink의 Stateflow를 이용하여
자동차 ECU가 상태(State)를 관리하는 방식을 이해한다.

이번 실습에서는

- State 생성
- Transition 생성
- Entry Action
- 상태 전환 조건

을 학습하였다.

---

# 실습 내용

## 1. State 생성

두 개의 상태를 생성하였다.

```
Idle
Driving
```

Idle은 차량이 정지한 상태이며,

Driving은 차량이 주행하는 상태를 의미한다.

자동차 ECU는 현재 차량이 어떤 상태인지 항상 기억하고 있다.

---

## 2. Entry Action

각 상태에 진입하면

자동으로 실행되는 코드를 작성하였다.

Idle

```
entry:
disp("Idle")
```

Driving

```
entry:
disp("Driving")
```

State가 변경될 때마다

현재 상태를 확인할 수 있었다.

---

## 3. Transition

상태 사이를 연결하였다.

```
Idle
   │
   │ speed > 0
   ▼
Driving

Driving
   │
   │ speed == 0
   ▼
Idle
```

Transition은

조건이 만족될 때만 실행된다.

---

## 4. 입력 변수

Stateflow에서는

조건을 만들기 위해

입력 변수(Input Data)가 필요하다.

이번 실습에서는

```
speed
```

변수를 Input Data로 생성하였다.

Transition에서는

```
[speed > 0]
```

형태로 사용하였다.

---

# 자동차에서 실제 사용

자동차 ECU는

현재 차량 상태를 계속 관리한다.

예)

- Engine OFF
- Engine ON
- Idle
- Driving
- Reverse
- Parking
- Cruise
- Emergency

모든 기능은

Stateflow와 같은 상태 머신(State Machine) 구조로 설계된다.

---

# 오늘 배운 내용

- State
- Transition
- Entry Action
- Input Data
- State Machine

---

# 느낀 점

기존 Simulink는 신호를 계산하는 모델이었다면,

Stateflow는

'현재 자동차가 어떤 상태인지'

판단하는 프로그램이라는 점이 가장 큰 차이였다.

ECU 내부에서도 이러한 상태 관리가 매우 중요하다는 것을 이해하였다.