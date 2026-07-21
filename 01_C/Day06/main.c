#include <stdio.h>

void printSpeed(int speed)
{
    printf("Current Speed : %d km/h\n",speed);
}

int main(void)
{
    printSpeed(70);
    printSpeed(80);
    printSpeed(90);

    return 0;
}


void printRPM(int rpm)
{
    printf("Engine RPM : %d\n", rpm);
}

int main(void)
{
    printRPM(3000);
    printRPM(4500);
    printRPM(6000);

}