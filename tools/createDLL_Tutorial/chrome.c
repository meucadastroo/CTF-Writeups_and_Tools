#include <stdio.h>
#include <stdlib.h>
 
int main(int argc,char **argv)
{
 callCmd();
 return 0;
}

int callCmd()
{
 system("start chrome.exe");
 system("pause");
}