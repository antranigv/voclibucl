MODULE ucl;

IMPORT
  Out,
  SYSTEM;

TYPE
  Parser*       = SYSTEM.ADDRESS;
  ParserFlag    = HUGEINT;
  ParserFlags*  = SYSTEM.SET64;

  TObject*      = SYSTEM.ADDRESS;
  StringPtr     = SYSTEM.ADDRESS;
  TypeName*     = ARRAY 9 OF CHAR;


CONST
  Object*   = 0;
  Array*    = 1;
  Integer*  = 2;
  Float*    = 3;
  String*   = 4;
  Boolean*  = 5;
  Time*     = 6;
  Userdata* = 7;
  Null*     = 8;

VAR
  ParserDefault-          : ParserFlag;
  ParserKeyLowercase-     : ParserFlag;
  ParserZeroCopy-         : ParserFlag;
  ParserNoTime-           : ParserFlag;
  ParserNoImplicitArrays- : ParserFlag;
  ParserSaveComments-     : ParserFlag;
  ParserDisableMacro-     : ParserFlag;
  ParserNoFileVars-       : ParserFlag;

PROCEDURE -Aincludeucl '#include <ucl.h>';

(* Internal Procedures *)
PROCEDURE StringPtrToString(src: StringPtr; VAR dst: ARRAY OF CHAR);
VAR
  i     : INTEGER;
  ch    : CHAR;
  str   : ARRAY 64 OF CHAR;
BEGIN
  i := 0;
  REPEAT
    SYSTEM.GET(src + i, ch);
    str[i] := ch;
    INC(i)
  UNTIL (ch = 0X) OR (i >= (LEN(str) - 1));
  COPY(str, dst);
END StringPtrToString;

PROCEDURE -uclParserNew(flags: ParserFlag): Parser
"ucl_parser_new(flags)";

PROCEDURE NewParser*(VAR parser: Parser; flagset: ParserFlags);
VAR
  flags : ParserFlag;
BEGIN
  flags  := SYSTEM.VAL(ParserFlag, flagset);
  parser := uclParserNew(flags);
END NewParser;

PROCEDURE -uclParserAddFile(parser: Parser; file: ARRAY OF CHAR): INTEGER
'ucl_parser_add_file(parser, file)';

PROCEDURE AddFile*(parser: Parser; file: ARRAY OF CHAR): BOOLEAN;
BEGIN
  RETURN uclParserAddFile(parser, file) # 0
END AddFile;

PROCEDURE -uclParserAddString(parser: Parser; VAR string: ARRAY OF CHAR): INTEGER
"ucl_parser_add_string(parser, string, 0)";

PROCEDURE AddString*(parser: Parser; string: ARRAY OF CHAR): BOOLEAN;
BEGIN
  RETURN uclParserAddString(parser, string) # 0;
END AddString;

PROCEDURE -uclParserGetObject(parser: Parser): TObject
"ucl_parser_get_object(parser)";

PROCEDURE GetObject*(parser: Parser; VAR object: TObject): BOOLEAN;
VAR
  objectInternal : TObject;
BEGIN
  objectInternal := uclParserGetObject(parser);
  IF objectInternal # 0 THEN
    object := objectInternal;
    RETURN TRUE
  ELSE
    RETURN FALSE
  END;
END GetObject;

PROCEDURE -uclObjectFindKey(object: TObject; key: ARRAY OF CHAR): TObject
"ucl_object_find_key(object, key)";

PROCEDURE FindKey*(objectIn: TObject; key: ARRAY OF CHAR; VAR objectOut: TObject ): BOOLEAN;
VAR
  objectInternal : TObject;
BEGIN
  objectInternal := uclObjectFindKey(objectIn, key);
  IF objectInternal # 0 THEN
    objectOut := objectInternal;
    RETURN TRUE
  ELSE
    RETURN FALSE
  END;
END FindKey;

PROCEDURE -uclObjectToString(object: TObject): StringPtr
"ucl_object_tostring(object)";

PROCEDURE ToString*(object: TObject; VAR string: ARRAY OF CHAR);
VAR
  objstrp : StringPtr;
BEGIN
  objstrp := uclObjectToString(object);
  StringPtrToString(objstrp, string);
END ToString;

(* These safe versions have an issue, TODO need fix
PROCEDURE -uclObjectToStringSafe(object: TObject; VAR string: ARRAY OF CHAR): INTEGER
"ucl_object_tostring_safe(object, string)";

PROCEDURE ToStringSafe*(object: TObject; VAR string: ARRAY OF CHAR): BOOLEAN;
BEGIN
  RETURN uclObjectToStringSafe(object, string) # 0
END ToStringSafe;
*)

PROCEDURE -uclObjectToInteger(object: TObject): INTEGER
"ucl_object_toint(object)";

PROCEDURE ToInteger*(object: TObject): INTEGER;
BEGIN
  RETURN uclObjectToInteger(object)
END ToInteger;

PROCEDURE -uclObjectKey(object: TObject): StringPtr
"ucl_object_key(object)";

PROCEDURE ObjectKey*(object: TObject; VAR string: ARRAY OF CHAR): BOOLEAN;
VAR
  objkeyp : StringPtr;
BEGIN
  objkeyp := uclObjectKey(object);
  IF objkeyp # 0 THEN
    StringPtrToString(objkeyp, string);
    RETURN TRUE
  END;
  RETURN FALSE
END ObjectKey;

PROCEDURE -uclIterateObject(object: TObject; VAR iterator: TObject; expandValues: INTEGER): TObject
"ucl_iterate_object(object, iterator, ev)";

PROCEDURE IterateObject*(
  TopObject: TObject;
  VAR ResObject: TObject;
  VAR iterator: TObject;
  expandValues: BOOLEAN): BOOLEAN;

VAR
  objectInternal    : TObject;
  iteratorInternal  : TObject;
  ev                : INTEGER;
BEGIN
  ev := 0;
  IF expandValues THEN
    ev := 1
  END;
  iteratorInternal := iterator;
  objectInternal := uclIterateObject(TopObject, iteratorInternal, ev);
  IF objectInternal # 0 THEN
    iterator  := iteratorInternal;
    ResObject := objectInternal;
    RETURN TRUE
  END;
  RETURN FALSE
END IterateObject;

PROCEDURE -getType(object: TObject): INTEGER
"ucl_object_type(object)";

PROCEDURE GetType*(object: TObject): INTEGER;
BEGIN
  RETURN getType(object)
END GetType;

PROCEDURE GetTypeName*(object: TObject; VAR typeName: TypeName);
BEGIN
  CASE getType(object) OF
      Object: typeName := "Object"
    | Array : typeName := "Array"
    | Integer   : typeName := "Integer"
    | Float     : typeName := "Float"
    | String    : typeName := "String"
    | Boolean   : typeName := "Boolean"
    | Time      : typeName := "Time"
    | Userdata  : typeName := "Userdata"
    | Null      : typeName := "Null"
  END;
END GetTypeName;

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
