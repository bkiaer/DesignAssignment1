/*
 * kiaer_asst_1.c
 *
 * Created: 2/20/2018 10:36:46 AM
 * Author : Brian Kiaer
 */ 

#include <avr/io.h>
#include <stdio.h>

int main(void)
{

  int counter1, counter2, i, starth, startl;
  int X[300], Y[300], Z[300]; //stored values
  int temp; //temporary integer
  int z_count,y_count; //counters for Y and Z registers
  int final_y; //final values
  int final_z;

  final_y = 0;
  final_z = 0;
  counter1 = 0x012C; //set counter to 300
  starth = 0x02;
  startl = 0x22; //assign starting address number
  z_count = 0;
  y_count = 0;

  counter2 = 0x0222; //set another counter to manage overflow
  for(i = 0; i < counter1; i++)
    {
      if(counter2 == 0x0300 || counter2 == 0x0466 ||counter2 == 0x05CA ){
        starth++; //if these numbers are reached than increment the high value to simulate a carry
        counter2 = counter2+100;
      }
      X[i] = startl + starth;
      startl = X[i];
      if(X[i] >= 0x0300) //to simulate similar to the assembly code, I limited the values to only output in 8-bits hex values
        X[i] = X[i] - 0x0300;
      if(X[i] >= 0x0200)
        X[i] = X[i] - 0x0100;
      if(X[i] >= 0x0100)
        X[i] = X[i] - 0x0100; 
          counter2 = counter2 +starth;
    }

  for(i = 0; i < counter1; i++)
    {
      temp = X[i]%0x05; //if remainder is 0 then it is divisible by 5
      if(temp == 0)//if 0 store in Y array
        {
          Y[y_count] = X[i];
          y_count++;
        }
      else
        if(temp != 0) //if not 0 then store in Z array
          {
            Z[z_count] = X[i];
            z_count++;
          }
    }
  for(i = 0; i < y_count; i++) // add all Y values
    {
      final_y = final_y + Y[i];
    }
  for(i= 0; i < z_count; i++) //add all Z values
    {
    final_z = final_z + Z[i];
    }
  printf("FINAL Y:%x X:%X\n", final_y, final_z);

  return 0;
}