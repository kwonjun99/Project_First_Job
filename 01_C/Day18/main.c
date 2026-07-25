#include "car.h"

int main(void)
{
    struct Car myCar;

    myCar.speed = 100;
    myCar.rpm = 2500;

    printCar(myCar);

    return 0;
}