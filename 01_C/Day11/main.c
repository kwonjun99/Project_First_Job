#include <stdio.h>

/* 실습 1
void hello(void)
{
    printf("Hello C!\n");
}

int main(void)
{
    hello();

    return 0;
}

실습2
void printSpeed()
{
    printf("Speed = 80 km/h\n");
}

int main(void)
{
    printSpeed();
    printSpeed();
    printSpeed();

    return 0;
}
-> 매개변수 작성 실습 3 Int speed
*/
#include <stdio.h>

void printSpeed(int speed)
{
    printf("Speed : %d km/h\n", speed);
}

int main(void)
{
    printSpeed(30);
    printSpeed(60);
    printSpeed(100);

    return 0;
}
/*
실습4
#include <stdio.h>

int add(int a, int b)
{
    return a + b;
}

int main(void)
{
    int result;

    result = add(10,20);

    printf("%d\n", result);

    return 0;
}
*/
