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
    float temperature;
    enum Gear gear;
};

void updateVehicle(struct Vehicle *car,
                   int speed,
                   int rpm,
                   float temp,
                   enum Gear gear)
{
    car->speed = speed;
    car->rpm = rpm;
    car->temperature = temp;
    car->gear = gear;
}

void printVehicle(struct Vehicle car)
{
    printf("===== Vehicle Control System =====\n");

    printf("Speed : %d km/h\n", car.speed);
    printf("RPM : %d\n", car.rpm);
    printf("Temperature : %.1f C\n", car.temperature);

    printf("Gear : ");

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
    struct Vehicle myCar;

    updateVehicle(&myCar,90,2500,88.8,N);

    printVehicle(myCar);

    return 0;
}