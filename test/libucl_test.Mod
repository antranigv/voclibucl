MODULE libuclTest;

IMPORT
  ucl,
  Out,
  VT100;

PROCEDURE TestParser();
VAR
  parser : ucl.Parser;
  path   : ARRAY 32 OF CHAR;
  obj    : ucl.Object;
  objfoo : ucl.Object;
  key    : ARRAY 32 OF CHAR;
  val    : ARRAY 32 OF CHAR;

BEGIN
  ucl.NewParser(parser, {0});
  Out.String("= Parser created..."); Out.Ln;

  IF ~ ucl.AddFile(parser, "example.ucl") THEN
    Out.String("! AddFile Failed"); Out.Ln;
    HALT(1)
  ELSE
    Out.String("= Parsed File `example.ucl`"); Out.Ln;
  END;

  IF ~ ucl.AddString(parser, "baz = bat")  THEN
    Out.String("! Failed to AddString");
    HALT(1)
  ELSE
    Out.String("= AddString (baz = bat) done...")
  END;
  Out.Ln;

  IF ~ ucl.GetObject(parser, obj) THEN
    Out.String("! Could not GetObject");
    HALT(1)
  ELSE
    Out.String("= Get Object done...")
  END;
  Out.Ln;

  Out.String("? Looking for object `foo`"); Out.Ln;
  IF ~ ucl.FindKey(obj, "foo", objfoo) THEN
    Out.String("! Could not FindKey `foo`");
    HALT(1)
  ELSE
    Out.String("= Found object with key `foo`")
  END;
  Out.Ln;

  IF ~ ucl.ToString(objfoo, val) THEN
  ELSE
    Out.String("> Value of `foo` is: ");
    Out.String(val); Out.Ln;
  END;

  Out.String("? Looking for object `baz`"); Out.Ln;
  IF ~ ucl.FindKey(obj, "baz", objfoo) THEN
    Out.String("! Could not FindKey `baz`"); Out.Ln;
    HALT(1)
  ELSE
    Out.String("= Found object with key `baz`")
  END;
  Out.Ln;

  IF ~ ucl.ToString(objfoo, val) THEN
  ELSE
    Out.String("> Value of `baz` is: ");
    Out.String(val); Out.Ln;
  END;
END TestParser;

BEGIN
  TestParser;

  VT100.SetAttr(VT100.Green);
  Out.String("DONE!");
  VT100.SetAttr(VT100.ResetAll);
  Out.Ln;

END libuclTest.
