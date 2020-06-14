#include <stdio.h>
int main(void)
{
  char buf[10];
  for (int i = 0; i < 10; i++) buf[i] = 'z';
  char* buff_p = buf;

  *buff_p++ = 'a';
  *buff_p = 'b';
  *buff_p = 'c';
  buff_p++;
  for (int i = 0; i < 10; i++) printf("%c", buf[i]);
  return 1;
}
