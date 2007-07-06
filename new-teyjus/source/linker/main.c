#include <stdlib.h>
#include <stdio.h>
#include "module.h"

int main(int argc, char* argv[])
{
  //TODO Check more arguments and validate them.
  if(argc<2)
  {
    printf("Missing argument module name");
    exit(0);
  }
  
  EM_TRY
  {
    InitAll();
    LoadTopModule(argv[1]);
    WriteAll(argv[1]);
  }
  EM_CATCH
  {
    printf("An exception occured.\n");
    return 0;
  }
  return 0;
}
