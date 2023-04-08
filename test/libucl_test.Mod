MODULE libuclTest;

IMPORT
  ucl,
  Out,
  VT100;

VAR
  parser  : ucl.Parser;

PROCEDURE TestParser(VAR parser: ucl.Parser);
BEGIN
  Out.String("==> Testing Parser, AddFile and AddString"); Out.Ln;
  ucl.NewParser(parser, {0});
  Out.String(" = Parser created..."); Out.Ln;

  IF ~ ucl.AddFile(parser, "example.ucl") THEN
    Out.String(" ! AddFile Failed"); Out.Ln;
    HALT(1)
  ELSE
    Out.String(" = AddFile `example.ucl` done..."); Out.Ln;
  END;

  IF ~ ucl.AddString(parser, "ucl = awesome!")  THEN
    Out.String(" ! Failed to AddString");
    HALT(1)
  ELSE
    Out.String(" = AddString (ucl = awesome!) done...")
  END;
  Out.Ln;

  Out.String("==> Passed!"); Out.Ln;
END TestParser;

PROCEDURE TestKnownKeys(VAR parser: ucl.Parser);
VAR
  obj, objkey : ucl.TObject;
  StrVal      : ARRAY 32 OF CHAR;
  IntVal      : INTEGER;

BEGIN
  Out.String("==> Testing Known Keys"); Out.Ln;
  Out.String(" => GetObject, FindKey and ToString"); Out.Ln;

  IF ucl.GetObject(parser, obj) THEN
    Out.String(" = Get Object done...")
  ELSE
    Out.String(" ! Could not GetObject");
    HALT(1)
  END;
  Out.Ln;

  Out.String(" ? Looking for object `foo`"); Out.Ln;
  IF ~ ucl.FindKey(obj, "foo", objkey) THEN
    Out.String("! Could not FindKey `foo`");
    HALT(1)
  ELSE
    Out.String(" = Found object with key : ");
    IF ucl.ObjectKey(objkey, StrVal) THEN
      Out.String(StrVal);
    END;
  END;
  Out.Ln;

  Out.String(" > Value of `foo` is: ");
  ucl.ToString(objkey, StrVal);
  Out.String(StrVal); Out.Ln;

  Out.String(" ? Looking for object `baz`"); Out.Ln;
  IF ~ ucl.FindKey(obj, "baz", objkey) THEN
    Out.String(" ! Could not FindKey `baz`"); Out.Ln;
    HALT(1)
  ELSE
    Out.String(" = Found object with key : ");
    IF ucl.ObjectKey(objkey, StrVal) THEN
      Out.String(StrVal);
    END;
  END;
  Out.Ln;

  Out.String(" > Value of `baz` is: ");
  ucl.ToString(objkey, StrVal);
  Out.String(StrVal); Out.Ln;

  Out.String("==> Passed!"); Out.Ln;
END TestKnownKeys;

PROCEDURE TestIterator(VAR parser: ucl.Parser);
VAR
  obj, objkey, iter : ucl.TObject;
  type              : ucl.TypeName;
  StrVal            : ARRAY 32 OF CHAR;
  IntVal            : INTEGER;
BEGIN
  Out.String("==> Testing Iterator, GetType and TypeName"); Out.Ln;

  IF ucl.GetObject(parser, obj) THEN
    Out.String(" = Get Object done...")
  ELSE
    Out.String(" ! Could not GetObject"); Out.Ln;
    HALT(1)
  END;
  Out.Ln;

  iter := 0;
  WHILE ucl.IterateObject(obj, objkey, iter, TRUE) DO
    IF ucl.ObjectKey(objkey, StrVal) THEN
      Out.String(" > - key  : ");
      Out.String(StrVal); Out.Ln;
      Out.String("   - val  : ");
      CASE ucl.GetType(objkey) OF
          ucl.String  : ucl.ToString(objkey, StrVal); Out.String(StrVal);
        | ucl.Integer : Out.Int(ucl.ToInteger(objkey), 0);
      END;
      Out.Ln;
      Out.String("   - type : ");
      ucl.GetTypeName(objkey, type);
      Out.String(type);
      Out.Ln;
    END;
  END;
  Out.String("==> Passed!"); Out.Ln;
END TestIterator;

BEGIN
  TestParser(parser);

  TestKnownKeys(parser);

  TestIterator(parser);

  VT100.SetAttr(VT100.Green);
  Out.String("ALL PASSED");
  VT100.SetAttr(VT100.ResetAll);
  Out.Ln;

END libuclTest.
