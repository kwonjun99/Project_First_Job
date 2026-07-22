typedef는 기존 자료형에 새로운 이름을 붙여 코드의 의미를 더 명확하게 해 준다.

# Day13 - typedef & enum

## 학습 목표

- typedef의 개념 이해
- enum의 개념 이해
- 자동차 소프트웨어에서 사용하는 상태(State) 표현 방법 이해

---

# typedef

typedef는 기존 자료형에 새로운 이름을 붙이는 기능이다.

예시

```c
typedef int RPM;
```

기존

```c
int rpm;
```

typedef 사용

```c
RPM rpm;
```

가독성이 좋아지고 변수의 의미를 쉽게 알 수 있다.

자동차 프로젝트에서는

- RPM
- SPEED
- TEMP

같이 의미를 표현하기 위해 많이 사용한다.

---

# enum

enum은 여러 개의 상태를 숫자로 관리하는 자료형이다.

예시

```c
enum Gear
{
    P,
    R,
    N,
    D
};
```

실제 값은

```
P = 0
R = 1
N = 2
D = 3
```

이다.

---

# enum 사용 이유

자동차 제어 프로그램에서는

엔진 상태

```
OFF
ON
```

기어 상태

```
P
R
N
D
```

ABS 상태

```
READY
ACTIVE
ERROR
```

등을 enum으로 표현한다.

숫자보다 의미가 명확하여 유지보수가 쉬워진다.

---

# 오늘 배운 내용

- typedef
- enum
- 상태(State)
- 자동차 제어 프로그램에서 enum 활용

---

# 실습

### typedef

```c
typedef int RPM;

RPM rpm = 3500;
```

### enum

```c
enum Light
{
    RED,
    YELLOW,
    GREEN
};
```

---

# 느낀 점

typedef는 자료형의 의미를 명확하게 표현하는 방법이라는 것을 배웠다.

enum은 자동차 ECU에서 상태를 표현할 때 매우 자주 사용하는 문법이라는 것을 이해하였다.