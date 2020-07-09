%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);

%}

%token INT MULT DIV SUB SOMA EOL '(' ')' EXP
%left SUB
%left MULT 
%left DIV
%left EXP
%left '(' ')'

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL { $$=$2 ;}
        |
        ;


EXPRESSAO:
    INT { $$ = $1;
          }
		  
	|'('EXPRESSAO')'{$$=$2;}
	
	|EXPRESSAO EXP EXPRESSAO  {
	printf ("MOV A, %d \n	MOV B, %d \n	loop:\n 	 MUL A\n	 DEC B\n	 CMP B,0\n	 JNZ loop\n	PUSH A\n", $1, $3);
	}

	|EXPRESSAO DIV EXPRESSAO  {
        printf("MOV A, %d\n MOV B, %d\n DIV B\n PUSH A\n", $1, $3);
        
        }

	| EXPRESSAO MULT EXPRESSAO  {
        printf("MOV A, %d\n MOV B,%d\n MUL B\n PUSH A\n", $1, $3);
        
        }
	| EXPRESSAO SUB EXPRESSAO  {
        printf("MOV A,%d\n MOV B,%d\n SUB A,B\n", $1, $3);
      
        }
	| EXPRESSAO SOMA EXPRESSAO  {
        printf("CMP SP, E7\n JNE loop2\n MOV A,%d\n MOV B,%d\n ADD A, B\n loop2:\n POP A\n MOV B,%d\n ADD A,B\n CMP SP, E7\n JNE loop2\n PUSH A\n",$1,$3, $3);
       
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
