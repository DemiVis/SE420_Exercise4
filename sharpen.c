#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "ppm.h"

//                         W      H   chan
#define MAX_IMG_SZ      ( 1280 * 720 * 3 )

#define PIXIDX ((i* (*col) * (*chan))+(j* (*chan))+k)
#define SAT (255)

#define OUT_FILENAME        "sharper.ppm"

// requires that newimg points to allocated memory
void sharpen(unsigned char *img, unsigned char *newimg, unsigned * row, unsigned * col, unsigned * chan, float K)
{
    float psf[9] = {-K/8.0, -K/8.0, -K/8.0, -K/8.0, K+1.0, -K/8.0, -K/8.0, -K/8.0, -K/8.0};
    float temp;
    int i, j, k;
    
    int imgWidth = *row, imgHeight = *col, imgChans = *chan;
    
    // Skip first and last row, no neighbors to convolve with
    for(i=1; i<(imgHeight-1); i++)
    {
        // Skip first and last column, no neighbors to convolve with
        for(j=1; j<(imgWidth-1); j++)
        {
            for(k=0; k<imgChans; k++)
            {
                temp=0;
                /*temp += (psf[0] * (float)img[((i-1)*(*col))+j-1]);
                temp += (psf[1] * (float)img[((i-1)*(*col))+j]);
                temp += (psf[2] * (float)img[((i-1)*(*col))+j+1]);
                temp += (psf[3] * (float)img[((i)*(*col))+j-1]);
                temp += (psf[4] * (float)img[((i)*(*col))+j]);
                temp += (psf[5] * (float)img[((i)*(*col))+j+1]);
                temp += (psf[6] * (float)img[((i+1)*(*col))+j-1]);
                temp += (psf[7] * (float)img[((i+1)*(*col))+j]);
                temp += (psf[8] * (float)img[((i+1)*(*col))+j+1]);*/
                temp += psf[0] * (float)img[(i-1)*imgWidth+(j-1)*imgChans+k];
                temp += psf[1] * (float)img[(i-1)*imgWidth+( j )*imgChans+k];
                temp += psf[2] * (float)img[(i-1)*imgWidth+(j+1)*imgChans+k];
                temp += psf[3] * (float)img[( i )*imgWidth+(j-1)*imgChans+k];
                temp += psf[5] * (float)img[( i )*imgWidth+( j )*imgChans+k];
                temp += psf[5] * (float)img[( i )*imgWidth+(j+1)*imgChans+k];
                temp += psf[6] * (float)img[(i+1)*imgWidth+(j-1)*imgChans+k];
                temp += psf[7] * (float)img[(i+1)*imgWidth+( j )*imgChans+k];
                temp += psf[8] * (float)img[(i+1)*imgWidth+(j+1)*imgChans+k];

                if(temp < 0.0) temp = 0.0;
                if(temp > 255.0) temp = 255.0;

                newimg[( i )*imgWidth+( j )*imgChans+k]=(unsigned char)temp;
            }
        }
    }
}

int main(int argc, char *argv[])
{
  char header[512];
  unsigned char img[MAX_IMG_SZ], sharpimg[MAX_IMG_SZ];
  int bufflen, hdrlen; 
  unsigned row=0, col=0, chan=0, pix; int i, j, k;

  if(argc < 2)
  {
      printf("Use: sharpen inputfile\n");
      exit(-1);
  }

  printf("Reading PPM\n");
  header[0]='\0';
  readppm(img, &bufflen, header, &hdrlen, &row, &col, &chan, argv[1]);
  printf("PPM read\n");

  sharpen(img, sharpimg, &row, &col, &chan, 4.0); 

  printf("Writing PPM\n");
  writeppm(sharpimg, bufflen, header, hdrlen, OUT_FILENAME);
  printf("PPM written\n");
}

