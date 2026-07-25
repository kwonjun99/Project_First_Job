#include <stdio.h>

enum Gear
{
    P,
    R,
    N,
    D
};

struct Vehicle
{
    int speed;
    int rpm;
    enum Gear gear;
};

void updateSpeed(struct Vehicle *car, int speed)
{
    car->speed = speed;
}

void updateRPM(struct Vehicle *car, int rpm)
{
    car->rpm = rpm;
}

void updateGear(struct Vehicle *car, enum Gear gear)
{
    car->gear = gear;
}

void printVehicle(struct Vehicle car)
{
    printf("===== Vehicle Status =====\n");
    printf("Speed : %d km/h\n", car.speed);
    printf("RPM   : %d\n", car.rpm);

    printf("Gear  : ");

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
    struct Vehicle myCar = {0,0,P};

    updateSpeed(&myCar,80);
    updateRPM(&myCar,2200);
    updateGear(&myCar,N);

    printVehicle(myCar);

    return 0;
}