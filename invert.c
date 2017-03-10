#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "ppm.h"

//                         W      H   chan
#define MAX_IMG_SZ      ( 1280 * 720 * 3 )

#define PIXIDX ((i* (*col) * (*chan))+(j* (*chan))+k)
#define SAT (255)

#define OUT_FILENAME        "inverted.ppm"

// requires that newimg points to allocated memory
void invert(unsigned char *img, unsigned char *newimg, unsigned * row, unsigned * col, unsigned * chan)
{
    int pix, i, j, k;
    unsigned char newPix;
    
    printf("Begin Inversion...");
    
    for(i=0; i < *row; i++)
      for(j=0; j < *col; j++)
        for(k=0; k < *chan; k++)
        {
            newimg[PIXIDX] = SAT - img[PIXIDX];
        }
    
    printf(" done.\n");
}

int main(int argc, char *argv[])
{
  char header[512];
  unsigned char img[MAX_IMG_SZ], invertedimg[MAX_IMG_SZ];
  int bufflen, hdrlen; 
  unsigned row=0, col=0, chan=0;
  
  if(argc != 2)
  {
      printf("Use: invert inputfile\n");
      exit(-1);
  }

  printf("Reading PPM\n");
  header[0]='\0';
  readppm(img, &bufflen, header, &hdrlen, &row, &col, &chan, argv[1]);
  printf("PPM read\n");

  invert(img, invertedimg, &row, &col, &chan); 

  printf("Writing PPM\n");
  writeppm(invertedimg, bufflen, header, hdrlen, OUT_FILENAME);
  printf("PPM written\n");
}

