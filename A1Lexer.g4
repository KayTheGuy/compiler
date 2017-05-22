// ==============================================================
// Author : Kayhan Dehghani Mohammadi
// ID : 301243781
// ==============================================================

lexer grammar A1Lexer;

// fragments
// ==============================================================
fragment DELIM 
	: ' ' | '\t' | '\n'
	;
fragment DIGIT 
	: [0-9] 
	;
fragment ALPHA 
	: [a-zA-Z] | '_' 
	;
fragment HEX_LETTERS 
	:  [a-fA-F]
	;
fragment HEX_SIGN 
	: '0x' 
	;

// Whitespace
// ==============================================================
WhITESPACE 
	: DELIM+ -> skip
	;

// Keywords
// ==============================================================
CLASS 
	: 'class' 
	;
PROGRAM 
	: 'Program' 
	;
VOID 
	: 'void' 
	;
INT 
	: 'int' 
	;
BOOL 
	: 'boolean' 
	;
IF 
	: 'if' 
	;
ELSE 
	: 'else' 
	;
FOR 
	: 'for' 
	;
RETURN 
	: 'return' 
	;
BREAK 
	: 'break' 
	;
CONTINUE 
	: 'continue' 
	;
CALLOUT 
	: 'callout' 
	;
TRUE 
	: 'true' 
	;
FALSE 
	: 'false' 
	;

// Assignments
// ==============================================================
ASSIGN 
	: '=' 
	;
PLUS_ASSIGN
	: '+=' 
	;
MINUS_ASSIGN 
	: '-=' 
	;

// General punctuations
// ==============================================================
LEFT_BRACE 
	: '{' 
	;
RIGHT_BRACE 
	: '}' 
	;
LEFT_BRACKET 
	: '['
	;
RIGHT_BRACKET
	: ']'
	;

LEFT_PARENT 
	: '('
	;
RIGHT_PARENT
	: ')'
	;

SEMICOLON
	: ';' 
	;
COMMA 
	: ',' 
	;

// Arithmetic and logic punctuations
// ==============================================================
MINUS 
	: '-' 
	;
PLUS 
	: '+' 
	;
MULTIPLY 
	: '*' 
	;
DIVISION 
	: '/' 
	;
REMAINDER 
	: '%' 
	;
BOOL_NEGATE 
	: '!' 
	;
LESS 
	: '<' 
	;
STRICT_LESS 
	: '<=' 
	;
LARGER 
	: '>' 
	;
STRICT_LARGER 
	: '>=' 
	;
EQUAL 
	: '==' 
	;
NOT_EQUAL 
	: '!=' 
	;
AND 
	: '&&' 
	;
OR 
	: '||' 
	;

// Identifiers and literals
// ==============================================================
ID 
	:  ALPHA (ALPHA | DIGIT)*
	;
INT_LITERAL 
	: DIGIT+ | HEX_SIGN (DIGIT | HEX_LETTERS)+
	;
STRING_LITERAL 
	: '"' (.)*? '"' 
	;
CHAR_LITERAL
	: '\'' . '\'' 
	;


