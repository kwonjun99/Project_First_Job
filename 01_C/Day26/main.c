#include <stdio.h>

enum DriveMode
{
    ECO,
    NORMAL,
    SPORT
};

struct Vehicle
{
    int speed;
    enum DriveMode mode;
};

void printVehicle(struct Vehicle car)
{
    printf("Speed : %d km/h\n", car.speed);

    printf("Mode  : ");

    switch(car.mode)
    {
        case ECO:
            printf("ECO\n");
            break;

        case NORMAL:
            printf("NORMAL\n");
            break;

        case SPORT:
            printf("SPORT\n");
            break;
    }
}

int main(void)
{
    struct Vehicle myCar;

    myCar.speed = 90;
    myCar.mode = NORMAL;

    printVehicle(myCar);

    return 0;
}