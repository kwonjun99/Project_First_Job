#include <stdio.h>

int main(void)
{
    int speed[5] = {60,70,80,90,100};

    for(int i=0;i<5;i++)
    {
        printf("%d\n",speed[i]);
    }

    return 0;
} // 배열은 0부터 시작!

/*int main(void)
{
    int rpm[5] = {1000,2000,3000,4000,5000};

    for(int i=0; i<5; i++)
    {
        printf("%d\n", rpm[i]);

    }
    return 0;
}*/

/*int main(void)
{
    int speed[7] = {70,75,80,85,90,95,100};
    
    for(int i=0; i<7; i++)
    {
        printf("%d\n",speed[i]);
    }
    return 0;
}
*/
