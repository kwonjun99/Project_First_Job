#include <stdio.h>

struct Sensor
{
    int rpm;
    float temperature;
};

void printSensor(struct Sensor sensor)
{
    printf("RPM : %d\n", sensor.rpm);
    printf("Temperature : %.1f\n", sensor.temperature);
}

int main(void)
{
    struct Sensor engine;

    engine.rpm = 5000;
    engine.temperature = 102.8;

    printSensor(engine);

    return 0;
}