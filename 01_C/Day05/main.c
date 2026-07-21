#include <stdio.h>

/*
int main(void)
{
    int i;

    for(i=1; i<=5; i++)
    {
        printf("%d\n", i);

    }
    return 0;
}

==

int main(void)
{
    int i=1;

    while(i<=5)
    {
        printf("%d\n", i);
        i++;
    }
    return 0;
}

*/

int main(void)
{
    int speed;
    for(int speed=50; speed<=100; speed+=10)
{
    printf("%d\n",speed);
}
    return 0;

}

/*int main(void)
{
    for(int rpm=1000; rpm<=6000; rpm+=500)
    {
        printf("%d\n",rpm);
    }
    return 0;
}*/
