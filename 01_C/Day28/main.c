#include <stdio.h>

struct Vehicle
{
    int speed;
    int rpm;
};

void checkWarning(struct Vehicle car)
{
    if(car.speed > 120)
    {
        printf("Warning : Overspeed!\n");
    }

    if(car.rpm > 5000)
    {
        printf("Warning : High RPM!\n");
    }

    if(car.speed <= 120 && car.rpm <= 5000)
    {
        printf("Vehicle Status Normal\n");
    }
}

int main(void)
{
    struct Vehicle myCar = {150,6000};

    checkWarning(myCar);

    return 0;
}