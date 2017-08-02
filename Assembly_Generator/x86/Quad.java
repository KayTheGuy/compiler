package x86;

	public class Quad {
		Symbol label;
		String op;
		Symbol src1;
		Symbol src2;
		Symbol dst;

		public Quad (SymStack s, int l, Symbol d, Symbol s1, Symbol s2, String o) {
			label = s.Add(l);
			dst = d;
			src1 = s1;
			src2 = s2;
			op = o;
		}

		public Quad (Symbol l) {
			label = l;
			dst = null;
			src1 = null;
			src2 = null;
			op = "";
		}

		public void BackPatch (Symbol l) {
			dst = l;
		}

		public Symbol GetLabel () {
			return label;
		}

		public void Print () {
			System.out.print(label.GetName() + ": ");
			if (dst != null) System.out.print(dst.GetName());
			if (src1 != null) System.out.print(" = " + src1.GetName());
			System.out.print(" " + op + " ");
			if (src2 != null) System.out.print(src2.GetName());
			System.out.println("");
		}

		public void AsmPrint () {
			System.out.print(label.GetName() + ": ");
			if (op.equals("")) { //label
				System.out.println("push %rbp");
				System.out.println("mov %rsp, %rbp");
			} else if (op.equals("frame")) {
				System.out.println("sub " + dst.AsmPrint() + ", %rsp");
			} else if (op.equals("ret")) { //return
				if (src1 != null) System.out.println("mov -" + src1.GetOffset() + "(%rbp), %rax");
				System.out.println("add $" + dst.GetName() + ", %rsp");
				System.out.println("pop %rbp");
				System.out.println("ret");
			} else if (op.equals("=")) { //assignment
				ReadSrc1(src1);
				WriteDst(dst);
			} else if (op.equals("+")) { //addition
				ReadSrc1(src1);
				ReadSrc2(src2);
				Compute("add");
				WriteDst(dst);
			} else if (op.equals("-")) { //subtraction
				ReadSrc1(src1);
				ReadSrc2(src2);
				Compute("sub");
				WriteDst(dst);
			} else if (op.equals("*")) { //multiplication
				ReadSrc1(src1);
				ReadSrc2(src2);
				Compute("mulq");
				WriteDst(dst);
			} else if (op.equals("/")) { //division
				System.out.println("YOOOO mov $0, %rdx");
				ReadSrc1(src1);
				ReadSrc2(src2);
				Compute("idiv");
				WriteDst(dst);
			} else if (op.equals("call")) {
				System.out.println("call " + src1.GetName());
			} else if (op.equals("push %rdi")) {
				System.out.println("YOOOO" );
			} else if (op.equals("rdi") || op.equals("rsi") || op.equals("rdx") 
					   || op.equals("rcx") || op.equals("r8") || op.equals("r9")) {
				System.out.println("mov " + dst.AsmPrint() + ", %" + op);
			}
		}

		void Compute (String opcode) {
			if (opcode.equals("add") || opcode.equals("sub")) {
				System.out.println(opcode + " %rbx, %rax");
			} else if (opcode.equals("mulq") || opcode.equals("idiv")) {
				System.out.println(opcode + " %rbx");
			}
		}

		void ReadSrc1 (Symbol src) {
			System.out.println("mov " + src.AsmPrint() + ", %rax");
		}

		void ReadSrc2 (Symbol src) {
			System.out.println("mov " + src.AsmPrint() + ", %rbx");
		}

		void WriteDst (Symbol dst) {
			System.out.println("mov %rax, " + dst.AsmPrint());
		}
	}