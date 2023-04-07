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
  Out.String("Parser created..."); Out.Ln;
  IF ucl.AddString(parser, "foo = bar")  THEN
    Out.String("AddString done..."); Out.Ln;
  ELSE
    Out.String("Failed to AddString"); Out.Ln;
  END;

  obj := ucl.GetObject(parser);
  key := "foo";
  objfoo := ucl.FindKey(obj, key);
  ucl.ToString(objfoo, val);


(*
  path := "example.ucl";
  IF ucl.AddFile(parser, path) THEN
    Out.String("Parsed File"); Out.Ln;
  ELSE
    Out.String("AddFile Failed"); Out.Ln;
  END;
*)
END TestParser;

BEGIN
  TestParser;

  VT100.SetAttr(VT100.Green);
  Out.String("DONE!");
  VT100.SetAttr(VT100.ResetAll);
  Out.Ln;

END libuclTest.
