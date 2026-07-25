#include <stdio.h>

struct VehicleData
{
    int speed;
    int rpm;
};

void printData(struct VehicleData data)
{
    printf("Speed : %d km/h", data.speed);
    printf("RPM   : %d\n", data.rpm);
}

int main(void)
{
    struct VehicleData log[4] =
    {
        {50,1200},
        {70,1800},
        {90,2500},
        {120,3600}
    };

    for(int i = 0; i < 4; i++)
    {
        printData(log[i]);
        printf("-----------------\n");
    }

    return 0;
}