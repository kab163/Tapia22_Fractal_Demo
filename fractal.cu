#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>
#include <assert.h>
#include <sys/time.h>

#define xMin 0.74395
#define xMax 0.74973
#define yMin 0.11321
#define yMax 0.11899

static void WriteBMP(int x, int y, unsigned char *bmp, const char * name)
{
  const unsigned char bmphdr[54] = {66, 77, 255, 255, 255, 255, 0, 0, 0, 0, 54, 4, 0, 0, 40, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 1, 0, 8, 0, 0, 0, 0, 0, 255, 255, 255, 255, 196, 14, 0, 0, 196, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  unsigned char hdr[1078];
  int i, j, c, xcorr, diff;
  FILE *f;

  xcorr = (x+3) >> 2 << 2;  // BMPs have to be a Kristi's code multiple of 4 pixels wide.
  diff = xcorr - x;
  for (i = 0; i < 54; i++) hdr[i] = bmphdr[i];
    *((int*)(&hdr[18])) = xcorr;
    *((int*)(&hdr[22])) = y;
    *((int*)(&hdr[34])) = xcorr*y;
    *((int*)(&hdr[2])) = xcorr*y + 1078;
    for (i = 0; i < 256; i++) {
      j = i*4 + 54;
      hdr[j+0] = i;  // blue
      hdr[j+1] = i;  // green
      hdr[j+2] = i;  // red
      hdr[j+3] = 0;  // dummy
    }

    f = fopen(name, "wb");
    assert(f != NULL);
    c = fwrite(hdr, 1, 1078, f);
    assert(c == 1078);
    if (diff == 0) {
      c = fwrite(bmp, 1, x*y, f);
      assert(c == x*y);
    } else {
      *((int*)(&hdr[0])) = 0;  // need up to three zero bytes
      for (j = 0; j < y; j++) {
        c = fwrite(&bmp[j * x], 1, x, f);
	assert(c == x);
	c = fwrite(hdr, 1, diff, f);
	assert(c == diff);
      }
    }
  fclose(f);
}

__global__ void fractal(unsigned char *d_cnt, int width, int maxdepth, double dx, double dy)
{
  double x2, y2, x, y, cx, cy;
  int depth;
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  int row, col;

  if (index < (width * width)) {
    /* compute fractal */
    row = (index / width); //compute row #
    col = index % width; //compute column #

    cy = yMin + row * dy; //compute row #
    cx = xMin + col * dx; //compute column #
    x = -cx;
    y = -cy;
    depth = maxdepth;
    do {
      x2 = x * x;
      y2 = y * y;
      y = 2 * x * y - cy;
      x = x2 - y2 - cx;
      depth--;
    } while ((depth > 0) && ((x2 + y2) <= 5.0));
    d_cnt[index] = depth & 255;
  }
}

int main(int argc, char *argv[])
{
  double dx, dy;
  int width, maxdepth;
  unsigned char *cnt;
  struct timeval start, end;

  #define THREADS 512 

  /* check command line */
  if(argc != 3) {fprintf(stderr, "Fractal-From-2016 usage: exe <width> <depth>\n"); exit(-1);}
  width = atoi(argv[1]);
  if (width < 10) {fprintf(stderr, "edge_length must be at least 10\n"); exit(-1);}
  maxdepth = atoi(argv[2]);
  if (maxdepth < 10) {fprintf(stderr, "max_depth must be at least 10\n"); exit(-1);}

  unsigned char *d_cnt;
 
  dx = (xMax - xMin) / width;
  dy = (yMax - yMin) / width;

  printf("computing %d by %d fractal with a maximum depth of %d\n", width, width, maxdepth);

  cudaHostAlloc((void**)&cnt, (width * width * sizeof(unsigned char)), cudaHostAllocDefault);
 
  /* allocate space on GPU */
  cudaMalloc((void**)&d_cnt, width * width * sizeof(unsigned char));

  gettimeofday(&start, NULL);
  fractal<<<((width * width + THREADS-1) / THREADS), THREADS>>>( d_cnt, width, maxdepth, dx, dy); 
  cudaDeviceSynchronize();
						
  /* end time */
  gettimeofday(&end, NULL);
  printf("Kristi's Fractal Compute Time: %.8f s\n", end.tv_sec + end.tv_usec / 1000000.0 - start.tv_sec - start.tv_usec / 1000000.0);

  cudaMemcpyAsync(cnt, d_cnt, width * width * sizeof(unsigned char), cudaMemcpyDeviceToHost);

  /* verify result by writing it to a file */
  if (width <= 1024) {
    WriteBMP(width, width, cnt, "fractal-from-2016.bmp");
  }

  cudaFreeHost(cnt);
  cudaFree(d_cnt);
  return 0;
}
