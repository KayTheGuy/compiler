grammar A3Code;

//---------------------------------------------------------------------------------------------------
// ANTLR API:
//---------------------------------------------------------------------------------------------------
@header {

import java.io.*;
}

@parser::members {

public enum DataType {
	INT, BOOLEAN, VOID, CHAR, INVALID
}

public class Symbol {
	String name;
	DataType dt;
	int length; 

	Symbol (String n, DataType d, int l) {
		name = n;
		dt = d;
		length = l;
	}

	Symbol (int id, DataType d, int l) {
		name = "t_" + id;
		dt = d;
		length = l;
	}

	boolean Equal (String n) {
		return (name.equals(n));
	}

	DataType GetType () {
		return dt;
	}

	String GetName () {
		return name;
	}

	int GetLength () {
		return length;
	}

	void Print() {
		System.out.println(name + "\t" + dt + "\t" + length);
	}
}

public class SymTab {
	Symbol st[];
	int size;
	int temps;

	SymTab () {
		st = new Symbol[1000];
		size = 0;
		temps = 0;
	}

	int Find (String n) {
		for (int  i = 0; i < size; i ++) {
			if (st[i].Equal(n)) return i;
		}
		return -1;
	}

	int insert(String n, DataType d, int l) {
		int id = Find(n);
		if (id != -1) return id;
	
		st[size] = new Symbol(n, d, l);
		return (size ++);
	}

	int Add (DataType d) {
		st[size] = new Symbol (temps, d, -1);
		temps ++;
		return (size ++);
	}

	DataType GetType (int id) {
		if (id == -1) return DataType.INVALID;
		return (st[id].GetType());
	}

	String GetName (int id) {
		if (id == -1) return ("");
		return (st[id].GetName()); 
	}

	int GetLength (int id) {
		if (id == -1) return 0;
		return (st[id].GetLength()); 
	}

	void Print() {
		for (int  i = 0; i < size; i ++) {
			st[i].Print();
		}
	}
}

SymTab s = new SymTab();

public class Quad {
	int label;
	String op;
	int src1;
	int src2;
	int dst;

	Quad (int l, int d, int s1, int s2, String o) {
		label = l;
		dst = d;
		src1 = s1;
		src2 = s2;
		op = o;
	}

	void Print () {
		System.out.println("L_" + label + ": " + s.GetName(dst) + " = " 
				+ s.GetName(src1) + " " + op + " " + s.GetName(src2));
	}
}

public class QuadTab {
	Quad qt[];
	int size;

	QuadTab () {
		qt = new Quad[1000];
		size = 0;
	}

	int Add(int dst, int src1, int src2, String op) {
		qt[size] = new Quad(size, dst, src1, src2, op);
		return (size ++);
	}

	void Print() {
		for (int  i = 0; i < size; i ++) {
			qt[i].Print();
		}
	}
}

QuadTab q = new QuadTab();

}

//---------------------------------------------------------------------------------------------------
// Grammar Rules 
//---------------------------------------------------------------------------------------------------
prog
: Class Program '{' field_decls method_decls '}'
{
	s.Print();
	System.out.println("------------------------------------");
	q.Print();
}
;

field_decls 
: f=field_decls field_decl ';'
| f=field_decls inited_field_decl ';'
| 
;

field_decl returns [DataType t]
: f=field_decl ',' Ident
{
	$t = $f.t;
	s.insert($Ident.text, $t, -1);
}
| f=field_decl ',' Ident '[' num ']'
{
	$t = $f.t;
	s.insert($Ident.text, $t, Integer.parseInt($num.text));
}
| Type Ident
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	s.insert($Ident.text, $t, -1);
}
| Type Ident '[' num ']'
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	s.insert($Ident.text, $t, Integer.parseInt($num.text));
}
;

inited_field_decl returns [int id]
: Type Ident '=' literal 
{
	// TODO: add action
}
;

method_decls 
: m=method_decls method_decl
|
;

method_decl
: Type Ident '(' params ')' block
{
	s.insert($Ident.text, DataType.valueOf($Type.text.toUpperCase()), -1);
}
| Void Ident '(' params ')' block
{
	// TODO: add action
}
;

params returns [int id]
: Type Ident nextParams
{
	s.insert($Ident.text, DataType.valueOf($Type.text.toUpperCase()), -1);
}
|
;

nextParams
: n=nextParams ',' Type Ident
{
	s.insert($Ident.text, DataType.valueOf($Type.text.toUpperCase()), -1);
}
|
;

block
: '{' var_decls statements '}'
;

var_decls
: v=var_decls var_decl ';'
| 
;

var_decl returns [DataType t]
: v=var_decl ',' Ident
{
	$t = $v.t;
	s.insert($Ident.text, $t, -1);
}
| Type Ident
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	s.insert($Ident.text, $t, -1);
}
;

statements
: statement t=statements
|
;

statement
: location eqOp expr ';'          
{
	q.Add($location.id, $expr.id, -1, "");
}
| If '(' expr ')' block
{
	// TODO: action
}
| If '(' expr ')' b1=block Else b2=block
{
	// TODO: action
}
| For Ident '=' e1=expr ',' e2=expr block
{
	// TODO: action
}
| Ret ';'
{
	// TODO: action
}
| Ret '(' expr ')' ';'
{
	// TODO: action
}
| Brk ';'
{
	// TODO: action
}
| Cnt ';'
{
	// TODO: action
}
| block
{
	// TODO: action
}
| methodCall ';'
{
	// TODO: action
}
;

methodCall returns [int id]
: Ident '(' args ')'
{
	// TODO: action
}
| Callout '(' Str calloutArgs ')'
{
	// TODO: action
}
;

args 
: someArgs
{
	// TODO: action
}
|
{
	// TODO: action
}
;

someArgs
: t=someArgs ',' expr
{
	// TODO: action
}
| expr
{
	// TODO: action
}
;

calloutArgs 
: c=calloutArgs ',' expr
{
	// TODO: action
}
| c=calloutArgs ',' Str
{
	// TODO: action
}
|
{
	// TODO: action
}
;

expr returns [int id]
: literal
{
	$id = $literal.id;
}
| location
{
	$id = $location.id;
}
| '(' e=expr ')'
{
	$id = $e.id;
}
| SubOp e=expr
{
	// TODO: raise error if type boolean
}
| '!' e=expr
{
	// TODO: raise error if type not boolean
}
| e1=expr MulDiv e2=expr
{
	$id = s.Add(s.GetType($e1.id));
	q.Add($id, $e1.id, $e2.id, $MulDiv.text);
}
| e1=expr AddOp e2=expr
{
	$id = s.Add(s.GetType($e1.id));
	q.Add($id, $e1.id, $e2.id, $AddOp.text);
}
| e1=expr SubOp e2=expr
{
	$id = s.Add(s.GetType($e1.id));
	q.Add($id, $e1.id, $e2.id, $SubOp.text);
}
| e1=expr RelOp e2=expr
{
	$id = s.Add(s.GetType($e1.id));
	q.Add($id, $e1.id, $e2.id, $RelOp.text);
}
| e1=expr AndOp e2=expr
{
	$id = s.Add(s.GetType($e1.id));
	q.Add($id, $e1.id, $e2.id, $AndOp.text);
}
| e1=expr OrOp e2=expr
{
	$id = s.Add(s.GetType($e1.id));
	q.Add($id, $e1.id, $e2.id, $OrOp.text);
}
| methodCall
{
	// TODO: add action
}
;

location returns [int id]
:Ident
{
	$id = s.Find($Ident.text);
}
| Ident '[' expr ']'
{	
	int ident_id = s.Find($Ident.text);
	int temp_id = s.Add(s.GetType(ident_id));
	int size_id = s.insert("4", DataType.INT, -1);
	q.Add(temp_id, size_id, $expr.id, "*");
	$id = s.insert($Ident.text + "[ " + s.GetName(temp_id) +" ]", 
					s.GetType(temp_id), s.GetLength(temp_id));
}
;

num
: DecNum
| HexNum
;

literal returns [int id]
: num
{
	$id = s.insert($num.text, DataType.INT, -1);
}
| Char
{
	$id = s.insert($Char.text, DataType.CHAR, -1);
}
| BoolLit
{
	$id = s.insert($BoolLit.text, DataType.BOOLEAN, -1);
}
;

eqOp
: '='
| AssignOp
;

//---------------------------------------------------------------------------------------------------
// Lexical Rules
//---------------------------------------------------------------------------------------------------
fragment Delim
: ' '
| '\t'
| '\n'
;

fragment Letter
: [a-zA-Z]
;

fragment Digit
: [0-9]
;

fragment HexDigit
: Digit
| [a-f]
| [A-F]
;

fragment Alpha
: Letter
| '_'
;

fragment AlphaNum
: Alpha
| Digit
;

WhiteSpace
: Delim+ -> skip
;

Char
: '\'' ~('\\') '\''
| '\'\\' . '\'' 
;

Str
:'"' ((~('\\' | '"')) | ('\\'.))* '"'
; 

Class
: 'class'
;

Program
: 'Program'
;

Void
: 'void'
;

If
: 'if'
;

Else
: 'else'
;

For
: 'for'
;

Ret
: 'return'
;

Brk
: 'break'
;

Cnt
: 'continue'
;

Callout
: 'callout'
;

DecNum
: Digit+
;

HexNum
: '0x'HexDigit+
;

BoolLit
: 'true'
| 'false'
;

Type
: 'int'
| 'boolean'
;

Ident
: Alpha AlphaNum* 
;

RelOp
: '<='
| '>=' 
| '<'
| '>'
| '=='
| '!='
;

AssignOp
: '+='
| '-='
;

MulDiv
: '*'
| '/'
| '%'
;

AddOp
: '+'
;

SubOp
: '-'
;

AndOp
: '&&'
;

OrOp
: '||'
;
//--------------------------------------------- END ----------------------------------------------
