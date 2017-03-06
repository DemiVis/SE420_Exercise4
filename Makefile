INCLUDE_DIRS = 
LIB_DIRS = 
CC=gcc

CDEFS=
CFLAGS= -O0 -g $(INCLUDE_DIRS) $(CDEFS)
LIBS=

HFILES= 
CFILES= img_proc.c

SRCS= ${HFILES} ${CFILES}
COBJS= ${CILES:.c=.o}

all:	img_proc img_proc.asm

clean:
	-rm -f *.o *.d brighter.ppm brightc.asm
	-rm -f img_proc

distclean:
	-rm -f *.o *.d

img_proc: img_proc.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $@.o $(LIBS)

brightc.asm: img_proc.c
	$(CC) -O0 -S $< -o $@

depend:

.c.o:
	$(CC) $(CFLAGS) -c $<
