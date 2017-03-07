#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "ppm.h"

#define PIXIDX ((i* (*col) * (*chan))+(j* (*chan))+k)
#define SAT (255)

#define OUT_FILENAME        "brighter.ppm"

// requires that newig points to allocated memory
void brighten(unsigned char *img, unsigned char *newimg, unsigned * row, unsigned * col, unsigned * chan, double alpha, double beta)
{
    int pix, i, j, k;
    
    for(i=0; i < *row; i++)
      for(j=0; j < *col; j++)
        for(k=0; k < *chan; k++)
        {
            newimg[PIXIDX] = (pix=(unsigned)((img[PIXIDX])*alpha)+beta) > SAT ? SAT : pix;
        }
}

int main(int argc, char *argv[])
{
  char header[512];
  unsigned char img[640*480*3], brightimg[640*480*3];
  int bufflen, hdrlen; 
  unsigned row=0, col=0, chan=0, pix; int i, j, k;
  double alpha=1.25;  unsigned char beta=25;

  if(argc < 2)
  {
      printf("Use: brighten inputfile\n");
      exit(-1);
  }

  printf("Reading PPM\n");
  header[0]='\0';
  readppm(img, &bufflen, header, &hdrlen, &row, &col, &chan, argv[1]);
  printf("PPM read\n");

  brighten(img, brightimg, &row, &col, &chan, alpha, beta); 

  printf("Writing PPM\n");
  writeppm(brightimg, bufflen, header, hdrlen, OUT_FILENAME);
  printf("PPM written\n");
}

