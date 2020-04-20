FLAGS = -std=c11

LIBS = -I.

all: yatzy

yatzy: main.c
	gcc ${FLAGS} ${LIBS} -o $@ $^

clean: 
	$(RM) *.o yatzy 

