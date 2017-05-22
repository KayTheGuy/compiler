// Generated from A1Lexer.g4 by ANTLR 4.5.3
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class A1Lexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.5.3", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		WhITESPACE=1, CLASS=2, PROGRAM=3, VOID=4, INT=5, BOOL=6, IF=7, ELSE=8, 
		FOR=9, RETURN=10, BREAK=11, CONTINUE=12, CALLOUT=13, TRUE=14, FALSE=15, 
		HEX_SIGN=16, ASSIGN=17, PLUS_ASSIGN=18, MINUS_ASSIGN=19, LEFT_BRACE=20, 
		RIGHT_BRACE=21, LEFT_BRACKET=22, RIGHT_BRACKET=23, LEFT_PARENT=24, RIGHT_PARENT=25, 
		SEMICOLON=26, COMMA=27, MINUS=28, PLUS=29, MULTIPLY=30, DIVISION=31, REMAINDER=32, 
		BOOL_NEGATE=33, LESS=34, STRICT_LESS=35, LARGER=36, STRICT_LARGER=37, 
		EQUAL=38, NOT_EQUAL=39, AND=40, OR=41, ID=42, INT_LITERAL=43, STRING_LITERAL=44, 
		CHAR_LITERAL=45;
	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"DELIM", "DIGIT", "ALPHA", "HEX_LETTERS", "WhITESPACE", "CLASS", "PROGRAM", 
		"VOID", "INT", "BOOL", "IF", "ELSE", "FOR", "RETURN", "BREAK", "CONTINUE", 
		"CALLOUT", "TRUE", "FALSE", "HEX_SIGN", "ASSIGN", "PLUS_ASSIGN", "MINUS_ASSIGN", 
		"LEFT_BRACE", "RIGHT_BRACE", "LEFT_BRACKET", "RIGHT_BRACKET", "LEFT_PARENT", 
		"RIGHT_PARENT", "SEMICOLON", "COMMA", "MINUS", "PLUS", "MULTIPLY", "DIVISION", 
		"REMAINDER", "BOOL_NEGATE", "LESS", "STRICT_LESS", "LARGER", "STRICT_LARGER", 
		"EQUAL", "NOT_EQUAL", "AND", "OR", "ID", "INT_LITERAL", "STRING_LITERAL", 
		"CHAR_LITERAL"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, "'class'", "'Program'", "'void'", "'int'", "'boolean'", "'if'", 
		"'else'", "'for'", "'return'", "'break'", "'continue'", "'callout'", "'true'", 
		"'false'", "'0x'", "'='", "'+='", "'-='", "'{'", "'}'", "'['", "']'", 
		"'('", "')'", "';'", "','", "'-'", "'+'", "'*'", "'/'", "'%'", "'!'", 
		"'<'", "'<='", "'>'", "'>='", "'=='", "'!='", "'&&'", "'||'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "WhITESPACE", "CLASS", "PROGRAM", "VOID", "INT", "BOOL", "IF", "ELSE", 
		"FOR", "RETURN", "BREAK", "CONTINUE", "CALLOUT", "TRUE", "FALSE", "HEX_SIGN", 
		"ASSIGN", "PLUS_ASSIGN", "MINUS_ASSIGN", "LEFT_BRACE", "RIGHT_BRACE", 
		"LEFT_BRACKET", "RIGHT_BRACKET", "LEFT_PARENT", "RIGHT_PARENT", "SEMICOLON", 
		"COMMA", "MINUS", "PLUS", "MULTIPLY", "DIVISION", "REMAINDER", "BOOL_NEGATE", 
		"LESS", "STRICT_LESS", "LARGER", "STRICT_LARGER", "EQUAL", "NOT_EQUAL", 
		"AND", "OR", "ID", "INT_LITERAL", "STRING_LITERAL", "CHAR_LITERAL"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public A1Lexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "A1Lexer.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\2/\u0129\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\3\2\3\2\3\3\3\3\3"+
		"\4\5\4k\n\4\3\5\3\5\3\6\6\6p\n\6\r\6\16\6q\3\6\3\6\3\7\3\7\3\7\3\7\3\7"+
		"\3\7\3\b\3\b\3\b\3\b\3\b\3\b\3\b\3\b\3\t\3\t\3\t\3\t\3\t\3\n\3\n\3\n\3"+
		"\n\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\f\3\f\3\f\3\r\3\r\3\r\3\r"+
		"\3\r\3\16\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\22"+
		"\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23\3\23\3\23\3\24\3\24"+
		"\3\24\3\24\3\24\3\24\3\25\3\25\3\25\3\26\3\26\3\27\3\27\3\27\3\30\3\30"+
		"\3\30\3\31\3\31\3\32\3\32\3\33\3\33\3\34\3\34\3\35\3\35\3\36\3\36\3\37"+
		"\3\37\3 \3 \3!\3!\3\"\3\"\3#\3#\3$\3$\3%\3%\3&\3&\3\'\3\'\3(\3(\3(\3)"+
		"\3)\3*\3*\3*\3+\3+\3+\3,\3,\3,\3-\3-\3-\3.\3.\3.\3/\3/\3/\7/\u010a\n/"+
		"\f/\16/\u010d\13/\3\60\6\60\u0110\n\60\r\60\16\60\u0111\3\60\3\60\3\60"+
		"\6\60\u0117\n\60\r\60\16\60\u0118\5\60\u011b\n\60\3\61\3\61\7\61\u011f"+
		"\n\61\f\61\16\61\u0122\13\61\3\61\3\61\3\62\3\62\3\62\3\62\3\u0120\2\63"+
		"\3\2\5\2\7\2\t\2\13\3\r\4\17\5\21\6\23\7\25\b\27\t\31\n\33\13\35\f\37"+
		"\r!\16#\17%\20\'\21)\22+\23-\24/\25\61\26\63\27\65\30\67\319\32;\33=\34"+
		"?\35A\36C\37E G!I\"K#M$O%Q&S\'U(W)Y*[+],_-a.c/\3\2\6\4\2\13\f\"\"\3\2"+
		"\62;\5\2C\\aac|\4\2CHch\u012c\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2"+
		"\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3"+
		"\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'"+
		"\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63"+
		"\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2"+
		"?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3"+
		"\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2"+
		"\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\3"+
		"e\3\2\2\2\5g\3\2\2\2\7j\3\2\2\2\tl\3\2\2\2\13o\3\2\2\2\ru\3\2\2\2\17{"+
		"\3\2\2\2\21\u0083\3\2\2\2\23\u0088\3\2\2\2\25\u008c\3\2\2\2\27\u0094\3"+
		"\2\2\2\31\u0097\3\2\2\2\33\u009c\3\2\2\2\35\u00a0\3\2\2\2\37\u00a7\3\2"+
		"\2\2!\u00ad\3\2\2\2#\u00b6\3\2\2\2%\u00be\3\2\2\2\'\u00c3\3\2\2\2)\u00c9"+
		"\3\2\2\2+\u00cc\3\2\2\2-\u00ce\3\2\2\2/\u00d1\3\2\2\2\61\u00d4\3\2\2\2"+
		"\63\u00d6\3\2\2\2\65\u00d8\3\2\2\2\67\u00da\3\2\2\29\u00dc\3\2\2\2;\u00de"+
		"\3\2\2\2=\u00e0\3\2\2\2?\u00e2\3\2\2\2A\u00e4\3\2\2\2C\u00e6\3\2\2\2E"+
		"\u00e8\3\2\2\2G\u00ea\3\2\2\2I\u00ec\3\2\2\2K\u00ee\3\2\2\2M\u00f0\3\2"+
		"\2\2O\u00f2\3\2\2\2Q\u00f5\3\2\2\2S\u00f7\3\2\2\2U\u00fa\3\2\2\2W\u00fd"+
		"\3\2\2\2Y\u0100\3\2\2\2[\u0103\3\2\2\2]\u0106\3\2\2\2_\u011a\3\2\2\2a"+
		"\u011c\3\2\2\2c\u0125\3\2\2\2ef\t\2\2\2f\4\3\2\2\2gh\t\3\2\2h\6\3\2\2"+
		"\2ik\t\4\2\2ji\3\2\2\2k\b\3\2\2\2lm\t\5\2\2m\n\3\2\2\2np\5\3\2\2on\3\2"+
		"\2\2pq\3\2\2\2qo\3\2\2\2qr\3\2\2\2rs\3\2\2\2st\b\6\2\2t\f\3\2\2\2uv\7"+
		"e\2\2vw\7n\2\2wx\7c\2\2xy\7u\2\2yz\7u\2\2z\16\3\2\2\2{|\7R\2\2|}\7t\2"+
		"\2}~\7q\2\2~\177\7i\2\2\177\u0080\7t\2\2\u0080\u0081\7c\2\2\u0081\u0082"+
		"\7o\2\2\u0082\20\3\2\2\2\u0083\u0084\7x\2\2\u0084\u0085\7q\2\2\u0085\u0086"+
		"\7k\2\2\u0086\u0087\7f\2\2\u0087\22\3\2\2\2\u0088\u0089\7k\2\2\u0089\u008a"+
		"\7p\2\2\u008a\u008b\7v\2\2\u008b\24\3\2\2\2\u008c\u008d\7d\2\2\u008d\u008e"+
		"\7q\2\2\u008e\u008f\7q\2\2\u008f\u0090\7n\2\2\u0090\u0091\7g\2\2\u0091"+
		"\u0092\7c\2\2\u0092\u0093\7p\2\2\u0093\26\3\2\2\2\u0094\u0095\7k\2\2\u0095"+
		"\u0096\7h\2\2\u0096\30\3\2\2\2\u0097\u0098\7g\2\2\u0098\u0099\7n\2\2\u0099"+
		"\u009a\7u\2\2\u009a\u009b\7g\2\2\u009b\32\3\2\2\2\u009c\u009d\7h\2\2\u009d"+
		"\u009e\7q\2\2\u009e\u009f\7t\2\2\u009f\34\3\2\2\2\u00a0\u00a1\7t\2\2\u00a1"+
		"\u00a2\7g\2\2\u00a2\u00a3\7v\2\2\u00a3\u00a4\7w\2\2\u00a4\u00a5\7t\2\2"+
		"\u00a5\u00a6\7p\2\2\u00a6\36\3\2\2\2\u00a7\u00a8\7d\2\2\u00a8\u00a9\7"+
		"t\2\2\u00a9\u00aa\7g\2\2\u00aa\u00ab\7c\2\2\u00ab\u00ac\7m\2\2\u00ac "+
		"\3\2\2\2\u00ad\u00ae\7e\2\2\u00ae\u00af\7q\2\2\u00af\u00b0\7p\2\2\u00b0"+
		"\u00b1\7v\2\2\u00b1\u00b2\7k\2\2\u00b2\u00b3\7p\2\2\u00b3\u00b4\7w\2\2"+
		"\u00b4\u00b5\7g\2\2\u00b5\"\3\2\2\2\u00b6\u00b7\7e\2\2\u00b7\u00b8\7c"+
		"\2\2\u00b8\u00b9\7n\2\2\u00b9\u00ba\7n\2\2\u00ba\u00bb\7q\2\2\u00bb\u00bc"+
		"\7w\2\2\u00bc\u00bd\7v\2\2\u00bd$\3\2\2\2\u00be\u00bf\7v\2\2\u00bf\u00c0"+
		"\7t\2\2\u00c0\u00c1\7w\2\2\u00c1\u00c2\7g\2\2\u00c2&\3\2\2\2\u00c3\u00c4"+
		"\7h\2\2\u00c4\u00c5\7c\2\2\u00c5\u00c6\7n\2\2\u00c6\u00c7\7u\2\2\u00c7"+
		"\u00c8\7g\2\2\u00c8(\3\2\2\2\u00c9\u00ca\7\62\2\2\u00ca\u00cb\7z\2\2\u00cb"+
		"*\3\2\2\2\u00cc\u00cd\7?\2\2\u00cd,\3\2\2\2\u00ce\u00cf\7-\2\2\u00cf\u00d0"+
		"\7?\2\2\u00d0.\3\2\2\2\u00d1\u00d2\7/\2\2\u00d2\u00d3\7?\2\2\u00d3\60"+
		"\3\2\2\2\u00d4\u00d5\7}\2\2\u00d5\62\3\2\2\2\u00d6\u00d7\7\177\2\2\u00d7"+
		"\64\3\2\2\2\u00d8\u00d9\7]\2\2\u00d9\66\3\2\2\2\u00da\u00db\7_\2\2\u00db"+
		"8\3\2\2\2\u00dc\u00dd\7*\2\2\u00dd:\3\2\2\2\u00de\u00df\7+\2\2\u00df<"+
		"\3\2\2\2\u00e0\u00e1\7=\2\2\u00e1>\3\2\2\2\u00e2\u00e3\7.\2\2\u00e3@\3"+
		"\2\2\2\u00e4\u00e5\7/\2\2\u00e5B\3\2\2\2\u00e6\u00e7\7-\2\2\u00e7D\3\2"+
		"\2\2\u00e8\u00e9\7,\2\2\u00e9F\3\2\2\2\u00ea\u00eb\7\61\2\2\u00ebH\3\2"+
		"\2\2\u00ec\u00ed\7\'\2\2\u00edJ\3\2\2\2\u00ee\u00ef\7#\2\2\u00efL\3\2"+
		"\2\2\u00f0\u00f1\7>\2\2\u00f1N\3\2\2\2\u00f2\u00f3\7>\2\2\u00f3\u00f4"+
		"\7?\2\2\u00f4P\3\2\2\2\u00f5\u00f6\7@\2\2\u00f6R\3\2\2\2\u00f7\u00f8\7"+
		"@\2\2\u00f8\u00f9\7?\2\2\u00f9T\3\2\2\2\u00fa\u00fb\7?\2\2\u00fb\u00fc"+
		"\7?\2\2\u00fcV\3\2\2\2\u00fd\u00fe\7#\2\2\u00fe\u00ff\7?\2\2\u00ffX\3"+
		"\2\2\2\u0100\u0101\7(\2\2\u0101\u0102\7(\2\2\u0102Z\3\2\2\2\u0103\u0104"+
		"\7~\2\2\u0104\u0105\7~\2\2\u0105\\\3\2\2\2\u0106\u010b\5\7\4\2\u0107\u010a"+
		"\5\7\4\2\u0108\u010a\5\5\3\2\u0109\u0107\3\2\2\2\u0109\u0108\3\2\2\2\u010a"+
		"\u010d\3\2\2\2\u010b\u0109\3\2\2\2\u010b\u010c\3\2\2\2\u010c^\3\2\2\2"+
		"\u010d\u010b\3\2\2\2\u010e\u0110\5\5\3\2\u010f\u010e\3\2\2\2\u0110\u0111"+
		"\3\2\2\2\u0111\u010f\3\2\2\2\u0111\u0112\3\2\2\2\u0112\u011b\3\2\2\2\u0113"+
		"\u0116\5)\25\2\u0114\u0117\5\5\3\2\u0115\u0117\5\t\5\2\u0116\u0114\3\2"+
		"\2\2\u0116\u0115\3\2\2\2\u0117\u0118\3\2\2\2\u0118\u0116\3\2\2\2\u0118"+
		"\u0119\3\2\2\2\u0119\u011b\3\2\2\2\u011a\u010f\3\2\2\2\u011a\u0113\3\2"+
		"\2\2\u011b`\3\2\2\2\u011c\u0120\7$\2\2\u011d\u011f\13\2\2\2\u011e\u011d"+
		"\3\2\2\2\u011f\u0122\3\2\2\2\u0120\u0121\3\2\2\2\u0120\u011e\3\2\2\2\u0121"+
		"\u0123\3\2\2\2\u0122\u0120\3\2\2\2\u0123\u0124\7$\2\2\u0124b\3\2\2\2\u0125"+
		"\u0126\7)\2\2\u0126\u0127\13\2\2\2\u0127\u0128\7)\2\2\u0128d\3\2\2\2\f"+
		"\2jq\u0109\u010b\u0111\u0116\u0118\u011a\u0120\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}