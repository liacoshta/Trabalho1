all: main

main : lex.yy.c y.tab.c
		gcc -omain lex.yy.c y.tab.c -ll

lex.yy.c: main.l y.tab.c
		flex main.l

y.tab.c:main.y
		bison -dy main.y

clean:
		rm y.tab.c lex.yy.c y.tab.h main
