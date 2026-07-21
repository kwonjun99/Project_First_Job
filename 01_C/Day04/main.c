#include <stdio.h>

int main(void)
{
    int currentSpeed = 70;
    int targetSpeed = 100;

    while (currentSpeed < targetSpeed)
    {
        currentSpeed = currentSpeed + 5;
        printf("Current Speed : %d km/h\n", currentSpeed);
    }

    return 0;
}
/*
#include<stdio.h>

int main(void)
{
    int rpm = 1000;

    while(rpm < 5000)
    {
        rpm = rpm + 500;
        printf("%d\n", rpm);
    }
    return 0;
}




*/