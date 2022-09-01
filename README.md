# Tapia22_Fractal_Demo
Demonstration of a CUDA parallelized fractal program. This fractal code was created by Dr. Martin Burtscher and the [Efficient Computing Laboratory (ECL)](https://userweb.cs.txstate.edu/~burtscher/) at Texas State University. This program calculates pixel values according to a fractal generation algorithm (Mandelbrot set). The resulting pixels are then displayed as an image.

# Building The Fractal Code
To build the code, we first need to make sure we have some prerequisites. Namely, we must have a GPU on our system and we must have the CUDA toolkit installed. First, we can check to see if the `nvcc` compiler is present.

	$ nvcc --version
	nvcc: NVIDIA (R) Cuda compiler driver
	Copyright (c) 2005-2019 NVIDIA Corporation
	Built on Sun_Jul_28_19:07:52_PDT_2019
	Cuda compilation tools, release 10.1, V10.1.243

If you do not have `nvcc` available, this command will not run or produce some error. If the command above doesn't work, you must first solve that issue before continuing. Otherwise, we can then also check to see the CUDA versions and GPU type.

	$ nvidia-smi
	+-----------------------------------------------------------------------------+
	| NVIDIA-SMI 510.47.03    Driver Version: 510.47.03    CUDA Version: 11.6     |
	|-------------------------------+----------------------+----------------------+
	...
	Tesla V100

On my machine, this command prints out the driver and CUDA API versions, as well as the type of GPU I have. If the `nvidia-smi` command does not work, something is wrong and more error checking should be done to see why it's not working before continuing.

At this point, you can now build the code with:

	$ nvcc fractal.cu

As you become more confident with GPU programming, you can test building the source code with other compiler optimization options such as `-O3` or `-arch=sm_**` (replace the `**` with the appropriate value targeting the architecture type of your GPU). For example, with my Tesla V100 GPU, I could use a `-arch=sm_70` flag when compiling. Using that flag can allow the `nvcc` compiler to use certain optimizations while building. See more information on compute architectures [here](https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/).

# Running Code and Checking Results
To run the code, do the following:

	$ ./a.out 1024 256

This will generate a 1024 by 1024 fractal image with a maximum depth of 256. As you can see, the first parameter is the width of the image. You can play around with generating smaller or larger images. (Note that you will see better performance with larger images.) Additionally, the second parameter is for the depth of the fractal. This is the value for how deep the fractal goes. The fractal depth is part of the Mandelbrot set algorithm. 

For more information on the usage, simply run `./a.out` and an error message will be printed out about the required run command parameters. 

After a successful run, a resulting .bmp image will be written out that you can use to check for correctness. If the image is distorted or broken, you know something went wrong! See example `fractal.bmp` file to see what the correct image should look like.

# Getting Help and Follow-Up
If you get stuck along the way, feel free to reach out to me with questions. My email is `belcher6(at)llnl(dot)gov`.
