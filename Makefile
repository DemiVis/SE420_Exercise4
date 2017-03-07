CXX=g++
PRODUCT= test_benchmarks

all: options.o bright invert sharpen
	
options.o:
	g++ -c -lpthread options.cpp ppm.cpp -I./

bright: bright.o
	g++ $@.c -o $@ options.o ppm.o
	
invert: invert.o
	g++ $@.c -o $@ options.o ppm.o
	
sharpen: sharpen.o
	g++ $@.c sharpen.c -o $@ options.o ppm.o
	
sobel: sobel.o
	g++ $@.c -o $@ options.o ppm.o

%.o: %.c
	${CXX} -c $< -o $@
	
clean:
	rm -f *.o *~ *.ppm