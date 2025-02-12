//Student id: 2313233
 
grammar MiniGo;

@lexer::header {
from lexererr import *
}

@lexer::members {
    self.pretk=""
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
                    self.pretk=tk
                    return super().emit()
            self.pretk=tk
            return self.nextToken()
        self.pretk=tk
        return super().emit();
       
}

options{
	language=Python3;
}

program  : many_decl EOF ;
many_decl: decl SM many_decl|decl|decl SM;
decl:constdecl | vardecl | structdecl | interdecl|methoddecl |funcdecl;

constdecl: CONST ID EQ expr;
vardecl: var_init|var_not_init;
var_init: VAR ID type_option init;
var_not_init: VAR ID type_var;
type_option:type_var|;
type_var: arraytype| TYPE|ID ;
arraytype: LS INT RS arraytype| TYPE| ID;
init: EQ expr;
structdecl: Type ID STRUCT structbody;
structbody:LB structcontent RB;
structcontent: struct_ele SM structcontent| struct_ele|;
struct_ele:ID type_var;
methoddecl: FUNC LP struct_ele RP funcname func_body;
interdecl: Type ID INTERFACE interfacebody;
interfacebody: LB inside_interface RB;
inside_interface: funcname SM inside_interface |funcname |;
funcdecl:FUNC funcname func_body;
funcname: ID LP list_param  RP type_option;
list_param: param tail_list_param|;
tail_list_param: CM param tail_list_param|;
param: list_id type_var;
list_id: list_id CM ID|ID;
func_body: LB list_stmt RB;
list_stmt: stmt SM list_stmt|stmt| ;
stmt:vardecl|constdecl|asign|if_stmt|for_stmt|break_stmt|contin_stmt|call_stmt|return_stmt;

asign:lhs assignop expr;
assignop:ASSIGNEQ|ASSIGNADD|ASSIGNSUB|ASSIGNMUL|ASSIGNDIV|ASSIGNMOD;
lhs:ID |array_element|struct_field;
if_stmt: IF LP expr RP block_stmt else_stmt ;
else_stmt:elseif else_stmt| else_tail;
elseif: ELSE IF LP expr RP block_stmt;
else_tail:ELSE block_stmt|;
for_stmt: for_basic|for_range|for_init;
for_basic:FOR expr block_stmt;
for_init: FOR initial SM expr SM asign block_stmt;
initial: asign|var_init;
for_range: FOR ID CM ID ASSIGNEQ RANGE ID block_stmt;
block_stmt: LB list_stmt RB;
break_stmt: BREAK;
contin_stmt: CONTINUE;
call_stmt:lhs LP list_expr RP;
return_stmt: RETURN expr|RETURN;

list_expr:expr tail_expr|;
tail_expr: CM expr tail_expr|;
expr: expr OR expr1|expr1;
expr1: expr1 AND expr2| expr2;
expr2: expr2 comp expr3|expr3;
comp: COMPEQ| COMPNE|COMPLT|COMPLE|COMPGT|COMPGE;
expr3: expr3 ADD expr4|expr3 SUB expr4|expr4;
expr4: expr4 MUL expr5|expr4 DIV expr5|expr4 MOD expr5|expr5;
expr5: NEG expr5| SUB expr5| expr6;
expr6:liter |LP expr RP| lhs |call_stmt;
liter: INT|FLOAT|STRING|BOOL|NIL|structlit|arrlit;
arrlit: arraytype LB arrbody RB;
arrbody: arrbody CM arr_member|arr_member;
arr_member:INT|FLOAT|STRING|BOOL|NIL|structlit|LB arrbody RB;
structlit: ID LB structlit_body RB;
structlit_body: structlit_ele structlit_tail |;
structlit_tail: CM structlit_ele structlit_tail|;
structlit_ele: ID colon expr ;
colon:':';
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
COMPEQ: '==' ;
COMPNE: '!=' ;
COMPLT: '<' ;
COMPLE: '<=' ;
COMPGT: '>' ;
COMPGE: '>=';
AND: '&&';
OR: '||';
NEG: '!';
ASSIGNEQ: ':=';
ASSIGNADD:'+=';
ASSIGNSUB:'-=';
ASSIGNMUL:'*=';
ASSIGNDIV:'/=';
ASSIGNMOD:'%=';

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
STRING: '"' (~["\\\r\n]|ESC)* '"';
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