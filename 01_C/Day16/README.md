makefile 기초
# Day16 - Makefile

## 학습 목표

- Makefile 이해
- make 명령어 사용
- make clean 이해

---

# Makefile

여러 개의 소스 파일을 자동으로 컴파일하기 위한 설정 파일이다.

---

# 컴파일

```bash
make
```

프로젝트 전체를 빌드한다.

---

# 실행

```bash
./main
```

생성된 실행 파일을 실행한다.

---

# 삭제

```bash
make clean
```

생성된 실행 파일을 삭제한다.

---

# Makefile 사용 이유

프로젝트 규모가 커질수록 컴파일 명령어가 길어진다.

Makefile을 사용하면 하나의 명령으로 전체 프로젝트를 빌드할 수 있다.

---

# 오늘 배운 내용

- Makefile
- make
- make clean

---

# 느낀 점

실무에서는 Makefile이나 CMake를 사용하여 프로젝트를 관리한다.

자동 빌드 환경을 만드는 첫 단계라는 것을 이해하였다.