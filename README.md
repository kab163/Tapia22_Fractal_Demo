# Tapia22_Fractal_Demo
Demonstration of a CUDA parallelized fractal program

# Building Demo
To build the code, first make sure your nvcc is present.

	$ nvcc --version
	nvcc: NVIDIA (R) Cuda compiler driver
	Copyright (c) 2005-2019 NVIDIA Corporation
	Built on Sun_Jul_28_19:07:52_PDT_2019
	Cuda compilation tools, release 10.1, V10.1.243

If you do not have nvcc available, this command will not run. You can also check to see your CUDA version and GPU type.

	$ nvidia-smi
	+-----------------------------------------------------------------------------+
	| NVIDIA-SMI 510.47.03    Driver Version: 510.47.03    CUDA Version: 11.6     |
	|-------------------------------+----------------------+----------------------+
	...
	Tesla V100

Next, build the code with:

	$ nvcc fractal.cu

# Running Code and Checking Results
To run the code, do the following:

	$ ./a.out 1024 256

This will generate a 1024 by 1024 fractal image with a maximum depth of 256. A resulting .bmp image will be written out that you can use to check for correctness. If the image is distorted or broken, you know something went wrong! See example `fractal.bmp` file to see what the correct image should look like.
