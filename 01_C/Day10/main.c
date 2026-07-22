//pointer
#include <stdio.h>


int main(void)
{
    int speed = 60;

    int *p = &speed;
    
    *p = 100;

    printf("%p\n", &speed);
    printf("Address : %p\n", (void*)&speed);


    return 0;

}

//자동차에서
//ReadSensor(&speed);
//SendData(&vehicle);

