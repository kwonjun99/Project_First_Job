#include <stdio.h>

enum Gear
{
    P,
    R,
    N,
    D
};

struct Car
{
    int speed;
    enum Gear gear;
};

void printStatus(struct Car car)
{
    printf("Speed : %d km/h\n", car.speed);

    switch(car.gear)
    {
        case P:
            printf("Gear : P\n");
            break;

        case R:
            printf("Gear : R\n");
            break;

        case N:
            printf("Gear : N\n");
            break;

        case D:
            printf("Gear : D\n");
            break;
    }
}

int main(void)
{
    struct Car myCar;

    myCar.speed = 120;
    myCar.gear = P;

    printStatus(myCar);

    return 0;
}