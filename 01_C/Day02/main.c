#include <stdio.h>

/*int main(void)
{
    int currentSpeed = 70;
    int targetSpeed = 100;
    int engineRPM = 2500;
    int gear = 3;

    printf("===== Vehicle Control =======\n");
    printf("Current Speed : %d km/h\n", currentSpeed);
    printf("Target Speed : %d km/h\n", targetSpeed);
    printf("EngineRPM : %d km/h\n", engineRPM);
    printf("Gear : %d km/h\n", gear);

    return 0;
}*/

int main(void)
{
    int currentSpeed = 70;
    int targetSpeed = 100;

    currentSpeed = targetSpeed;
    targetSpeed = 120;

    printf("Current Speed : %d\n", currentSpeed);
    printf("Target Speed  : %d\n", targetSpeed);

    return 0;
}