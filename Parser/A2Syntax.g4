grammar A2Syntax;

//---------------------------------------------------------------------------------------------------
// Session 1: ANTLR tree plotting API, You SHOULD NOT make any modification to this session
//---------------------------------------------------------------------------------------------------
@header {

import java.io.*;
}

@parser::members {
        //AST node count
	int count = 0;
	String graph = "";

	int GetId() {
		return count++;
	}
	
	public class MySet {
		int[] ids;
		int size;

		MySet () {
			System.out.println("\n\nInitArray\n-------------");
			ids = new int [100];		
			size = 0;
		}

		void ExtendArray(int val) {
			System.out.println("\n\nExtendArray\n-------------\nsize = " + size + "\nval = " + val);

			ids[size] = val;
			size ++;
		}
		void AppendArray(MySet s) {
			for (int i = 0; i < s.size; i ++) {
				ExtendArray(s.ids[i]);
			}
		}

	}//MySet

	String ProcessString(String s) {
		String x = "\\" + s.substring(0, s.length() - 1) + "\\\"";
		return x;
	}

	int PrintNode (String label) {
		System.out.println("\n\nPrintNode\n-------------\nlabel = " + label + "\nid = " + count);

		int id = GetId();
		graph += (id + " [label=\"" + label + "\"]\n");
		return id;
	}

	void PrintEdge (int id1, int id2) {
		System.out.println("\n\nPrintEdge\n-------------\nid1 = " + id1 + "\nid2 = " + id2);
		
		if ((id1 != -1) && (id2 != -1)) graph += (id1 + " -> " + id2 + "\n");
	}

	void PrintEdges (int id, MySet s) {
		System.out.println("\n\nPrintEdges\n-------------\nid = " + id + "\nsize = " + s.size);
		
		for (int i = 0; i < s.size; i ++) {
			PrintEdge(id, s.ids[i]);
		}
	}

	void PrintGraph () throws IOException {
		System.out.println("\n\nPrintGraph\n-------------");

		File file = new File("test.dot");
		file.createNewFile();
		FileWriter writer = new FileWriter(file); 
		writer.write("digraph G {\nordering=out\n" + graph + "\n}\n"); 
		writer.flush();
		writer.close();

		System.out.println("digraph G {\nordering=out\n" + graph + "\n}\n");
	}
}

//---------------------------------------------------------------------------------------------------
// Session 2: Fill the Grammer definition here
//---------------------------------------------------------------------------------------------------
prog
: Class Program '{' field_decls method_decls '}'
{
	
	int id = PrintNode("Program");

	if ($field_decls.s.size > 0) {
		int id2 = PrintNode("Field_decls");
		PrintEdges(id2, $field_decls.s);
		PrintEdge(id, id2);
	}

	if ($method_decls.s.size > 0) {
		int id2 = PrintNode("Method_decls");
		PrintEdges(id2, $method_decls.s);
		PrintEdge(id, id2);
	}

	try {PrintGraph();} catch(IOException e) {}
}
;

field_decls returns [MySet s]
: f=field_decls field_decl ';'
{
	$s = $f.s;
	$s.ExtendArray($field_decl.id);
}
| f=field_decls inited_field_decl ';'
{
	$s = $f.s;
	$s.ExtendArray($inited_field_decl.id);
}
| 
{
	$s = new MySet();
}
;

// <field_decl> -> <type> (<id> | <id> [ <int_literal> ] ) ( , <id> | <id>[ <int_literal> ] )* ;
field_decl returns [int id]
: f=field_decl ',' Ident
{
	$id = $f.id;

	PrintEdge($f.id, PrintNode($Ident.text));
}
| f=field_decl ',' Ident '[' num ']'
{
	$id = $f.id;

	PrintEdge($f.id, PrintNode($Ident.text));
	PrintEdge($f.id, PrintNode($num.text));
}
| Type Ident
{
	$id = PrintNode("Field_decl");

	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
}
| Type Ident '[' num ']'
{
	$id = PrintNode("Field_decl");

	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, PrintNode($num.text));
}
;

inited_field_decl returns [int id]
: Type Ident '=' literal 
{
	$id = PrintNode("Inited_field_decl");

	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, PrintNode($literal.text));
}
;

method_decls returns [MySet s]
: m=method_decls method_decl
{
	$s = $m.s;
	$s.ExtendArray($method_decl.id);
}
|
{
	$s = new MySet();
}
;

// <method_decl> -> ( <type> | void ) <id> ( ((<type> <id>) ( , <type> <id>)*)? ) 
method_decl returns [int id]
: Type Ident '(' params ')' block
{
	$id = PrintNode("Method_decl");

	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $params.id);
	PrintEdge($id, $block.id);	
}
| Void Ident '(' params ')' block
{
	$id = PrintNode("Method_decl");

	PrintEdge($id, PrintNode("void"));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $params.id);
	PrintEdge($id, $block.id);
}
;

params returns [int id]
: Type Ident nextParams
{
	$id = PrintNode("Method_args");
	
	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdges($id, $nextParams.s);
}
|
{
	$id = -1;
}
;

nextParams returns [MySet s]
: n=nextParams ',' Type Ident
{
	$s = $n.s;
	
	$s.ExtendArray(PrintNode($Type.text));
	$s.ExtendArray(PrintNode($Ident.text));
}
|
{
	$s = new MySet();
}
;

// <block> -> { <var_decl>* <statement>* }
block returns [int id]
: '{' var_decls statements '}'
{
	$id = -1;
	if ($var_decls.s.size > 0) {
		$id = PrintNode("Block");
		int id2 = PrintNode("Var_decls");
		PrintEdges(id2, $var_decls.s);
		PrintEdge($id, id2);
	}
	if ($statements.id != -1) {
		if ($id == -1) $id = PrintNode("Block");
		PrintEdge($id, $statements.id);
	}
}
;

var_decls returns [MySet s]
: v=var_decls var_decl ';'
{
	$s = $v.s;
	$s.ExtendArray($var_decl.id);
}
| 
{
	$s = new MySet();
}
;

var_decl returns [int id]
: v=var_decl ',' Ident
{
	$id = $v.id;
	
	PrintEdge($id, PrintNode($Ident.text));
}
| Type Ident
{
	$id = PrintNode("Var_decl");
	
	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
}
;

statements returns [int id]
: statement t=statements
{
	if ($t.id != -1) {
		$id = PrintNode("Seq");
		PrintEdge($id, $statement.id);
		PrintEdge($id, $t.id);
	} else {
		$id = $statement.id;
	}
}
|
{
	$id = -1;
}
;

// <statement> -> if ( <expr> ) <block> ( else <block> )?
// <statement> -> for <id> = <expr> , <expr> <block>
// <statement> -> <location> <assign_op> <expr> ;
// <statement> -> <method_call> ;
// <statement> -> <block>
// <statement> -> return ( <expr> )? ;
// <statement> -> break ;
// <statement> -> continue ;
statement returns [int id]
: If '(' expr ')' b=block 
{
	$id = PrintNode("If");
	PrintEdge($id, $expr.id);
	PrintEdge($id, $b.id);
}
| If '(' expr ')' b1=block Else b2=block
{
	$id = PrintNode("If_Else");
	PrintEdge($id, $expr.id);
	PrintEdge($id, $b1.id);
	PrintEdge($id, $b2.id);
}
| For Ident '=' e1=expr ',' e2=expr block
{
	$id = PrintNode("For");
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $e1.id);
	PrintEdge($id, $e2.id);
	PrintEdge($id, $block.id);
}
| location eqOp expr ';'
{
	$id = PrintNode("Assign");
	PrintEdge($id, $location.id);
	PrintEdge($id, PrintNode($eqOp.text));
	PrintEdge($id, $expr.id);
}
| block
{
	$id = $block.id;
}
| Ret expr ';'
{
	$id = PrintNode("Ret");
	PrintEdge($id, $expr.id);
}
| Ret ';'
{
	$id = PrintNode("Ret");
}
| Brk ';'
{
	$id = PrintNode("Break");
}
| Cnt ';'
{
	$id = PrintNode("Cont");
}
;

// <expr> -> <expr> <bin_op> <expr>
// <expr> -> <location>
// <expr> -> <literal>
// <expr> -> - <expr>
// <expr> -> ( <expr> )
// <expr> -> <method_call>
expr returns [int id]
: literal
{
	$id = PrintNode("Const_expr");
	PrintEdge($id, PrintNode($literal.text));
}
| e1=expr binOp e2=expr
{
	$id = PrintNode("Bin_expr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode($binOp.text));
	PrintEdge($id, $e2.id);
}
| location
{
	$id = PrintNode("Loc_expr");
	PrintEdge($id, $location.id);
}
| '-' e=expr
{
	$id = PrintNode("Neg_expr");
	PrintEdge($id, $e.id);
}
| '!' e=expr 
{
	$id = PrintNode("Not_expr");
	PrintEdge($id, $e.id);
}
| '(' e=expr ')'
{
	$id = $e.id;
}
| m=method_call
{
	$id = $m.id;
}
;

// <method_call> -> <method_name> ( (<expr> ( , <expr> )*)? )
// <method_call> -> callout ( <string_literal> ( , <callout_arg> )* )
method_call returns [int id]
:  Ident '(' arg_exprs ')'
{
	$id = PrintNode("Call_expr");
	PrintEdge($id, PrintNode($Ident.text));
	if ($arg_exprs.s.size > 0) {
		PrintEdges($id, $arg_exprs.s);
	}
}
;

arg_exprs returns [MySet s]
: a=arg_exprs nextArg_expr
{
	$s = $a.s;
	$s.ExtendArray($nextArg_expr.id);
}
| expr
{
	$s = new MySet();
	int id = PrintNode("Expr_arg");
	PrintEdge(id, $expr.id);
	$s.ExtendArray(id);
}
| 
{
	$s = new MySet();
}
;

nextArg_expr returns [int id]
: ',' expr
{
	$id = PrintNode("Expr_arg");
	PrintEdge($id, $expr.id);
}
;

// <location> -> <id>
// <location> -> <id> [ <expr> ]
location returns [int id]
:Ident
{
	$id = PrintNode("Loc");
	PrintEdge($id, PrintNode($Ident.text));
}
| Ident '[' expr ']'
{
	$id = PrintNode("Array_loc");
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $expr.id);
}
;

//--------------------------------------------- END OF SESSION 2 -----------------------------------


//---------------------------------------------------------------------------------------------------
// Session 3: Lexical definition, You SHOULD NOT make any modification to this session
//---------------------------------------------------------------------------------------------------
num
: DecNum
| HexNum
;

literal
: num
| Char
| BoolLit
;

eqOp
: '='
| AssignOp
;

mathOp
: '-'
| ArithOp
;

boolOp
: '!'
| CondOp
;

binOp
: mathOp
| RelOp
| CondOp
;

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

ArithOp
: '+'
| '*'
| '/'
| '%'
;

CondOp
: '&&'
| '||'
;