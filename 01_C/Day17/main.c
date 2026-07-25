#include <stdio.h>

struct Car
{
    int speed;
    int rpm;
};

int main(void)
{
    struct Car cars[3];

    cars[0].speed = 80;
    cars[0].rpm = 2200;

    cars[1].speed = 100;
    cars[1].rpm = 2800;

    cars[2].speed = 120;
    cars[2].rpm = 3500;

    for(int i = 0; i < 3; i++)
    {
        printf("Car %d\n", i + 1);
        printf("Speed : %d km/h\n", cars[i].speed);
        printf("RPM   : %d\n\n", cars[i].rpm);
    }

    return 0;
}

/*
#include <stdio.h>

struct Car
{
    int speed;
    int rpm;
};

int main(void)
{
    struct Car cars[4];

    cars[0].speed = 60;
    cars[0].rpm = 1500;

    cars[1].speed = 80;
    cars[1].rpm = 2200;

    cars[2].speed = 100;
    cars[2].rpm = 3000;

    cars[3].speed = 120;
    cars[3].rpm = 3800;

    for(int i = 0; i < 4; i++)
    {
        printf("Speed : %d km/h\n", cars[i].speed);
        printf("RPM   : %d\n\n", cars[i].rpm);
    }

    return 0;
}
*/