#include <stdio.h>

enum Gear
{
    P,
    R,
    N,
    D
};

struct CarStatus
{
    int speed;
    int rpm;
    float temperature;
    enum Gear gear;
};

void printStatus(struct CarStatus car)
{
    printf("===== Car Status =====\n");
    printf("Speed       : %d km/h\n", car.speed);
    printf("RPM         : %d\n", car.rpm);
    printf("Temperature : %.1f C\n", car.temperature);

    printf("Gear        : ");

    switch(car.gear)
    {
        case P: printf("P\n"); break;
        case R: printf("R\n"); break;
        case N: printf("N\n"); break;
        case D: printf("D\n"); break;
    }
}

int main(void)
{
    struct CarStatus myCar;

    myCar.speed = 110;
    myCar.rpm = 3000;
    myCar.temperature = 95.5;
    myCar.gear = R;

    printStatus(myCar);

    return 0;
}