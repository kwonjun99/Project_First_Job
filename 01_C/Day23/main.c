#include <stdio.h>

struct CANMessage
{
    int id;
    int speed;
    int rpm;
    float temperature;
};

void printMessage(struct CANMessage msg)
{
    printf("===== CAN Message =====\n");
    printf("ID          : %d\n", msg.id);
    printf("Speed       : %d km/h\n", msg.speed);
    printf("RPM         : %d\n", msg.rpm);
    printf("Temperature : %.1f C\n", msg.temperature);
}

int main(void)
{
    struct CANMessage msg;

    msg.id = 300;
    msg.speed = 110;
    msg.rpm = 3200;
    msg.temperature = 94.5;

    printMessage(msg);

    return 0;
}