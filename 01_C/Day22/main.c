#include <stdio.h>

struct CarStatus
{
    int speed;
    int rpm;
};

void updateSpeed(struct CarStatus *car, int speed)
{
    car->speed = speed;
}

void updateRPM(struct CarStatus *car, int rpm)
{
    car->rpm = rpm;
}

void printStatus(struct CarStatus car)
{
    printf("Speed : %d km/h\n", car.speed);
    printf("RPM   : %d\n", car.rpm);
}

int main(void)
{
    struct CarStatus myCar = {60, 1800};

    updateSpeed(&myCar, 120);
    updateRPM(&myCar, 3500);

    printStatus(myCar);

    return 0;
}