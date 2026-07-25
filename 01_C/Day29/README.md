# Day29 - Mini Vehicle Control System

## 학습 목표

* 차량의 여러 상태 정보를 하나의 구조체로 통합 관리한다.
* 하나의 함수에서 차량의 모든 상태를 동시에 업데이트하는 방법을 학습한다.
* 지금까지 학습한 구조체, enum, 포인터, 함수를 하나의 프로그램으로 통합한다.

---

# 프로젝트 개요

이번 프로젝트는 Day01부터 Day28까지 학습한 내용을 하나로 합친 첫 번째 Mini Project이다.

차량의

* Speed
* Engine RPM
* Engine Temperature
* Gear

를 하나의 Vehicle 구조체에서 관리하고 하나의 함수에서 차량 상태를 변경하도록 구현하였다.

---

# 프로그램 구성

## Vehicle 구조체

```c
struct Vehicle
{
    int speed;
    int rpm;
    float temperature;
    enum Gear gear;
};
```

차량의 핵심 정보를 하나의 구조체에 저장하였다.

---

## updateVehicle()

```c
updateVehicle(...)
```

차량 상태를 한번에 업데이트하는 함수이다.

### 함수 역할

* Speed 변경
* RPM 변경
* Temperature 변경
* Gear 변경

실제 ECU에서도 여러 센서 값을 읽은 뒤 차량 상태 구조체를 동시에 갱신하는 방식이 사용된다.

---

## printVehicle()

현재 차량 상태를 출력한다.

enum Gear를 switch문으로 문자열(P, R, N, D) 형태로 출력하였다.

---

# 실행 결과

```text
===== Vehicle Control System =====

Speed : 90 km/h
RPM : 2500
Temperature : 88.8 C
Gear : N
```

---

# 코드 분석

```c
updateVehicle(&myCar,90,2500,88.8,N);
```

### 분석

* myCar의 주소 전달
* Speed = 90
* RPM = 2500
* Temperature = 88.8
* Gear = N

↓

updateVehicle 함수에서 원본 구조체를 직접 수정한다.

---

# 오늘 배운 내용

* 구조체 통합 관리
* 포인터를 통한 데이터 수정
* enum
* switch
* 함수 분리

---

# 실제 자동차 제어에서 어디에 사용될까?

실제 차량에서는 ECU가 CAN 통신을 통해 수신한 차량 상태를 하나의 Vehicle State 구조체에 저장한다.

이후 엔진 제어, 변속 제어, ADAS, ACC 등의 여러 제어기가 동일한 데이터를 참조하여 차량을 제어한다.

이번 프로젝트는 이러한 ECU 내부 데이터 관리 구조를 단순화하여 구현한 것이다.

---

# 느낀 점

지금까지 배운 문법들을 하나의 프로그램으로 연결하면서 실제 프로그램이 어떻게 구성되는지 이해할 수 있었다.

이번 프로젝트는 자동차 제어 프로그램의 가장 기본적인 형태라고 생각한다.
