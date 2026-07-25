#include <stdio.h>

struct Vehicle
{
    int speed;
    int rpm;
    float temperature;
};

void safetyCheck(struct Vehicle car)
{
    if(car.speed>120)
        printf("Overspeed Warning\n");

    if(car.rpm>5000)
        printf("High RPM Warning\n");

    if(car.temperature>100)
        printf("Engine Overheat Warning\n");

    if(car.speed<=120 &&
       car.rpm<=5000 &&
       car.temperature<=100)
    {
        printf("Vehicle Safe\n");
    }
}

int main(void)
{
    struct Vehicle myCar =
    {
        150,
        6200,
        110
    };

    safetyCheck(myCar);

    return 0;
}