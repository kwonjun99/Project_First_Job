#include <stdio.h>
#include "car.h"

void printCar(struct Car car)
{
    printf("Speed : %d km/h\n", car.speed);
    printf("RPM : %d\n", car.rpm);
}