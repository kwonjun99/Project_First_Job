# Day11 - Function

## 학습 목표
- 함수(Function)의 개념 이해
- 함수 선언 및 호출
- 매개변수(Parameter)
- 반환값(Return)

## 학습 내용

### 1. 함수(Function)
- 반복되는 코드를 하나의 기능으로 묶어 사용하는 문법
- 코드의 재사용성을 높이고 유지보수를 쉽게 한다.

예시
```c
void hello()
{
    printf("Hello C!\n");
}
```

---

### 2. 함수 호출(Function Call)

```c
hello();
```

함수를 실행시키는 코드이다.

---

### 3. 매개변수(Parameter)

```c
void printSpeed(int speed)
```

speed 값을 함수로 전달한다.

예시

```c
printSpeed(30);
printSpeed(60);
```

---

### 4. Return

```c
int add(int a,int b)
{
    return a+b;
}
```

return은 계산한 값을 다시 돌려준다.

---

## 오늘 배운 내용

- Function
- Function Call
- Parameter
- Return

---

## 느낀 점

함수를 사용하면 같은 코드를 반복해서 작성하지 않아도 되며,
자동차 제어 프로그램에서도 기능별로 함수를 만들어 관리한다.

"함수" 
함수 쓰는 이유
예를 들어 자동차 ECU가 있다고 하자.
브레이크/엔진/조향/ABS 각각 기능이 있다.
전부 main 안에 쓰면 코드 과부화

기능별로 나눠서 쓰기 위해 작성
void engineControl()
{

}

void brakeControl()
{

}

void steeringControl()
{

}

int main()
{
    engineControl();
    brakeControl();
    steeringControl();
}
