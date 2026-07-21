#include <stdio.h>

/*
int main(void)
{
    int currentSpeed = 120;
    int targetSpeed = 100;

    if (currentSpeed < targetSpeed)
{
    printf("Accelerate\n");
}
else if (currentSpeed == targetSpeed)
{
    printf("Maintain Speed\n");
}
else
{
    printf("Brake\n");
}
    return 0;
} */

//조건 rpm = 4500 
// 3000미만 -> Low Rpm, 3000 이상 5000미만 normal rpm , 5000이상 high rpm
int main(void)
{
    int rpm = 4500;
    
    if (rpm<3000)
    {
        printf("Low RPM\n");
    }
    else if (rpm >= 3000 && rpm < 5000)
    {
        printf("Normal RPM\n");
    }
    else 
    {
        printf("High RPM\n");
    }
}