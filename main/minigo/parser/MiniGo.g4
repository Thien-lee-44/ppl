grammar MiniGo;

@lexer::header {
from lexererr import *
}

@lexer::members {
    self.pretk="";
def emit(self):
    tk = self.type
    if tk == self.UNCLOSE_STRING:       
        result = super().emit();
        raise UncloseString(result.text);
    elif tk == self.ILLEGAL_ESCAPE:
        result = super().emit();
        raise IllegalEscape(result.text);
    elif tk == self.ERROR_CHAR:
        result = super().emit();
        raise ErrorToken(result.text); 
    else:
        if tk==self.NL:
            list_endline=[self.ID,self.INT,self.FLOAT,self.BOOL,self.STRING,self.TYPE,self.RETURN,self.CONTINUE,self.BREAK,self.RB,self.RP,self.RS]
            for sym in list_endline:
                if self.pretk == sym:
                    self.type=self.SM
                    self.text=';'
                    self.pretk=tk;
                    return super().emit();
            return self.nextToken();
        self.pretk=tk;
        return super().emit();
       
}

options{
	language=Python3;
}

program  : decl+ EOF ;

decl: decl_body endline;
endline: SM|EOF;
decl_body:constdecl | vardecl | structdecl | interdecl |funcdecl;

constdecl: CONST ID EQ expr;

vardecl: VAR ID def_var;
def_var:type_var|init|type_var init;
type_option:type_var|;
type_var: arraytype| TYPE ;
arraytype: LS INT RS arraytype| TYPE;
init: EQ expr;
structdecl: STRUCT;
interdecl: INTERFACE;
funcdecl: FUNC ID LP list_param  RP type_option func_body;
list_param: param tail_list_param|;
tail_list_param: CM param tail_list_param|;
param: list_id type_var;
list_id: list_id CM ID|ID;
func_body: LB list_stmt RB;
list_stmt: stmt list_stmt|;
stmt:stmt_body SM;
stmt_body:vardecl|constdecl|asign|if_stmt|for_stmt|break_stmt|contin_stmt|call_stmt|return_stmt;
asign:lhs ASSIG expr;
lhs:ID |array_element|struct_field;

if_stmt: IF LP expr RP  ;
for_stmt: FOR list_id ;
break_stmt: BREAK;
contin_stmt: CONTINUE;
call_stmt:lhs LP list_expr RP;
return_stmt: RETURN expr SM|RETURN;
list_expr:expr tail_expr|;
tail_expr: CM expr tail_expr|;
expr: expr OR expr1|expr1;
expr1: expr1 AND expr2| expr2;
expr2: expr2 COMP expr3|expr3;
expr3: expr3 ADD expr4|expr3 SUB expr4|expr4;
expr4: expr4 MUL expr5|expr4 DIV expr5|expr4 MOD expr5|expr5;
expr5: NEG expr5| SUB expr5| expr6;
expr6:liter |LP expr RP| lhs ;
liter: INT|FLOAT|STRING|BOOL|NIL;
array_element: array_element LS expr RS|ID;
struct_field: struct_field DOT ID|ID;


IF: 'if';
ELSE: 'else';
FOR: 'for';
RETURN: 'return';
FUNC: 'func';
Type: 'type';
STRUCT:'struct';
INTERFACE: 'interface';
CONST:'const';
VAR: 'var';
CONTINUE: 'continue';
BREAK: 'break';
RANGE: 'range';
TYPE: 'string' | 'int' | 'float' | 'boolean';
BOOL: 'true' | 'false';
NIL: 'nil';
ADD: '+' ;
SUB: '-' ;
MUL: '*' ;
DIV: '/';
MOD: '%';
COMP: '==' | '!=' | '<' | '<=' | '>' | '>=';
AND: '&&';
OR: '||';
NEG: '!';
ASSIG: ':='|'+='|'-='|'*='|'/='|'%=';
EQ: '=';
DOT:'.';
SM: ';';
CM: ',';
LP: '(';
RP: ')';
LB: '{';
RB: '}';
LS: '[';
RS: ']';

fragment DEC: '0'|[1-9] [0-9]*;
fragment BIN: ('0B'|'0b') '1' ('0'|'1')*;
fragment OCT: ('0o'|'0O') [1-7] [0-7]*;
fragment HEX: ('0X'|'0X') [1-9a-fA-F] [0-9a-fA-F]*;
INT:DEC|BIN|OCT|HEX;
FLOAT: [0-9]+ '.' [0-9]* (('e'|'E') ('+'|'-')? [0-9]+)?;
STRING: '"' (~["\\]|ESC)* '"';
fragment ESC: '\\' [tnr"\\];
NL: '\n' ; //skip newlines
WS : [ \f\t\r]+ -> skip ; // skip spaces, tabs 
CMT1: '//' ~[\r\n]* ->skip;
fragment CMT2: '/*'('*'* | '/'*)? ((CMT2|~[*/])+ ('*'* | '/'*)?)* '*/' ;
CMT3: CMT2 -> skip ; 
ID: [a-zA-Z_] [a-zA-Z_0-9]*;
ERROR_CHAR: . ;
ILLEGAL_ESCAPE:  '"' (~["\\]|ESC)* '\\' ~[tnr"\\] ;
UNCLOSE_STRING:'"'  (~["\r\n\\]|ESC)* ;