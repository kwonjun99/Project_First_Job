# Day18 - Multi File Project

## 학습 목표

- 프로젝트를 여러 파일로 분리
- Header File과 Source File의 역할 이해
- Makefile 수정 및 활용
코드를 여러 파일로 나누는 이유.
---

## 프로젝트 구조

Day18/

- main.c
- car.c
- car.h
- Makefile
- README.md

---

## Header File

구조체와 함수 선언을 작성한다.

## Source File

함수를 구현한다.

## main.c

프로그램의 시작점이며 필요한 함수를 호출한다.

---

## Makefile

```bash
make
./main
make clean
```

를 통해 프로젝트를 쉽게 빌드하고 실행할 수 있다.

---

## 오늘 배운 내용

- Multi File
- Header File
- Source File
- Makefile

---

## 느낀 점

프로젝트를 여러 파일로 나누면 유지보수가 쉬워지고 실무에서 사용하는 프로젝트 구조를 이해할 수 있었다.

//
# 비유하면

### 📄 car.h

**메뉴판**

손님이 어떤 음식이 있는지 확인하는 곳이다.

* `struct Car`가 있다는 것을 알려준다.
* `printCar()`라는 함수가 있다는 것을 알려준다.
* **실제 동작하는 코드는 없다.**
* "이런 기능을 사용할 수 있다."라고 선언만 해주는 파일이다.

---

### 🍳 car.c

**주방**

손님이 주문한 음식을 실제로 만드는 곳이다.

예를 들어

```c
void printCar(struct Car car)
{
    printf("Speed : %d km/h\n", car.speed);
    printf("RPM : %d\n", car.rpm);
}
```

처럼 함수의 실제 내용(구현)이 들어간다.

---

### 👤 main.c

**손님**

프로그램이 시작되는 곳이다.

손님은 메뉴판(`car.h`)을 보고 어떤 기능이 있는지 확인한 뒤,

```c
printCar(myCar);
```

처럼 함수를 호출한다.

그러면 실제 요리는 `car.c`에서 만들어진다.

---

## 한 문장으로 정리

* **car.h** → 설명서(메뉴판)
* **car.c** → 실제 기능 구현(주방)
* **main.c** → 프로그램 시작 및 함수 호출(손님)

이 구조는 자동차 임베디드 프로젝트에서도 매우 많이 사용하는 기본 구조이다.
| 파일         | 역할                  |
| ---------- | ------------------- |
| **main.c** | 프로그램 시작, 함수 호출      |
| **car.h**  | 구조체와 함수를 "선언"하는 설명서 |
| **car.c**  | 함수를 "구현"하는 실제 코드    |
