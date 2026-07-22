# Day12 - Header File & Multi File

## 학습 목표

- Header File(.h)
- Source File(.c)
- 여러 개의 파일을 사용하는 프로젝트 구조 이해
- Compile과 Link 과정 이해

---

## Header File

Header File은 함수의 선언을 저장한다.

예시

```c
int add(int a,int b);
```

---

## Source File

실제 함수를 구현한다.

```c
int add(int a,int b)
{
    return a+b;
}
```

---

## main.c

다른 파일의 함수를 호출하여 사용한다.

```c
#include "math.h"

printf("%d",add(10,20));
```

---

## 컴파일

하나의 파일

```bash
clang main.c -o main
```

여러 개의 파일

```bash
clang main.c math.c -o main
```

실행

```bash
./main
```

---

## 오늘 배운 내용

- Header File
- Source File
- Multi File
- Compile
- Link

---

## 문제 해결

Undefined symbols 오류를 경험하였다.

원인

- 여러 개의 파일을 함께 컴파일하지 않음
- 링커가 함수를 찾지 못함

해결

```bash
clang -c main.c
clang -c math.c
clang main.o math.o -o main
```

또는

```bash
clang main.c math.c -o main
```

으로 해결하였다.

---

## 느낀 점

실제 프로젝트에서는 하나의 main.c가 아니라 여러 개의 .c와 .h 파일을 사용한다는 것을 이해하였다.

헤더파일
파일을 나누는 이유 예를 들어 자동차 프로젝트에서는
Engine.c

Brake.c

Steering.c

CAN.c

Sensor.c

Motor.c

main.c
처럼 기능별로 나눠서 작성하기 때문에

