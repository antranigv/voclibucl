MODULE ucl;

IMPORT
  Out,
  SYSTEM;

TYPE
  Parser*      = SYSTEM.ADDRESS;
  ParserFlag*  = HUGEINT;
  ParserFlags* = SYSTEM.SET64;

  Object*      = SYSTEM.ADDRESS;


VAR
  ParserDefault-          : HUGEINT;
  ParserKeyLowercase-     : HUGEINT;
  ParserZeroCopy-         : HUGEINT;
  ParserNoTime-           : HUGEINT;
  ParserNoImplicitArrays- : HUGEINT;
  ParserSaveComments-     : HUGEINT;
  ParserDisableMacro-     : HUGEINT;
  ParserNoFileVars-       : HUGEINT;

PROCEDURE -Aincludeucl '#include <ucl.h>';

PROCEDURE -uclParserNew(flags: ParserFlag): Parser
"ucl_parser_new(flags)";

PROCEDURE NewParser*(VAR parser: Parser; flagset: ParserFlags);
VAR
  flags : HUGEINT;
BEGIN
  flags  := SYSTEM.VAL(ParserFlag, flagset);
  parser := uclParserNew(flags);
END NewParser;

PROCEDURE -uclParserAddFile(VAR parser: Parser; VAR file: ARRAY OF CHAR): INTEGER
'ucl_parser_add_file(parser, file)';

PROCEDURE AddFile*(VAR parser: Parser; VAR file: ARRAY OF CHAR): BOOLEAN;
BEGIN
  RETURN uclParserAddFile(parser, file) # 0
END AddFile;

PROCEDURE -uclParserAddString(parser: Parser; VAR string: ARRAY OF CHAR): INTEGER
"ucl_parser_add_string(parser, string, 0)";

PROCEDURE AddString*(VAR parser: Parser; string: ARRAY OF CHAR): BOOLEAN;
BEGIN
  RETURN uclParserAddString(parser, string) # 0;
END AddString;

PROCEDURE -uclParserGetObject(VAR parser: Parser): Object
"ucl_parser_get_object(parser)";

PROCEDURE GetObject*(VAR parser: Parser): Object;
BEGIN
  RETURN uclParserGetObject(parser);
END GetObject;

PROCEDURE -uclObjectFindKey(VAR object: Object; VAR key: ARRAY OF CHAR): Object
"ucl_object_find_key(object, key)";

PROCEDURE FindKey*(VAR object: Object; VAR key: ARRAY OF CHAR): Object;
BEGIN
  RETURN uclObjectFindKey(object, key);
END FindKey;

PROCEDURE -uclObjectToString(VAR object: Object): SYSTEM.ADDRESS
"ucl_object_tostring(object)";

PROCEDURE ToString*(VAR object: Object; VAR string: ARRAY OF CHAR);
VAR
  objstr  : ARRAY 64 OF CHAR;
  i       : INTEGER;
  ch      : CHAR;
  objstrp : SYSTEM.ADDRESS;
BEGIN
  i := 0;
  objstrp := uclObjectToString(object);
  REPEAT
    SYSTEM.GET(objstrp + i, ch);
    objstr[i] := ch;
    Out.Char(ch); Out.Ln;
  UNTIL (ch = 0X) OR (i >= LEN(objstr) - 1);
END ToString;

BEGIN
  ParserDefault          := 0;
  ParserKeyLowercase     := ASH(1, 0);
  ParserZeroCopy         := ASH(1, 1);
  ParserNoTime           := ASH(1, 2);
  ParserNoImplicitArrays := ASH(1, 3);
  ParserSaveComments     := ASH(1, 4);
  ParserDisableMacro     := ASH(1, 5);
  ParserNoFileVars       := ASH(1, 6);

END ucl.
