#include <stdio.h>

typedef int SPEED;

int main(void)
{
    SPEED speed = 100;

    printf("%d\n", speed);

    return 0;
}

/* enum 활용 자동차에서는 숫자보다 의미있는 이름을 많이 활용
#include <stdio.h>

enum Gear
{
    P,
    R,
    N,
    D
};

int main(void)
{
    enum Gear gear = D;

    printf("%d\n", gear);

    return 0;
}
*/

/*
#include <stdio.h>

enum EngineState
{
    OFF,
    ON
};

int main(void)
{
    enum EngineState engine = ON;

    if(engine == ON)
    {
        printf("Engine Start\n");
    }

    return 0;
}
*/