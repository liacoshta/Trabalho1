%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);

%}

%token INT MULT DIV SOMA EOL '(' ')' EXP
%left SOMA
%left MULT 
%left DIV
%left EXP
%left '(' ')'

%%

PROGRAMA:
	/*topo do arvore, poner o resultado no registrador A (recuperar a valor do topo
da pilha)*/
        PROGRAMA EXPRESSAO EOL { printf("; Resultado: %d\n", $2);
					printf("POP A\n"); }/*Topo da pilha em A*/
        |
        ;


EXPRESSAO:
    INT { $$ = $1;
		printf("PUSH %d\n",$1);
	/*copia o int na pilha (coloca o dado no topo da pilha)*/
          }
	/*Regras de prioridade*/	  
	|'('EXPRESSAO')'{$$=$2;}
	
	|EXPRESSAO EXP EXPRESSAO  {
	printf("Encontrei potencia: %d ^ %d = ", $1, $3);
		$$=1;
        while ($3>0){
			$$= $$*$1;
			$3= $3-1;
		}
	printf(" %d\n",$$);	
        }

	|EXPRESSAO DIV EXPRESSAO  {
        printf("Encontrei divisao: %d / %d = %d\n", $1, $3, $1/$3);
        $$ = $1 / $3;
        }

	| EXPRESSAO MULT EXPRESSAO  {
        printf("Encontrei multiplicacao: %d * %d = %d\n", $1, $3, $1*$3);
        $$ = $1 * $3;
        }

	| EXPRESSAO SOMA EXPRESSAO  {/*Função da opreção soma*/
        printf("; Encontrei soma: %d + %d = %d\n", $1, $3, $1+$3);
        $$ = $1 + $3; /*parte lex em comentario assembly para entender */
	/* Initialisção: registrador a 0, caso ja tinha alguma coisa*/
	printf("MOV A, 0 \n");
	printf("MOV B, 0 \n");
	printf("MOV C, 0 \n");
	/*Incio operação*/
	printf("POP C\n");/* topo copiado no C*/
	printf("POP B\n");/*novo  topo no B*/
	printf("ADD B,C\n");/* resultado da soma no B*/
	printf("PUSH B\n"); /*resultado no topo da pilha*/
	/* retirar os primeros fator de cada pihla e somar os valores de B e C
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
