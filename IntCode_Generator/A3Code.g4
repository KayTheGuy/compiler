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
		for (int  i = size - 1; i >= 0; i --) {
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
	String instr;

	Quad (int l, int d, int s1, int s2, String o) {
		label = l;
		dst = d;
		src1 = s1;
		src2 = s2;
		op = o;
		instr = null;
	}

	Quad (int label, String instr) {
		this.label = label;
		this.instr = instr;
	}

	int UpdateInstruction(String instr) {
		this.instr = instr;
		return label;
	}

	void Print () {
		if (instr == null) {
			System.out.println("L_" + label + ": " + s.GetName(dst) + " = " 
					+ s.GetName(src1) + " " + op + " " + s.GetName(src2));
		}
		else{
			System.out.println("L_" + label + ": " + instr);
		}
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

	int AddInstr(String instr) {
		qt[size] = new Quad(size, instr);
		return (size ++);
	}

	Quad getQuad(int id) {
		return qt[id];
	}

	int getSize() {
		return size;
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
	DataType type = DataType.valueOf($Type.text.toUpperCase());
	int ident_id = s.insert($Ident.text, type, -1);
	q.Add(ident_id, $literal.id, -1, "");
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

block returns [int start_id, int end_id]
: '{' var_decls statements '}'
{
	$start_id = $statements.start_id;
	$end_id = $statements.end_id;
}
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

statements returns [int start_id, int end_id]
: m1=stmtMemory statement t=statements m2=stmtMemory
{	
	$start_id = $m1.id;
	$end_id = $m2.id;
}
|
;

stmtMemory returns [int id]
:
{
	$id = q.getSize();
}
;

statement 
: location eqOp expr ';'          
{	
	q.Add($location.id, $expr.id, -1, "");
}
| If '(' expr ')' ifMemory block
{
	String expr_name = s.GetName($expr.id);
	q.getQuad($ifMemory.id1).UpdateInstruction("if " + expr_name + " goto L_" + $block.start_id);
	q.getQuad($ifMemory.id2).UpdateInstruction("ifFalse " + expr_name + " goto L_" + $block.end_id);
}
| If '(' expr ')' ifMemory b1=block Else elseMemory b2=block
{
	String expr_name = s.GetName($expr.id);
	q.getQuad($ifMemory.id1).UpdateInstruction("if " + expr_name + " goto L_" + $b1.start_id);
	q.getQuad($ifMemory.id2).UpdateInstruction("ifFalse " + expr_name + " goto L_" + $b2.start_id);
	q.getQuad($elseMemory.id).UpdateInstruction("goto L_" + $b2.end_id);
}
| For Ident '=' e1=expr ',' e2=expr forMemory block 
{	
	int ident_id = s.Find($Ident.text);
	if (ident_id != -1) {
		String e2_tmp = s.GetName($forMemory.e2_tmp_id);
		q.getQuad($forMemory.id1).UpdateInstruction($Ident.text + " = " + s.GetName($e1.id));
		q.getQuad($forMemory.id2).UpdateInstruction(e2_tmp + " = " + $Ident.text + " < " + s.GetName($e2.id));
		q.getQuad($forMemory.id3).UpdateInstruction("if " + e2_tmp + " goto L_" + $block.start_id);
		int size_id = s.insert("1", DataType.INT, -1);
		q.Add(ident_id, ident_id, size_id, "+");
		int end_of_for_id = q.AddInstr("goto L_" + $forMemory.id2);
		q.getQuad($forMemory.id4).UpdateInstruction("ifFalse " + e2_tmp + " goto L_" + (end_of_for_id + 1));
	}
}
| Ret ';'
{
	q.AddInstr("ret");
}
| Ret '(' expr ')' ';'
{
	q.AddInstr("ret " + s.GetName($expr.id));
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

ifMemory returns [int id1, int id2]
:
{
	$id1 = q.AddInstr("ifMemory");
	$id2 = q.AddInstr("ifMemory");
}
;

elseMemory returns [int id]
:
{
	$id = q.AddInstr("elseMemory");
}
;

forMemory returns [int id1, int id2, int id3, int id4, int e2_tmp_id]
:
{
	$id1 = q.AddInstr("forMemory");
	$id2 = q.AddInstr("forMemory");
	$id3 = q.AddInstr("forMemory");
	$id4 = q.AddInstr("forMemory");
	$e2_tmp_id = s.Add(DataType.INT);
}
;

methodCall returns [int id]
: Ident '(' args ')'
{
	$id = s.Add(s.GetType(s.Find($Ident.text)));
	q.AddInstr(s.GetName($id) + " = "+ $Ident.text + " call " + $args.numberOfArg);
}
| Callout '(' Str calloutArgs ')'
{
	q.AddInstr($Str.text + " call " + $calloutArgs.numberOfArg);
}
;

args returns [int numberOfArg]
: someArgs
{
	$numberOfArg = $someArgs.numberOfArg;
}
|
{
	$numberOfArg = 0;
}
;

someArgs returns [int numberOfArg]
: t=someArgs ',' expr
{
	$numberOfArg = $t.numberOfArg + 1;
}
| expr
{
	$numberOfArg = 1;
}
;

calloutArgs returns [int numberOfArg]
: c=calloutArgs ',' expr
{
	q.AddInstr(s.GetName($expr.id) + " param");
	$numberOfArg = $c.numberOfArg + 1;
}
| c=calloutArgs ',' Str
{
	q.AddInstr($Str.text + " param");
	$numberOfArg = $c.numberOfArg + 1;
}
|
{
	$numberOfArg = 0;
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
	$id = s.Add(s.GetType($expr.id));
	int size_id = s.insert("0", DataType.INT, -1);
	q.Add($id , size_id , $e.id, "-");
}
| '!' e=expr
{
	$id = $e.id;
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
	$id = $methodCall.id;
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
