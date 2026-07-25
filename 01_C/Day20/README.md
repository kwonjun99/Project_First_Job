Sensor Project -> 자동차 센서 관리 프로젝트
# Day20 - Sensor Data Project

## 학습 목표

- 센서 데이터를 구조체로 관리
- 함수를 이용한 센서 정보 출력
- 구조체 배열의 활용 이해

---

## Sensor 구조체

```c
struct Sensor
{
    int rpm;
    float temperature;
};
```

RPM과 온도 데이터를 하나의 구조체로 관리하였다.

---

## 함수

```c
printSensor()
```

함수를 만들어 센서 데이터를 출력하였다.

---

## 오늘 배운 내용

- Sensor 구조체
- 함수
- 구조체 배열

---

## 느낀 점

자동차의 RPM과 온도처럼 서로 관련된 데이터를 구조체로 관리하면 코드가 깔끔해지고 확장하기 쉬워진다는 것을 이해하였다.