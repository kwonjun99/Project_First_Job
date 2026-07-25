# Day30 - Vehicle Safety Check

## 학습 목표

* 차량 상태를 분석하여 위험 여부를 판단한다.
* 조건문을 이용한 차량 안전 진단 로직을 작성한다.
* 차량 진단 프로그램의 기본 구조를 이해한다.

---

# 프로젝트 개요

차량은 주행 중 지속적으로 상태를 점검한다.

이번 프로젝트에서는

* 차량 속도
* 엔진 RPM
* 엔진 온도

를 분석하여 차량 이상 여부를 판단하는 간단한 Vehicle Safety Check 프로그램을 구현하였다.

---

# 프로그램 구성

## Vehicle 구조체

```c
struct Vehicle
{
    int speed;
    int rpm;
    float temperature;
};
```

차량 상태를 저장한다.

---

## safetyCheck()

차량 상태를 분석하는 함수이다.

### ① Speed 검사

```c
if(car.speed>120)
```

120km/h를 초과하면

```text
Overspeed Warning
```

출력한다.

---

### ② RPM 검사

```c
if(car.rpm>5000)
```

5000RPM을 초과하면

```text
High RPM Warning
```

출력한다.

---

### ③ Temperature 검사

```c
if(car.temperature>100)
```

100℃를 초과하면

```text
Engine Overheat Warning
```

출력한다.

---

### ④ 정상 상태 검사

세 조건을 모두 만족하지 않으면

```text
Vehicle Safe
```

를 출력한다.

---

# 실행 결과

```text
Overspeed Warning
High RPM Warning
Engine Overheat Warning
```

---

# 코드 분석

```c
struct Vehicle myCar =
{
150,
6200,
110
};
```

↓

조건 검사

* Speed > 120 → 참
* RPM > 5000 → 참
* Temperature > 100 → 참

따라서 모든 경고가 출력된다.

---

# 오늘 배운 내용

* 차량 상태 판단
* 조건문 활용
* 경고 시스템 구현

---

# 실제 자동차 제어에서 어디에 사용될까?

실제 ECU는 차량 상태를 실시간으로 분석하여 이상 상태를 감지한다.

예를 들어

* 과속
* 엔진 과열
* 엔진 과회전
* 배터리 이상
* 냉각수 부족

등을 판단하여 계기판 경고등, 경고음 또는 출력 제한 기능을 수행한다.

이번 프로젝트는 이러한 차량 진단 로직의 가장 기초적인 형태를 구현한 것이다.

---

# 느낀 점

이제는 단순히 데이터를 출력하는 프로그램이 아니라 차량 상태를 판단하는 프로그램을 직접 작성할 수 있게 되었다.

자동차 제어 소프트웨어가 데이터를 어떻게 활용하는지 조금 더 이해할 수 있었다.
