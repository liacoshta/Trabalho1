/* Trabalho 1: Calculadora Assembly
	*Anne-Laure Stéphanie RA:230807
	*Lia Costa RA:159834
*/

%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);
int loop_num=1; /* Para evitar o conflito de loop no caso de varios exp*/
int intialisacao=1; /*Para inicializar(zerar) os registradores no inicio*/
%}

%token INT MULT DIV SOMA EOL '(' ')' EXP
%left SOMA
%left MULT 
%left DIV
%left EXP
%left '(' ')'

%%

PROGRAMA:
	/*topo do arvore, por o resultado no registrador A (recuperar a valor do topo da pilha)*/
        PROGRAMA EXPRESSAO EOL {
		printf("POP A\n");/*Topo da pilha em A*/
	loop_num=1;
			}
        |
        ;


EXPRESSAO:
    INT { $$ = $1;
		printf("\nPUSH %d\n", $1);/*copia o int na pilha (coloca o dado no topo da pilha)*/
		if (intialisacao == 1){
		/* Initialisção: registrador a 0, caso ja tinha alguma coisa*/
			printf("MOV A, 0 \n");
			printf("MOV B, 0 \n");
			printf("MOV C, 0 \n");
			intialisacao ++; /* Para não zerar de novo*/
          }
	}
/*Regras e prioridade*/	  
	|'('EXPRESSAO')'{$$=$2;}/*prioridade aos parenteses*/
	
	|EXPRESSAO EXP EXPRESSAO  {
    /*Incio operação exponenciação em assembly*/
        printf("POP B\n");/* topo(=expoente) copiado no B*/
        printf("POP C\n");/*novo topo(=base da operação) no C*/
	/*Oprecao MUL acontece no registrador A*/ 
	printf("MOV A, 1\n");/*$$=1*/
		printf("WHILE%d:\n",loop_num);
	printf("CMP B, 0\n");/*O exposant é zero?*/
	printf("JE FIM%d\n",loop_num);/* Se for igual zero, Não faz calculo e vai para Fim.*/
    	printf("MUL C\n");/* $$=$$*$1 */
	printf("DEC B\n");/* $3-- */
	printf("CMP B, 0\n"); /* O exposant é zero?*/
	printf("JNE WHILE%d\n",loop_num);/* Se não é igual a zero, volta para o inicio da loop*/
	printf("JE FIM%d\n",loop_num);/*O expoente é zero?*/
       		printf("FIM%d:\n",loop_num);
	printf("PUSH A\n"); /*resultado no topo da pilha*/
	loop_num ++; /*Mudar o nome do proxima loop, para não haver conflito*/
        }

	|EXPRESSAO DIV EXPRESSAO  {
        
    /*Incio operação divisão*/
        printf("POP B\n");/* topo copiado no A*/
        printf("POP A\n");/*novo  topo no B*/
        printf("DIV B\n");/* resultado da divisao no A*/
        printf("PUSH A\n"); /*resultado no topo da pilha*/
    /* retirar os primeros fator de cada pilha e dividir o valor de A por B
       e retornar o resultado na pilha*/
        }

	| EXPRESSAO MULT EXPRESSAO  {
	
     /*Incio operaçã multiplicação*/
        printf("POP A\n");/* topo copiado no A*/
        printf("POP B\n");/*novo  topo no B*/
        printf("MUL B\n");/* resultado da multiplicacao no A*/
        printf("PUSH A\n"); /*resultado no topo da pilha*/
    /* retirar os primeros fator de cada pihla, multiplicar o valor de A por B
       e retornar o resultado na pilha*/
        }

	| EXPRESSAO SOMA EXPRESSAO  {
   /*Incio operação soma*/
	printf("POP A\n");/* topo copiado no A*/
	printf("POP B\n");/*novo  topo no B*/
	printf("ADD A,B\n");/* resultado da soma no A*/
	printf("PUSH A\n"); /*resultado no topo da pilha*/
	/* retirar os primeros fator de cada pihla, somar os valores de A e B
	e retornar o resultado na pilha*/
        }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;

}
