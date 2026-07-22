

/* Const 개념 정리
#include <stdio.h>

int main(void)
{
    const int MAX_SPEED = 120;

    printf("%d\n", MAX_SPEED);

    return 0;
}
 파일쓰기 ->
 #include <stdio.h>

int main(void)
{
    FILE *fp;

    fp = fopen("data.txt","w");

    fprintf(fp,"Automtive Control");

    fclose(fp);

    return 0;
}int main(void)
{
    FILE *fp;
    int Automotive Control;

    fp = fopen("data.txt","r");

    printf("%d\n",Automotive Control);

    fclose(fp);

    return 0;
}
*/
#include <stdio.h>

int main(void)
{
    FILE *fp;

    fp = fopen("speed.txt","w");

    fprintf(fp,"100");

    fclose(fp);

    return 0;
}
/* 파일 읽기->
#include <stdio.h>

int main(void)
{
    FILE *fp;
    int speed;

    fp = fopen("speed.txt","r");

    fscanf(fp,"%d",&speed);

    printf("%d\n",speed);

    fclose(fp);

    return 0;
}
*/