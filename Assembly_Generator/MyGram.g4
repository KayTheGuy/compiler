grammar MyGram;

@header {
import java.io.*;
}

@parser::members {
	public enum DataType {
			INT, BOOLEAN, LABEL, VOID, STR, INVALID
	}	

	public class Symbol {
		String name;
		DataType dt;
		int arrSize;

		Symbol (String n, DataType d) {
			name = n;
			dt = d;
			arrSize = 0;
		}

		Symbol (String n, DataType d, int arrSz) {
			name = n;
			dt = d;
			arrSize = arrSz;
		}

		Symbol (int id, DataType d) {
			if (d == DataType.LABEL) name = "L_" + id;
			else name = "t_" + id;
			dt = d;
			arrSize = 0;
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

		void Print() {
			System.out.println(name + "\t" + dt + "\t" + arrSize);
		}
	}

	public class SymTab {
		Symbol st[];
		int size;

		SymTab () {
			st = new Symbol[1000];
			size = 0;
		}

		Symbol Find (String n) {
			for (int  i = 0; i < size; i ++) {
				if (st[i].Equal(n)) return st[i];
			}
			return null;
		}

		Symbol insert(String n, DataType d) {
			Symbol id = Find(n);
			if (id != null) return id;
			return(Add(n, d));
		}

		Symbol Add (String n, DataType d) {
			st[size] = new Symbol(n, d);
			return(st[size ++]);
		}

		Symbol Add (String n, DataType d, int arrSz) {
			st[size] = new Symbol(n, d, arrSz);
			return(st[size ++]);
		}

		Symbol Add (int id, DataType d) {
			st [size] = new Symbol (id, d);
			return (st[size ++]);
		}

		DataType GetType (int id) {
			if (id == -1) return DataType.INVALID;
			return (st[id].GetType());
		}

		String GetName (int id) {
			if (id == -1) return ("");
			return (st[id].GetName()); 
		}

		void Print() {
			for (int  i = 0; i < size; i ++) {
				st[i].Print();
			}
		}
	}

	public class SymStack {
		SymTab ss[];
		int size;
		int[] next;
		int[] prev;
		int tos; //top of stack
		int temps;
	
		SymStack () {
			ss = new SymTab [1000];
			next = new int [1000];
			prev = new int [1000];
			ss[0] = new SymTab (); //global symbol table
			size = 1;
			next[0] = -1;
			prev[0] = -1;
			tos = 0;
			temps = 0;
		}

		void PushSymTab () {
			ss[size] = new SymTab ();
			next[size] = -1;
			prev[size] = tos;
			next[tos] = size;
			tos = size;
			size ++;
		}

		void PopSymTab () {
			tos = prev[tos];
			next[tos] = -1;
		}

		Symbol Find (String n) {
			int id = tos;
			while (id != -1) {
				Symbol s = ss[id].Find(n);
				if (s != null) return s;
				id = prev[id];
			}
			return null;
		}

		Symbol insert(String n, DataType d) {
			Symbol id = Find(n);
			if (id != null) return id;
			return (Add(n,d));
		}

		Symbol Add (String n, DataType d) { //user-defined var or constant
			return(ss[tos].Add(n, d));
		}

		Symbol Add (String n, DataType d, int sz) { //user-defined array var
			return(ss[tos].Add(n, d, sz));
		}

		Symbol Add (int n) { //label
			Symbol id = Find("L_" + n);
			if (id != null) return id;
			return(ss[0].Add(n, DataType.LABEL));
		}

		Symbol Add (DataType d) { //temporary
			return(ss[tos].Add(temps++, d));
		}

		void Print () {
			for (int i = 0; i < size; i++) {
				System.out.println("-------------------------------------");
				ss[i].Print();
				System.out.println("-------------------------------------");
			}
		}
	}

	SymStack s = new SymStack();

	public class Quad {
		Symbol label;
		String op;
		Symbol src1;
		Symbol src2;
		Symbol dst;

		Quad (int l, Symbol d, Symbol s1, Symbol s2, String o) {
			label = s.Add(l);
			dst = d;
			src1 = s1;
			src2 = s2;
			op = o;
		}

		Quad (Symbol l) {
			label = l;
			dst = null;
			src1 = null;
			src2 = null;
			op = "";
		}

		void BackPatch (Symbol l) {
			dst = l;
		}

		Symbol GetLabel () {
			return label;
		}

		void Print () {
			System.out.print(label.GetName() + ": ");
			if (dst != null) System.out.print(dst.GetName());
			if (src1 != null) System.out.print(" = " + src1.GetName());
			System.out.print(" " + op + " ");
			if (src2 != null) System.out.print(src2.GetName());
			System.out.println("");
		}
	}

	public class QuadTab {
		Quad qt[];
		int size;

		QuadTab () {
			qt = new Quad[1000];
			size = 0;
		}

		int Add(Symbol dst, Symbol src1, Symbol src2, String op) {
			qt[size] = new Quad(size, dst, src1, src2, op);
			return (size ++);
		}

		int Add(Symbol label) { 
			qt[size] = new Quad (label);
			return (size ++);
		}

		int GetNextLabel () {
			return size;
		}

		void BackPatch (int id, Symbol label) {
			qt[id].BackPatch(label);
		}

		void Print() {
			for (int  i = 0; i < size; i ++) {
				qt[i].Print();
			}
		}
	}

	QuadTab q = new QuadTab();

	public class LocList {
		int[] locs;
		int size;

		LocList () {
			locs = new int [1000];
			size = 0;
		}

		void Add (int l) {
			locs[size] = l;
			size ++;
		}

		void BackPatch (Symbol label) {
			for (int i = 0; i < size; i ++) {
				q.BackPatch(locs[i], label);
			}
		}

		void Merge (LocList ll) {
			for (int i = 0; i < ll.size; i++) {
				locs[size] = ll.locs[i];
				size ++;
			}
		}

		boolean IsEmpty () {
			return (size == 0);
		}

		void Print () {
			for (int i = 0; i < size; i ++) {
				System.out.print(locs[i] + " ");
			}
			System.out.println("");
		}
	}
}

//---------------------------------------------------------------------------------------------------
prog
: Class Program '{' field_decls method_decls '}'
{
	//s.Print();
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
	Symbol sym = s.Add($Ident.text, $t);
}
| f=field_decl ',' Ident '[' num ']'
{
	$t = $f.t;
	Symbol sym = s.Add($Ident.text, $t, Integer.parseInt($num.text));
}
| Type Ident
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	Symbol sym = s.Add($Ident.text, $t);
}
| Type Ident '[' num ']'
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	Symbol sym = s.Add($Ident.text, $t, Integer.parseInt($num.text));
}
;

inited_field_decl 
: Type Ident '=' literal 
{
	DataType t = DataType.valueOf($Type.text.toUpperCase());
	Symbol src1 = s.insert($literal.text, t);
	Symbol dst = s.Add($Ident.text, t);
	q.Add(dst, src1, null, "=");
}
;

method_decls 
: m=method_decls method_decl
|
;

method_decl 
: Type Ident 
{
	DataType t = DataType.valueOf($Type.text.toUpperCase());
	Symbol sym = s.Add($Ident.text, t);
	s.PushSymTab();
	q.Add(sym);
}
'(' params ')' block marker
{
	s.PopSymTab();
}
| Void Ident 
{
	DataType t = DataType.VOID;
	Symbol sym = s.Add($Ident.text, t);
	s.PushSymTab();
	q.Add(sym);
}
'(' params ')' block marker
{
	if (!$block.nextlist.IsEmpty()) {
		q.Add(null, null, null, "ret");
		$block.nextlist.BackPatch ($marker.label);
	}
	s.PopSymTab();
}
;

params 
: Type Ident nextParams
{
	DataType t = DataType.valueOf($Type.text.toUpperCase());
	Symbol sym = s.Add($Ident.text, t);
}
|
;

nextParams
: n=nextParams ',' Type Ident
{
	DataType t = DataType.valueOf($Type.text.toUpperCase());
	Symbol sym = s.Add($Ident.text, t);
}
|
;

block returns [LocList nextlist, LocList brklist, LocList cntlist]
: '{' var_decls statements '}'
{	
	$nextlist = $statements.nextlist;
	$brklist = $statements.brklist;
	$cntlist = $statements.cntlist;
}
;

var_decls 
: v=var_decls var_decl ';'
{
}
| 
;

var_decl returns [DataType t]
: v=var_decl ',' Ident
{
	$t = $v.t;
	Symbol sym = s.Add($Ident.text, $t);
}
| Type Ident
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	Symbol sym = s.Add($Ident.text, $t);
}
;

statements returns [LocList nextlist, LocList brklist, LocList cntlist]
: t=statements marker statement
{
	$t.nextlist.BackPatch($marker.label);
	$nextlist = $statement.nextlist;
	$brklist = $t.brklist;
	$brklist.Merge ($statement.brklist);
	$cntlist = $t.cntlist;
	$cntlist.Merge ($statement.cntlist);	
}
|
{
	$nextlist = new LocList ();
	$brklist = new LocList ();
	$cntlist = new LocList ();
}
;

statement returns [LocList nextlist, LocList brklist, LocList cntlist]
: location eqOp expr ';'
{
	if ($eqOp.text.equals("+=")) {
		Symbol sym1 = s.Add($location.base.GetType());
		q.Add(sym1, $location.base, $location.offset, "[]");
		Symbol sym2 = s.Add($location.base.GetType());
		q.Add(sym2, sym1, $expr.sym, "+");
		if ($location.offset != null) {
			q.Add($location.base, $location.offset, sym2, "[]");
		} else {
			q.Add($location.base, sym2, null, "=");
		}
	} else if ($eqOp.text.equals("-=")) {
		Symbol sym1 = s.Add($location.base.GetType());
		q.Add(sym1, $location.base, $location.offset, "[]");
		Symbol sym2 = s.Add($location.base.GetType());
		q.Add(sym2, sym1, $expr.sym, "-");
		if ($location.offset != null) {
			q.Add($location.base, $location.offset, sym2, "[]");
		} else {
			q.Add($location.base, sym2, null, "=");
		}	
	} else {
		if ($location.offset != null) {
			q.Add($location.base, $location.offset, $expr.sym, "[]");
		} else {
			q.Add($location.base, $expr.sym, null, "=");
		}
	}
	$nextlist = new LocList();
	$brklist = new LocList ();
	$cntlist = new LocList ();
}
| If '(' expr ')' marker block
{
	$expr.truelist.BackPatch($marker.label);
	$nextlist = $expr.falselist;
	$nextlist.Merge($block.nextlist);
	$brklist = $block.brklist;
	$cntlist = $block.cntlist;
}
| If '(' expr ')' m1=marker b1=block next Else m2=marker b2=block
{
	$expr.truelist.BackPatch($m1.label);
	$expr.falselist.BackPatch($m2.label);
	$nextlist = $b1.nextlist;
	$nextlist.Merge($b2.nextlist);
	$nextlist.Merge($next.nextlist);
	$brklist = $b1.brklist;
	$brklist.Merge ($b2.brklist);
	$cntlist = $b1.cntlist;
	$cntlist.Merge ($b2.brklist);
}
| For Ident '=' e1=expr ',' 
{
	q.Add(s.Find($Ident.text), $e1.sym, null, "=");
}
marker e2=expr 
{
	Symbol sym = s.Add(DataType.INT);
	q.Add(sym, s.Find($Ident.text), $e2.sym, "<");
	$nextlist = new LocList ();
	$nextlist.Add(q.Add(null, sym, null, "ifFalse"));
}
block next
{
	$block.nextlist.BackPatch($marker.label);
	$next.nextlist.BackPatch ($marker.label);	
	$nextlist.Merge ($block.brklist);
	$block.cntlist.BackPatch ($marker.label);
	$brklist = new LocList ();
	$cntlist = new LocList ();
}
| Brk ';'
{
	$nextlist = new LocList ();
	$brklist = new LocList ();
	$brklist.Add (q.Add (null, null, null, "goto"));
	$cntlist = new LocList ();
}
| Cnt ';'
{
	$nextlist = new LocList ();
	$cntlist = new LocList ();
	$cntlist.Add (q.Add (null, null, null, "goto"));
	$brklist = new LocList ();
}
| block
{
	$nextlist = $block.nextlist;
	$brklist = $block.brklist;
	$cntlist = $block.cntlist;
}
| Ret ';'
{
	q.Add (null, null, null, "ret");
	$nextlist = new LocList ();	
	$brklist = new LocList ();	
	$cntlist = new LocList ();	
}
| Ret '(' expr ')' ';'
{
	q.Add (null, $expr.sym, null, "ret");
	$nextlist = new LocList ();	
	$brklist = new LocList ();	
	$cntlist = new LocList ();
}
| methodCall ';'
{
	$nextlist = new LocList ();	
	$brklist = new LocList ();	
	$cntlist = new LocList ();
}
;

expr returns [Symbol sym, LocList truelist, LocList falselist]
: literal
{
	$sym = $literal.sym;
}
| location
{
	if ($location.offset != null) {
		$sym = s.Add($location.base.GetType());
		q.Add($sym, $location.base, $location.offset, "[]");
	} else {
		$sym = $location.base;
	}
}
| '(' e=expr ')'
{
	$sym = $e.sym;
	$truelist = $e.truelist;
	$falselist = $e.falselist;
}
| AddSub e=expr
{
	$sym = s.Add(DataType.INT);
	q.Add($sym, s.insert("0", DataType.INT), $e.sym, $AddSub.text); 
}
| e1=expr MulDiv e2=expr
{
	$sym = s.Add(DataType.INT);
	q.Add($sym, $e1.sym, $e2.sym, $MulDiv.text);
}
| e1=expr AddSub e2=expr
{
	$sym = s.Add(DataType.INT);
	q.Add($sym, $e1.sym, $e2.sym, $AddSub.text);
}
| e1=expr '%' e2=expr
{
	Symbol sym1 = s.Add(DataType.INT);
	q.Add(sym1, $e1.sym, $e2.sym, "/");
	Symbol sym2 = s.Add(DataType.INT);
	q.Add(sym2, sym1, $e2.sym, "*");
	$sym = s.Add(DataType.INT);
	q.Add($sym, $e1.sym, sym2, "-");
}
| e1=expr Rel e2=expr
{
	$sym = s.Add(DataType.BOOLEAN);
	q.Add($sym, $e1.sym, $e2.sym, $Rel.text);
	$truelist = new LocList ();
	$truelist.Add(q.Add(null, $sym, null, "if"));
	$falselist = new LocList ();
	$falselist.Add(q.Add(null, $sym, null, "ifFalse"));
}
| '!' e=expr 
{
	$truelist = $e.falselist;
	$falselist = $e.truelist;
}
| e1=expr '&&' marker e2=expr
{
	$e1.truelist.BackPatch($marker.label);
	$truelist = $e2.truelist;
	$falselist = $e1.falselist;
	$falselist.Merge($e2.falselist);
}
| e1=expr '||' marker e2=expr
{
	$e1.falselist.BackPatch($marker.label);
	$truelist = $e1.truelist;
	$falselist = $e2.falselist;
	$truelist.Merge($e2.truelist);
}
| Ident '(' args ')'
{
	$sym = s.Add (s.Find ($Ident.text).GetType());
	String count = "" + $args.count;
	q.Add ($sym, s.Find ($Ident.text) , s.insert(count, DataType.INT), "call");	
}
| Callout '(' Str calloutArgs ')'
{
	$sym = s.Add (DataType.INT);
	String count = "" + $calloutArgs.count;
	q.Add ($sym, s.insert ($Str.text, DataType.STR), s.insert(count, DataType.INT), "call");
};

methodCall 
: Ident '(' args ')'
{
	String count = "" + $args.count;
	q.Add (null, s.Find ($Ident.text) , s.insert(count, DataType.INT), "call");	
}
| Callout '(' Str calloutArgs ')'
{
	String count = "" + $calloutArgs.count;
	q.Add (null, s.insert ($Str.text, DataType.STR), s.insert(count, DataType.INT), "call");
}
;

args returns [int count]
: someArgs
{
	$count = $someArgs.count;
}
|
{
	$count = 0;
}
;

someArgs returns [int count]
: t=someArgs ',' expr
{
	q.Add ($expr.sym, null, null, "param");
	$count = $t.count + 1;
}
| expr
{
	q.Add ($expr.sym, null, null, "param");
	$count = 1;
}
;

calloutArgs returns [int count]
: c=calloutArgs ',' expr
{
	q.Add ($expr.sym, null, null, "param");
	$count = $c.count + 1;
}
| c=calloutArgs ',' Str
{
	Symbol str = s.insert ($Str.text, DataType.STR);
	q.Add (str, null, null, "param");
	$count = $c.count + 1;
}
|
{
	$count = 0;
}
;

marker returns [Symbol label]
:
{
	int l = q.GetNextLabel();
	$label = s.Add (l);
}
;

next returns [LocList nextlist]
:
{
	$nextlist = new LocList();
	$nextlist.Add(q.Add(null, null, null, "goto"));
}
;

location returns [Symbol base, Symbol offset]
:Ident
{
	$base = s.Find($Ident.text);
	$offset = null;
}
| Ident '[' expr ']'
{
	$base = s.Find($Ident.text);
	$offset = s.Add(DataType.INT);
	q.Add($offset, $expr.sym, s.insert("8", DataType.INT), "*");
}
;

num returns [Symbol sym]
: DecNum
{
	$sym = s.Add($text, DataType.INT);
}
| HexNum
{
	$sym = s.Add($text, DataType.INT);
}
;

literal returns [Symbol sym]
: num
{
	$sym = $num.sym;
}
| Char
{
	$sym = s.Add($text, DataType.INT);
}
| BoolLit
{
	$sym = s.Add($text, DataType.BOOLEAN);
}
;

eqOp
: '='
| AssignOp
;

//-----------------------------------------------------------------------------------------------------------
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

AssignOp
: '+='
| '-='
;

MulDiv
: '*'
| '/'
;

AddSub
: '+'
| '-'
;

Rel
: '<'
| '<='
| '>'
| '>='
| '=='
| '!='
;