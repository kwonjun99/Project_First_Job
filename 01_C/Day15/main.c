
/* malloc 
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *speed;

    speed = (int *)malloc(sizeof(int));

    *speed = 120;
    
    printf("%d\n", *speed);

    free(speed);

    return 0;
}
*/

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *rpm;

    rpm = (int *)malloc(sizeof(int) * 5);

    for(int i=0;i<5;i++)
    {
        rpm[i]=(i+1)*1000;
    }

    for(int i=0;i<5;i++)
    {
        printf("%d\n",rpm[i]);
    }

    free(rpm);

    return 0;
}

/* 배열 4개 malloc으로 만들기
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *box;

    box = (int *)malloc(sizeof(int) * 4);

    for(int i=0;i<4;i++)
    {
        box[i]=(i+1)*10+40;
    }

    for(int i=0;i<4;i++)
    {
        printf("%d\n",box[i]);
    }

    free(box);

    return 0;
}
*/