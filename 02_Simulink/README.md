# 🚗 Simulink Vehicle Control Study (30 Days)

## 프로젝트 소개

본 프로젝트는 자동차 제어 엔지니어 취업을 목표로 진행한 **30일 Simulink 학습 프로젝트**입니다.

단순히 Simulink 블록을 사용하는 방법을 배우는 것이 아니라,

실제 자동차 제어 시스템에서 사용되는

- Cruise Control
- PID Control
- Adaptive Cruise Control (ACC)
- Lane Keeping Assist (LKA)
- Stateflow

등을 단계적으로 구현하며 자동차 제어 시스템의 동작 원리를 이해하는 것을 목표로 하였습니다.

---

# 개발 환경

MATLAB R2024b

Simulink R2024b

Control System Toolbox

Simulink Control Design

Stateflow

Signal Processing Toolbox

---

# 프로젝트 구조

```
02_Simulink

├── Day01
├── Day02
│
├── ...
│
├── Day29
├── Day30
│
└── README.md
```

---

# 학습 과정

## Day01 ~ Day04

### Simulink 기본 인터페이스

학습 내용

- Library Browser
- Block 추가
- Signal 연결
- Constant
- Sum
- Scope
- Display

실습

- 두 개의 입력 더하기
- 신호 확인
- Scope 사용법

---

## Day05 ~ Day08

### 신호 처리

학습 내용

- Gain
- Mux
- Demux
- Subsystem

실습

- 여러 신호 결합
- 기능별 Subsystem 제작
- 엔진/브레이크 분리

---

## Day09 ~ Day12

### Feedback Control

학습 내용

- Closed Loop
- Error 계산
- PID Controller
- Switch

실습

- 속도 제어
- 목표속도 유지
- 조건 분기

---

## Day13 ~ Day16

### Stateflow

학습 내용

- State
- Transition
- Entry Action

실습

- Engine ON/OFF
- Gear 상태
- 자동차 상태 관리

---

## Day17 ~ Day20

### 제어기 구성

학습 내용

- Gain
- Saturation
- PID Controller

실습

- 속도 제어기
- 출력 제한
- Controller 응답 분석

---

## Day21 ~ Day24

### PI Control

학습 내용

- Integral Control
- 정상상태 오차

실습

P Controller

↓

PI Controller

↓

응답 비교

---

## Day25 ~ Day26

### Cruise Control

학습 내용

- 차량 전달함수
- Closed Loop
- PI 제어

실습

100km/h 목표

↓

PI Controller

↓

차량 속도 유지

---

## Day27 ~ Day28

### Adaptive Cruise Control

학습 내용

- Switch
- Step
- 목표속도 변경

실습

앞차 없음

↓

100km/h

앞차 있음

↓

60km/h

자동 감속

---

## Day29 ~ Day30

### Lane Keeping Assist

학습 내용

- Lane Error
- Steering Gain
- Stateflow

실습

Turn Signal ON

↓

LKA OFF

Turn Signal OFF

↓

LKA ON

---

# 주요 기술

MATLAB

Simulink

PID Controller

PI Controller

Stateflow

Feedback Control

Transfer Function

Switch Logic

Subsystem

Signal Routing

---

# 자동차 제어 시스템과의 연관성

본 프로젝트에서 구현한 모델들은 실제 자동차 제어 시스템의 기본 구조를 단순화하여 구현한 것입니다.

예를 들어

### Cruise Control

운전자가 설정한 목표 속도를 유지하도록 차량 속도를 자동으로 제어

---

### Adaptive Cruise Control

전방 차량과의 거리를 고려하여 목표 속도를 자동 변경

---

### Lane Keeping Assist

차량이 차선을 벗어나지 않도록 Steering을 자동 제어

---

### Stateflow

자동차 ECU 내부의 상태(State)를 관리

예)

- Engine
- Gear
- Cruise Control
- LKA
- Brake Mode

---

# 프로젝트를 진행하며 배운 점

Simulink는 단순히 블록을 연결하는 프로그램이 아니라,

자동차 제어 시스템을 설계하고 검증하는 개발 도구라는 것을 이해하였다.

또한

PID 제어기,

Stateflow,

Feedback Control,

Transfer Function의 개념을 직접 구현하면서

자동차 제어 시스템의 전체 구조를 이해할 수 있었다.

---

# 다음 프로젝트

다음 프로젝트에서는

## CAN Communication

을 학습한다.

학습 예정

- CAN Frame
- Arbitration ID
- DLC
- Signal
- ECU 통신
- 차량 데이터 송수신
- MATLAB CAN Toolbox

최종적으로는

C언어

+

Simulink

+

CAN

을 하나의 자동차 제어 프로젝트로 통합할 예정이다.

---

# Author

권준

Kookmin University

Automotive IT Convergence Engineering

Vehicle Control Engineering Portfolio