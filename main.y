%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);

%}

%token INT MULT DIV SUB SOMA EOL '(' ')' EXP
%left SOMA SUB
%left MULT 
%left DIV
%left EXP
%left '(' ')'

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL { printf("Resultado: %d\n", $2); }
        |
        ;


EXPRESSAO:
    INT { $$ = $1;
          }
		  
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
	| EXPRESSAO SUB EXPRESSAO  {
        printf("Encontrei subtracao: %d - %d = %d\n", $1, $3, $1-$3);
        $$ = $1 - $3;
        }
	| EXPRESSAO SOMA EXPRESSAO  {
        printf("Encontrei soma: %d + %d = %d\n", $1, $3, $1+$3);
        $$ = $1 + $3;
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
