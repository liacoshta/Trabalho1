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
	
|EXPRESSAO EXP EXPRESSAO  {/* operação de exponenciação*/
	printf("; Encontrei potencia: %d ^ %d = ", $1, $3);
		$$=1;
        while ($3>0){
			$$= $$*$1;
			$3= $3-1;
		}
	printf(" %d\n",$$);
	/* Initialisção: registrador a 0, caso ja tinha alguma coisa*/
        printf("MOV A, 0 \n");
        printf("MOV B, 0 \n");
	printf("MOV C, 0 \n");
        /*Incio operação*/
        printf("POP B\n");/* topo(=exposant) copiado no B*/
        printf("POP C\n");/*novo  topo(=numero elevado) no C*/
	/*Oprecao MUL acontece no registrador A*/ 
	printf("MOV A, 1 \n");/*$$=1*/
	printf("while: CMP B,00 \n");/*O exposant é zero?*/
	printf("JBE fim\n");/*Se é zero , não tem calculo, não faz o while*/
        printf("MUL C\n");/* $$=$$*$1 */
	printf("DEC B\n");/* $3-- */
	printf("CMP B, 00 \n"); /* O exposant é zero?*/
	printf("JA while \n");/* Se não é volta por o inicio da loop**/
        printf("fim: PUSH A\n"); /*resultado no topo da pilha*/
        }
|EXPRESSAO DIV EXPRESSAO  {/* operação divisão*/
        printf("; Encontrei divisao: %d / %d = %d\n", $1, $3, $1/$3);
        $$ = $1 / $3;
 	/* Initialisção: registrador a 0, caso ja tinha alguma coisa*/
        printf("MOV A, 0 \n");
        printf("MOV B, 0 \n");
        /*Incio operação*/
        printf("POP A\n");/* topo copiado no A*/
        printf("POP B\n");/*novo  topo no B*/
        printf("DIV B\n");/* resultado da divisao no A*/
        printf("PUSH A\n"); /*resultado no topo da pilha*/
        /* retirar os primeros fator de cada pihla e divisar o valor de A por B
        e retornar o resultado na pilha*/
        }

	| EXPRESSAO MULT EXPRESSAO  {/*operação multiplicação*/
        printf("; Encontrei multiplicacao: %d * %d = %d\n", $1, $3, $1*$3);
       	$$ = $1 * $3;
	/* Initialisção: registrador a 0, caso ja tinha alguma coisa*/
        printf("MOV A, 0 \n");
        printf("MOV B, 0 \n");
        /*Incio operação*/
        printf("POP A\n");/* topo copiado no A*/
        printf("POP B\n");/*novo  topo no B*/
        printf("MUL B\n");/* resultado da multiplicacao no A*/
        printf("PUSH A\n"); /*resultado no topo da pilha*/
        /* retirar os primeros fator de cada pihla, multiplicar o valor de A por B
        e retornar o resultado na pilha*/
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
