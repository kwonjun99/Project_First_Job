#include <stdio.h>

struct Sensor
{
    int speed;
    int rpm;
    float temperature;
};

void updateSensor(struct Sensor *car, int speed, int rpm, float temp)
{
    car->speed = speed;
    car->rpm = rpm;
    car->temperature = temp;
}

void printSensor(struct Sensor car)
{
    printf("===== Vehicle Sensor =====\n");
    printf("Speed       : %d km/h\n", car.speed);
    printf("RPM         : %d\n", car.rpm);
    printf("Temperature : %.1f C\n", car.temperature);
}

int main(void)
{
    struct Sensor vehicle = {0, 0, 0};

    updateSensor(&vehicle, 80, 2200, 88.5);

    printSensor(vehicle);

    return 0;
}