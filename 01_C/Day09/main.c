#include <stdio.h>

struct Vehicle
{
    int speed;
    int rpm;
    char gear;
};

struct Engine
{
    int rpm;
    int temperature;
};

int main(void)
{
    struct Vehicle car;

    car.speed = 80;
    car.rpm = 3000;
    car.gear = 'D';

    printf("%d\n",car.speed);
    printf("%d\n",car.rpm);
    printf("%c\n",car.gear);

    return 0;
}

