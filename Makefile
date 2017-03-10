CXX=g++
PRODUCT= test_benchmarks

all: bright invert sharpen
	chmod 755 pipeline_script

bright: bright.o
	g++ $@.c -o $@ ppm.o
	
invert: invert.o
	g++ $@.c -o $@ ppm.o
	
sharpen: sharpen.o
	g++ $@.c -o $@ ppm.o
	
sobel: sobel.o
	g++ $@.c -o $@ ppm.o

%.o: %.c
	${CXX} -c $< -o $@
	
clean:
	rm -f *.o *~ 
	rm -f brighter.ppm inverted.ppm sharper.ppm brighter_inverted.ppm