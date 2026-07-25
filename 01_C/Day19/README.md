<Gear Control Project>

enum 활용
구조체 활용
조건문 활용
자동차 기어 상태 관리

자동차처럼
P, R, N, D를 관리하는 프로그램을 만들자.

**
switch문의 장점

지금까지는

if (gear == P)처럼 작성했지만,

상태가 여러 개일 때는

switch가 훨씬 보기 쉽고 관리하기 편하다.

자동차 ECU에서도 상태(State)를 처리할 때 자주 사용하는 방식이다.

# Day19 - Gear Control Project

## 학습 목표

- enum을 이용한 기어 상태 관리
- switch문 사용
- 구조체와 enum 함께 사용

---

## Gear 상태

```c
enum Gear
{
    P,
    R,
    N,
    D
};
```

각 기어 상태를 enum으로 표현하여 코드의 가독성을 높였다.

---

## switch문

기어 상태에 따라 다른 출력을 수행하였다.

switch문은 여러 상태를 처리할 때 if-else보다 읽기 쉽고 유지보수가 편리하다.

---

## 오늘 배운 내용

- enum
- switch
- 구조체와 enum 조합

---

## 느낀 점

자동차의 기어 상태처럼 여러 가지 상태를 관리할 때 enum과 switch문이 매우 유용하다는 것을 이해하였다.