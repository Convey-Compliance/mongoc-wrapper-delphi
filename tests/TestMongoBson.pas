unit TestMongoBson;
// should be encoded as UTF8 without BOM for Delphi5

interface

uses
  SysUtils, TestFramework, MongoBson;

{$i DelphiVersion_defines.inc}

type

  TestIBsonOID = class(TTestCase)
  private
    FIBsonOID: IBsonOID;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetValueAndGetValue;
    procedure TestAsString;
  end;
  // Test methods for class IBsonCodeWScope
  
  TestIBsonCodeWScope = class(TTestCase)
  private
    FIBsonCodeWScope: IBsonCodeWScope;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestsetAndGetCode;
    procedure TestsetAndGetScope;
  end;
  // Test methods for class IBsonRegex
  
  TestIBsonRegex = class(TTestCase)
  private
    FIBsonRegex: IBsonRegex;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestgetAndsetPattern;
    procedure TestgetAndsetOptions;
  end;
  // Test methods for class IBsonTimestamp
  
  TestIBsonTimestamp = class(TTestCase)
  private
    FUnixTime: Int64;
    FIBsonTimestamp: IBsonTimestamp;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestsetAndGetTime;
    procedure TestsetAndGetIncrement;
  end;
  // Test methods for class IBsonBinary
  
  TestIBsonBinary = class(TTestCase)
  private
    FIBsonBinary: IBsonBinary;
  private
    FData: array [0..255] of byte;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestgetLen;
    procedure TestsetAndGetData;
    procedure TestgetKindAndsetKind;
  end;
  // Test methods for class IBsonBuffer
  
  TestIBsonBuffer = class(TTestCase)
  private
    FIBsonBuffer: IBsonBuffer;
    procedure CheckObjectWithAppendedElements(Obj: IBson);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAppendStr;
    procedure TestAppendInteger;
    procedure TestAppendInt64;
    procedure TestAppendDouble;
    procedure TestappendDate;
    procedure TestAppendRegEx;
    procedure TestAppendTimeStamp;
    procedure TestAppendBsonBinary;
    procedure TestAppendIBson;
    procedure TestAppendVariant;
    procedure TestappendIntegerArray;
    procedure TestappendDoubleArray;
    procedure TestappendBooleanArray;
    procedure TestappendStringArray;
    procedure TestappendNull;
    procedure TestappendUndefined;
    procedure TestappendCode;
    procedure TestappendSymbol;
    procedure TestappendBinary;
    procedure TestappendCode_n;
    procedure TestAppendElementsAsArrayOfConst;
    procedure TestAppendElementsAsArraySubObjects;
    procedure TestAppendElementsAsArrayArray;
    procedure TestAppendElementsAsVarRecArray;
    procedure TestAppendElementsAsArrayWithErrors;
    procedure TestAppendStr_n;
    procedure TestappendSymbol_n;
    procedure TeststartObject;
    procedure TeststartArray;
    procedure Testsize;
  end;
  // Test methods for class IBsonIterator
  
  TestIBsonIterator = class(TTestCase)
  private
    FIBsonIterator: IBsonIterator;
    b: IBson;
    bb: IBson;
    BoolArr: TBooleanArray;
    BsonOID: IBsonOID;
    BsonRegEx: IBsonRegex;
    DblArr: TDoubleArray;
    FTimestamp: IBsonTimestamp;
    IntArr: TIntegerArray;
    StrArr: TStringArray;
    FNow: TDateTime;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAsInteger;
    procedure TestAsInt64;
    procedure TestAsUTF8String;
    procedure TestAsDouble;
    procedure TestAsDateTime;
    procedure TestAsBoolean;
    procedure TestgetHandle;
    procedure TestgetBinary;
    procedure TestgetBooleanArray;
    procedure TestgetCodeWScope;
    procedure TestgetDoubleArray;
    procedure TestgetIntegerArray;
    procedure TestgetOID;
    procedure TestgetRegex;
    procedure TestgetStringArray;
    procedure TestgetTimestamp;
    procedure Testkey;
    procedure TestKind;
    procedure TestTryToReadPastEnd;
    procedure Testsubiterator;
    procedure TestValue;
    procedure TestSubiteratorDotNotationSubDoc;
    procedure TestSubiteratorDotNotationArray;
  end;
  // Test methods for class IBson
  
  TestIBson = class(TTestCase)
  private
    FIBson: IBson;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestComplexBson;
    procedure TestCreateFromJson;
    procedure TestAsJson;
    procedure Testfind;
    procedure Testiterator;
    procedure TestMkVarRecArrayFromVarArray;
    procedure TestNewBsonCopy;
    procedure TestSimpleBSON;
    procedure Testsize;
    procedure TestValue;
  end;

  TestArrayBuildingFunctions = class(TTestCase)
  published
    procedure TestBuildIntArray;
    procedure TestBuildDoubleArray;
    procedure TestBuildBooleanArray;
    procedure TestAppendToBooleanArray;
    procedure TestAppendToDoubleArray;
    procedure TestAppendToIntArray;
    procedure TestBuildStrArray;
    procedure TestAppendToStrArray;
    procedure TestBuildVarRecArray;
    procedure TestAppendToVarRecArray;
  end;

implementation

uses
  Classes,
  {$IFNDEF VER130}Variants, {$ENDIF}
  uDelphi5,
  uPrimitiveAllocator, Math, DateUtils, uTestMongo;

procedure TestIBsonOID.SetUp;
begin
  inherited;
  FIBsonOID := NewBsonOID;
end;

procedure TestIBsonOID.TearDown;
begin
  FIBsonOID := nil;
  inherited;
end;

procedure TestIBsonOID.TestSetValueAndGetValue;
var
  AValue: TBsonOIDBytes;
  i : integer;
begin
  for i := 0 to sizeof(AValue) - 1 do
    AValue[i] := i;
  FIBsonOID.setValue(@AValue);
  for I := 0 to sizeof(AValue) - 1 do
    CheckEquals(i, FIBsonOID.getValue[i], 'All values of BSONID should be zero');
end;

procedure TestIBsonOID.TestAsString;
var
  Val64 : Int64;
begin
  HexToBin(PAnsiChar(FIBsonOID.AsString), PAnsiChar(@Val64), sizeof(Val64));
  CheckNotEqualsString('', FIBsonOID.AsString, 'Call to FIBsonOID should return value <> from ""');
end;

{ TestIBsonCodeWScope }

procedure TestIBsonCodeWScope.SetUp;
var
  NilBson : IBson;
begin
  NilBson := nil;
  FIBsonCodeWScope := NewBsonCodeWScope('', NilBson);
end;

procedure TestIBsonCodeWScope.TearDown;
begin
  FIBsonCodeWScope := nil;
  inherited;
end;

procedure TestIBsonCodeWScope.TestsetAndGetCode;
var
  ACode: UTF8String;
begin
  ACode := '123';
  FIBsonCodeWScope.setCode(ACode);
  CheckEqualsString('123', FIBsonCodeWScope.getCode, 'Call to FIBsonCodeWScope.GetCode should be equals to "123"');
end;

procedure TestIBsonCodeWScope.TestsetAndGetScope;
var
  AScope: IBson;
begin
  AScope := BSON(['ID', 1]);
  FIBsonCodeWScope.setScope(AScope);
  Check(AScope = FIBsonCodeWScope.getScope, 'Call to FIBsonCodeWScope.getScope should return value equals to AScope');
end;

{ TestIBsonRegex }

procedure TestIBsonRegex.SetUp;
begin
  FIBsonRegex := NewBsonRegex('123', '456');
end;

procedure TestIBsonRegex.TearDown;
begin
  FIBsonRegex := nil;
  inherited;
end;

procedure TestIBsonRegex.TestgetAndsetPattern;
var
  APattern: UTF8String;
begin
  CheckEqualsString('123', FIBsonRegex.getPattern, 'getPattern should return 123');
  APattern := '098';
  FIBsonRegex.setPattern(APattern);
  CheckEqualsString('098', FIBsonRegex.getPattern, 'call to getPattern after setting new value should return "098"');
end;

procedure TestIBsonRegex.TestgetAndsetOptions;
var
  AOptions: UTF8String;
begin
  CheckEqualsString('456', FIBsonRegex.getOptions, 'getOptions call should return "456"');
  AOptions := '789';
  FIBsonRegex.setOptions(AOptions);
  CheckEqualsString('789', FIBsonRegex.getOptions, 'Call to getOptions after setting options should return "789"');
end;

{ TestIBsonTimestamp }

procedure TestIBsonTimestamp.SetUp;
begin
  FUnixTime := DateTimeToUnix(Now);
  FIBsonTimestamp := NewBsonTimestamp(FUnixTime, 1);
end;

procedure TestIBsonTimestamp.TearDown;
begin
  FIBsonTimestamp := nil;
  inherited;
end;

procedure TestIBsonTimestamp.TestsetAndGetTime;
begin
  CheckEquals(FUnixTime, FIBsonTimestamp.Time);
  FIBsonTimestamp.setTime(1);
  CheckEquals(1, FIBsonTimestamp.getTime);
end;

procedure TestIBsonTimestamp.TestsetAndGetIncrement;
begin
  CheckEquals(1, FIBsonTimestamp.getIncrement, 'Initial value of increment should be equals to 1');
  FIBsonTimestamp.setIncrement(2);
  CheckEquals(2, FIBsonTimestamp.getIncrement, 'New value of Increment should be equals to 2');
end;

{ TestIBsonBinary }

procedure TestIBsonBinary.SetUp;
var
  i : integer;
begin
  for I := low(FData) to high(FData) do
    FData[i] := i;
  FIBsonBinary := NewBsonBinary(@FData, sizeof(FData));
end;

procedure TestIBsonBinary.TearDown;
begin
  FIBsonBinary := nil;
  inherited;
end;

procedure TestIBsonBinary.TestgetLen;
var
  ReturnValue: Integer;
begin
  ReturnValue := FIBsonBinary.getLen;
  CheckEquals(sizeof(FData), ReturnValue, 'getLen should return sizeof(FData) local field');
end;

procedure TestIBsonBinary.TestsetAndGetData;
type
  PByteArray = ^TByteArray;
  TByteArray = array[0..255] of Byte;
var
  AData: Pointer;
  i : integer;
  ANewData : array[0..255] of Byte;
begin
  AData := FIBsonBinary.getData;
  for I := low(FData) to high(FData) do
    CheckEquals(i, PByteArray(AData)[i], 'Cached binary data on IBsonBinary doesn''t match with expected value');
  for I := low(ANewData) to high(ANewData) do
    ANewData[i] := sizeof(ANewData) - i;
  FIBsonBinary.setData(@ANewData, sizeof(ANewData));
  AData := FIBsonBinary.getData;
  for I := low(ANewData) to high(ANewData) do
    CheckEquals(byte(sizeof(ANewData) - i), PByteArray(AData)[i], 'Cached binary data on IBsonBinary doesn''t match with expected value');
end;

procedure TestIBsonBinary.TestgetKindAndsetKind;
var
  AKind: TBsonSubtype;
begin
  Check(BSON_SUBTYPE_BINARY = FIBsonBinary.getKind, 'Initial value of Kind should be zero');
  AKind := BSON_SUBTYPE_FUNCTION;
  FIBsonBinary.setKind(AKind);
  Check(BSON_SUBTYPE_FUNCTION = FIBsonBinary.getKind, 'Value of Kind should be one');
end;

procedure TestIBsonBuffer.CheckObjectWithAppendedElements(Obj: IBson);
begin
  CheckEquals(1, Obj.value('int_fld'), 'int_fld doesn''t match expected value');
  CheckEquals(1, Obj.value('int_fld_wide'), 'int_fld_wide doesn''t match expected value');
  CheckEquals(1, Obj.value('int_fld_string'), 'int_fld_string doesn''t match expected value');
  CheckEquals(1, Obj.value('i'), 'i doesn''t match expected value');
  CheckEquals(1, Obj.value('w'), 'w doesn''t match expected value');
  CheckEquals(1, Obj.value('int_fld_pchar'), 'int_fld_pchar doesn''t match expected value');
  {$IFDEF DELPHI2009}
  CheckEquals(1, Obj.value('int_fld_pwidechar'), 'int_fld_pwidechar doesn''t match expected value');
  CheckEquals(1, Obj.value('int_fld_unicodestring'), 'int_fld_unicodestring doesn''t match expected value');
  {$ENDIF}
  Check(Boolean(Obj.value('bool_fld')), 'bool_fld doesn''t match expected value');
  CheckEqualsString('a', Obj.value('ansichar_fld'), 'ansichar_fld doesn''t match expected value');
  CheckEqualsString(FloatToStr(1.1), FloatToStr(Obj.value('extended_fld')), 'extended_fld doesn''t match expected value');
  CheckEqualsString('pansichar_val', Obj.value('pansichar_fld'), 'pansichar_fld doesn''t match expected value');
  CheckEqualsString('v', Obj.value('widechar_fld'), 'widechar_fld doesn''t match expected value');
  {$IFDEF DELPHI2009}
  CheckEqualsString('pwidechar_val', Obj.value('pwidechar_fld'), 'pwidechar_fld doesn''t match expected value');
  {$ENDIF}
  CheckEqualsString('ansistring_val', Obj.value('ansistring_fld'), 'ansistring_fld doesn''t match expected value');
  CheckEqualsString('string_val', Obj.value('string_fld'), 'string_fld doesn''t match expected value');
  CheckEqualsString(FloatToStr(1.2), FloatToStr(Obj.value('currency_fld')), 'currency_fld doesn''t match expected value');
  CheckEquals(1234, Obj.value('variant_fld'), 'variant_fld doesn''t match expected value');
  CheckEqualsString('widestring_val', Obj.value('widestring_fld'), 'widestring_fld doesn''t match expected value');
  {$IFDEF DELPHI2009}
  CheckEquals(10000000000, Obj.value('int64_fld'), 'int64_fld doesn''t match expected value');
  CheckEqualsString('unicode_val', Obj.value('unicode_fld'), 'unicode_fld doesn''t match expected value');
  {$ENDIF}
end;

{ TestIBsonBuffer }

procedure TestIBsonBuffer.SetUp;
begin
  FIBsonBuffer := NewBsonBuffer;
end;

procedure TestIBsonBuffer.TearDown;
begin
  FIBsonBuffer := nil;
  inherited;
end;

procedure TestIBsonBuffer.TestAppendStr;
var
  ReturnValue: Boolean;
  Value: UTF8String;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'STRFLD';
  Value := 'STRVAL';
  ReturnValue := FIBsonBuffer.AppendStr(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');

  b := FIBsonBuffer.finish;
  CheckEqualsString('STRVAL', b.Value('STRFLD'), 'field on BSon object doesn''t match expected value');
end;

procedure TestIBsonBuffer.TestAppendInteger;
var
  ReturnValue: Boolean;
  Value: Integer;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'INTFLD';
  Value := 100;
  ReturnValue := FIBsonBuffer.Append(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEquals(100, b.Value('INTFLD'), 'field on BSon object doesn''t match expected value');
end;

procedure TestIBsonBuffer.TestAppendInt64;
var
  ReturnValue: Boolean;
  Value: Int64;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'INT64FLD';
  Value := Int64(MaxInt) * 10;
  ReturnValue := FIBsonBuffer.Append(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEquals(Int64(MaxInt) * 10, b.ValueAsInt64('INT64FLD'), 'field on BSon object doesn''t match expected value');
end;

procedure TestIBsonBuffer.TestAppendDouble;
var
  ReturnValue: Boolean;
  Value: Double;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'DBLFLD';
  Value := 100.5;
  ReturnValue := FIBsonBuffer.Append(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEquals(100.5, b.Value('DBLFLD'), 'field on BSon object doesn''t match expected value');
end;

procedure TestIBsonBuffer.TestappendDate;
var
  ReturnValue: Boolean;
  Value: TDateTime;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'DATEFLD';
  Value := Now;
  ReturnValue := FIBsonBuffer.appendDate(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEquals(Value, b.Value('DATEFLD'), DATE_TIME_EPSILON, 'field on BSon object doesn''t match expected value');
end;

procedure TestIBsonBuffer.TestAppendRegEx;
var
  ReturnValue: Boolean;
  Value: IBsonRegex;
  Name: UTF8String;
  b : IBson;
  i : IBsonIterator;
begin
  Name := 'REGEXFLD';
  Value := NewBsonRegex('123', '456');
  ReturnValue := FIBsonBuffer.Append(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  i := b.find(Name);
  Check(i <> nil, 'Iterator should be <> nil');
  CheckEqualsString('123', i.asRegex.getPattern, 'Pattern should be equals to "123"');
  CheckEqualsString('456', i.asRegex.getOptions, 'Pattern should be equals to "456"');
end;

procedure TestIBsonBuffer.TestAppendTimeStamp;
var
  ReturnValue: Boolean;
  Value: IBsonTimestamp;
  Name: UTF8String;
  b : IBson;
  i : IBsonIterator;
begin
  Name := 'TSFLD';
  Value := NewBsonTimestamp(DateTimeToUnix(Now), 1);
  ReturnValue := FIBsonBuffer.Append(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  i := b.find(Name);
  Check(i <> nil, 'Iterator should be <> nil');
  CheckEquals(Value.getTime, i.asTimestamp.getTime, 'Time should be equals to Value.getTime');
  CheckEquals(Value.getIncrement, i.asTimestamp.getIncrement, 'Increment should be equals to Value.getIncrement');
end;

procedure TestIBsonBuffer.TestAppendBsonBinary;
type
  PData = ^TData;
  TData = array [0..255] of Byte;
var
  ReturnValue: Boolean;
  Value: IBsonBinary;
  Name: UTF8String;
  b : IBson;
  i : IBsonIterator;
  Data : array [0..255] of Byte;
  ii : integer;
begin
  for ii := 0 to sizeof(Data) - 1 do
    Data[ii] := ii;
  Name := 'BSONBINFLD';
  Value := NewBsonBinary(@Data, sizeof(Data));
  ReturnValue := FIBsonBuffer.Append(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  i := b.find(Name);
  Check(i <> nil, 'Iterator should be <> nil');
  for ii := 0 to i.asBinary.getLen - 1 do
    CheckEquals(Data[ii], PData(i.asBinary.getData)[ii], 'Data from BsonBinary object doesn''t match');
end;

procedure TestIBsonBuffer.TestAppendIBson;
var
  ReturnValue: Boolean;
  Value: IBson;
  Name: UTF8String;
  b : IBson;
  i, sub : IBsonIterator;
begin
  Name := 'BSFLD';
  Value := BSON(['ID', 1]);
  ReturnValue := FIBsonBuffer.Append(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  i := b.find(Name);
  Check(i <> nil);
  sub := i.subiterator;
  Check(sub.next);
  CheckEquals(1, sub.value, 'Value doesn''t match');
end;

procedure TestIBsonBuffer.TestAppendVariant;
var
  ReturnValue: Boolean;
  Value : Variant;
  Name: UTF8String;
  b : IBson;
  var_single : Single;
  var_double : Double;
  var_currency : Currency;
  {$IFDEF DELPHI2009}
  v_int64 : Int64;
  {$ENDIF}
  {$IFDEF DELPHI2007}
  v_longword : LongWord;
  {$ENDIF}
begin
  Name := 'VARIANTFLD_NULL';
  Value := Null;
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_NULL');

  Name := 'VARIANTFLD_BYTE';
  Value := Byte(1);
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_BYTE');

  Name := 'VARIANTFLD_WORD';
  Value := Word(1234);
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_WORD');

  Name := 'VARIANTFLD_SMALL';
  Value := Smallint(12);
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_SMALL');

  Name := 'VARIANTFLD_SHORT';
  Value := Shortint(-12);
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_SHORT');

  Name := 'VARIANTFLD_INT';
  Value := integer(123);
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_INT');

  {$IFDEF DELPHI2007}
  Name := 'VARIANTFLD_LONGWORD';
  v_longword := 1000000000;
  Value := integer(v_longword);
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_LONGWORD');
  {$ENDIF}

  Name := 'VARIANTFLD_SINGLE';
  var_single := 1000.1;
  ReturnValue := FIBsonBuffer.AppendVariant(Name, var_single);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_SINGLE');

  Name := 'VARIANTFLD_DOUBLE';
  var_double := 1000.2;
  ReturnValue := FIBsonBuffer.AppendVariant(Name, var_double);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_DOUBLE');

  Name := 'VARIANTFLD_CURRENCY';
  var_currency := 1000.3;
  ReturnValue := FIBsonBuffer.AppendVariant(Name, var_currency);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_CURRENCY');

  Name := 'VARIANTFLD_DATE';
  Value := StrToDateTime('1/1/2013');
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_DATE');

  {$IFDEF DELPHI2009}
  Name := 'VARIANTFLD_INT64';
  v_int64 := 10000000000;
  Value := v_int64;
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_INT64');
  {$ENDIF}

  Name := 'VARIANTFLD_BOOL';
  Value := True;
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_BOOL');

  Name := 'VARIANTFLD_STR';
  Value := 'HOLA';
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_STR');

  {$IFDEF DELPHI2009}
  Name := 'VARIANTFLD_USTR';
  Value := UnicodeString('HOLA');
  ReturnValue := FIBsonBuffer.AppendVariant(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True inserting VARIANTFLD_USTR');
  {$ENDIF}

  b := FIBsonBuffer.finish;

  Check(VarIsNull(b.Value('VARIANTFLD_NULL')), 'Expected null bson. Value doesn''t match');
  CheckEquals(1, integer(b.Value('VARIANTFLD_BYTE')), 'Value doesn''t match');
  CheckEquals(1234, integer(b.Value('VARIANTFLD_WORD')), 'Value doesn''t match');
  CheckEquals(12, integer(b.Value('VARIANTFLD_SMALL')), 'Value doesn''t match');
  CheckEquals(-12, integer(b.Value('VARIANTFLD_SHORT')), 'Value doesn''t match');
  CheckEquals(123, integer(b.Value('VARIANTFLD_INT')), 'Value doesn''t match');
  CheckEqualsString(Format('%8.1f', [1000.1]), Format('%8.1f', [Single(b.Value('VARIANTFLD_SINGLE'))]), 'Value doesn''t match');
  CheckEqualsString(Format('%8.1f', [1000.2]), Format('%8.1f', [Double(b.Value('VARIANTFLD_DOUBLE'))]), 'Value doesn''t match');
  CheckEqualsString(Format('%8.1f', [1000.3]), Format('%8.1f', [Currency(b.Value('VARIANTFLD_CURRENCY'))]), 'Value doesn''t match');
  CheckEqualsString('1/1/2013', DateTimeToStr(b.Value('VARIANTFLD_DATE')), 'Value doesn''t match');
  {$IFDEF DELPHI2009}
  CheckEquals(10000000000, Int64(b.Value('VARIANTFLD_INT64')), 'Value doesn''t match');
  {$ENDIF}
  {$IFDEF DELPHI2007}
  CheckEquals(1000000000, LongWord(b.Value('VARIANTFLD_LONGWORD')), 'Value doesn''t match');
  {$ENDIF}
  Check(b.Value('VARIANTFLD_BOOL'), 'Value doesn''t match for VARIANTFLD_BOOL');
  CheckEqualsString('HOLA', b.Value('VARIANTFLD_STR'), 'Value doesn''t match');
  {$IFDEF DELPHI2009}
  CheckEqualsString('HOLA', b.Value('VARIANTFLD_USTR'), 'Value doesn''t match');
  {$ENDIF}
end;

procedure TestIBsonBuffer.TestappendIntegerArray;
var
  ReturnValue: Boolean;
  Value: TIntegerArray;
  Name: UTF8String;
  i : integer;
  it : IBsonIterator;
  b : IBson;
begin
  Name := 'INTARRFLD';
  SetLength(Value, 10);
  for I := low(Value) to high(Value) do
    Value[i] := i;
  ReturnValue := FIBsonBuffer.appendArray(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  it := b.iterator;
  it.Next;
  CheckEquals(length(Value), length(it.asIntegerArray), 'Array sizes don''t match');
  for I := low(it.asIntegerArray) to high(it.asIntegerArray) do
    CheckEquals(Value[i], it.asIntegerArray[i], 'Items on Integer array don''t match');
end;

procedure TestIBsonBuffer.TestappendDoubleArray;
var
  ReturnValue: Boolean;
  Value: TDoubleArray;
  Name: UTF8String;
  i : integer;
  it : IBsonIterator;
  b : IBson;
begin
  Name := 'DBLARRFLD';
  SetLength(Value, 10);
  for I := low(Value) to high(Value) do
    Value[i] := i + 0.2;
  ReturnValue := FIBsonBuffer.appendArray(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  it := b.iterator;
  it.Next;
  CheckEquals(length(Value), length(it.asDoubleArray), 'Array sizes don''t match');
  for I := low(it.asDoubleArray) to high(it.asDoubleArray) do
    CheckEquals(Value[i], it.asDoubleArray[i], 'Items on Double array don''t match');
end;

procedure TestIBsonBuffer.TestappendBooleanArray;
var
  ReturnValue: Boolean;
  Value: TBooleanArray;
  Name: UTF8String;
  i : integer;
  it : IBsonIterator;
  b : IBson;
  BoolArrayResult : TBooleanArray;
begin
  Name := 'BOOLARRFLD';
  SetLength(Value, 10);
  for I := low(Value) to high(Value) do
    Value[i] := i mod 2 = 1;
  ReturnValue := FIBsonBuffer.appendArray(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  it := b.iterator;
  it.Next;
  BoolArrayResult := it.asBooleanArray;
  CheckEquals(length(Value), length(BoolArrayResult), 'Array sizes don''t match');
  for I := low(BoolArrayResult) to high(BoolArrayResult) do
    CheckEquals(Value[i], BoolArrayResult[i], 'Items on Boolean array don''t match');
end;

procedure TestIBsonBuffer.TestappendStringArray;
var
  ReturnValue: Boolean;
  Value: TStringArray;
  Name: UTF8String;
  i : integer;
  it : IBsonIterator;
  b : IBson;
begin
  Name := 'BOOLARRFLD';
  SetLength(Value, 10);
  for I := low(Value) to high(Value) do
    Value[i] := IntToStr(i);
  ReturnValue := FIBsonBuffer.appendArray(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  it := b.iterator;
  it.Next;
  CheckEquals(length(Value), length(it.asStringArray), 'Array sizes don''t match');
  for I := low(it.asStringArray) to high(it.asStringArray) do
    CheckEqualsString(Value[i], it.asStringArray[i], 'Items on UTF8String array don''t match');
end;

procedure TestIBsonBuffer.TestappendNull;
var
  ReturnValue: Boolean;
  Name: UTF8String;
  v : Variant;
  b : IBson;
begin
  Name := 'NULLFLD';
  ReturnValue := FIBsonBuffer.appendNull(Name);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  v := b.Value(Name);
  Check(VarIsNull(v), 'Field should be NULL');
end;

procedure TestIBsonBuffer.TestappendUndefined;
var
  ReturnValue: Boolean;
  Name: UTF8String;
  v : Variant;
  b : IBson;
begin
  Name := 'EMPTYFLD';
  ReturnValue := FIBsonBuffer.appendUndefined(Name);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  v := b.Value(Name);
  Check(VarIsEmpty(v), 'Field should be EMPTY');
end;

procedure TestIBsonBuffer.TestappendCode;
var
  ReturnValue: Boolean;
  Value: UTF8String;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'CODEFLD';
  Value := '123456';
  ReturnValue := FIBsonBuffer.appendCode(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEqualsString(Value, b.Value(Name), 'Code should be equals to "123456"');
end;

procedure TestIBsonBuffer.TestappendSymbol;
var
  ReturnValue: Boolean;
  Value: UTF8String;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'CODEFLD';
  Value := 'SymbolTest';
  ReturnValue := FIBsonBuffer.appendSymbol(Name, Value);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEqualsString(Value, b.Value(Name), 'Symbol value doesn''t match');
end;

procedure TestIBsonBuffer.TestappendBinary;
const
  AData : array [0..15] of Byte = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
var
  Name: UTF8String;
  b : IBson;
  it : IBsonIterator;
begin
  Name := 'BINFLD';
  Check(FIBsonBuffer.appendBinary(Name, BSON_SUBTYPE_BINARY, @AData, sizeof(AData)));
  b := FIBsonBuffer.finish;
  it := b.iterator;
  Check(it.next);
  Check(CompareMem(@AData, it.asBinary.getData, sizeof(AData)));
end;

procedure TestIBsonBuffer.TestappendCode_n;
var
  ReturnValue: Boolean;
  Value: UTF8String;
  Name: UTF8String;
  b : IBson;
  i : IBsonIterator;
begin
  Name := 'CODEFLD';
  Value := '123';
  ReturnValue := FIBsonBuffer.appendCode_n(Name, Value, 3);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  i := b.iterator;
  Check(i.next);
  CheckEqualsString('123', i.asCode, 'Code should be equals to "123"');
end;

procedure TestIBsonBuffer.TestAppendElementsAsArrayOfConst;
var
  Obj : IBson;
  variant_val : Variant;
  val_extended : Extended;
  val_currency : Currency;
begin
  variant_val := 1234;
  val_extended := 1.1;
  val_currency := 1.2;
  Check(FIBsonBuffer.appendElementsAsArray(['int_fld', 1,
                                            WideString('int_fld_wide'), 1,
                                            ShortString('int_fld_string'), 1,
                                            AnsiChar('i'), 1,
                                            WideChar('w'), 1,
                                            PAnsiChar('int_fld_pchar'), 1,
                                            {$IFDEF DELPHI2009}
                                            PWideChar('int_fld_pwidechar'), 1,
                                            UnicodeString('int_fld_unicodestring'), 1,
                                            {$ENDIF}
                                            'bool_fld', True,
                                            'ansichar_fld', AnsiChar('a'),
                                            'extended_fld', val_extended,
                                            'pansichar_fld', PAnsiChar('pansichar_val'),
                                            'widechar_fld', WideChar('v'),
                                            {$IFDEF DELPHI2009}
                                            'pwidechar_fld', PWideChar('pwidechar_val'),
                                            {$ENDIF}
                                            'ansistring_fld', UTF8String('ansistring_val'),
                                            'string_fld', ShortString('string_val'),
                                            'currency_fld', val_currency,
                                            'variant_fld', variant_val,
                                            'widestring_fld', WideString('widestring_val'),
                                            'int64_fld', Int64(10000000000)
                                            {$IFDEF DELPHI2009}
                                            , 'unicode_fld', UnicodeString('unicode_val') {$ENDIF}]), 'call to appendElementsAsArray should return true');
  Obj := FIBsonBuffer.finish;
  CheckObjectWithAppendedElements(Obj);
end;

procedure TestIBsonBuffer.TestAppendElementsAsArraySubObjects;
var
  Obj : IBson;
  it : IBsonIterator;
begin
  Check(FIBsonBuffer.appendElementsAsArray(['int', 1, 'sub_obj',
                                            Start_Object, 'str', 'string',
                                                 'int_2', 2, End_Object]), 'Call t appendElementsAsArray failed');
  Obj := FIBsonBuffer.finish;
  CheckEquals(1, Obj.value('int'), 'Value of int doesn''t match');
  it := Obj.find('sub_obj');
  Check(it <> nil, 'iterator sub_obj should be <> nil');
  it := it.subiterator;
  Check(it.next, 'first call to it.next should return true');
  Check(it <> nil, 'subiterator of sub_obj should be <> nil');
  CheckEqualsString('str', it.key, 'first key value of subobject doesn''t match');
  CheckEqualsString('string', it.value, 'value of key subobject attribute doesn''t match');
  Check(it.next, 'call to it.next should return value <> nil');
  CheckEqualsString('int_2', it.key, 'first key value of subobject doesn''t match');
  CheckEquals(2, it.value, 'value of key subobject attribute doesn''t match');
end;

procedure TestIBsonBuffer.TestAppendElementsAsArrayArray;
var
  Obj : IBson;
  it : IBsonIterator;
  SubIt : IBsonIterator;
begin
  Check(FIBsonBuffer.appendElementsAsArray(['int', 1, 'sub_array',
                                            Start_Array, 'element 1', 'element 2', 'subobject',
                                                                             Start_Object,
                                                                             's', 'Str', End_Object,
                                             3, 4, 'final_obj', Start_Object, 'subarr', Start_Array, '10', '20', End_Array, End_Object, End_Array]), 'Call t appendElementsAsArray failed');
  Obj := FIBsonBuffer.finish;
  CheckEquals(1, Obj.value('int'), 'Value of int doesn''t match');
  it := Obj.find('sub_array');
  Check(it <> nil, 'iterator sub_obj should be <> nil');
  it := it.subiterator;
  Check(it.next, 'first call to it.next should return true');
  Check(it <> nil, 'subiterator of sub_array should be <> nil');
  CheckEqualsString('element 1', it.value, 'first value of array doesn''t match');
  Check(it.next, 'call to it.next should return true');
  CheckEqualsString('element 2', it.value, 'second value of array doesn''t match');
  Check(it.next, 'call to it.next should return value <> nil');
  SubIt := it.subiterator;
  Check(SubIt <> nil, 'Sub iterator should be <> nil');
  Check(SubIt.next, 'call to SubIt.next should return true');
  CheckEqualsString('s', SubIt.key, 'key of first element of subobject should be s');
  CheckEqualsString('Str', SubIt.value, 'value of first attribute of subobject should be Str');
  Check(it.next, 'call to it.next should return true');
  CheckEquals(3, it.value, 'third value of array doesn''t match');
  Check(it.next, 'call to it.next should return true');
  CheckEquals(4, it.value, 'fourth value of array doesn''t match');
  Check(it.next, 'call to it.next should return true');
  SubIt := it.subiterator;
  Check(SubIt <> nil, 'call to subiterator should be <> nil');
  Check(SubIt.next, 'first call to SubIt.next should be true');
  CheckEqualsString('subarr', SubIt.key, 'first key of SubIt doesn''t match');
  SubIt := SubIt.subiterator;
  Check(SubIT <> nil, 'SubIterator of subiterator should be <> nil');
  Check(SubIt.next, 'first call to subit.next should be true');
  CheckEquals(10, SubIt.value, 'First value of last array should be 10');
  Check(SubIt.next, 'second call of subit.next should for last array should be true');
  CheckEquals(20, SubIt.value, 'Last element of subarray should be 20');
  Check(not SubIt.next, 'Call to SubIt.next after last element should be false');
end;

procedure TestIBsonBuffer.TestAppendElementsAsVarRecArray;
const
  int_fld : UTF8String = 'int_fld';
  int_fld_wide : WideString = 'int_fld_wide';
  int_fld_string : ShortString = 'int_fld_string';
  int_fld_char : AnsiChar = 'i';
  int_fld_WideChar : WideChar = 'w';
  int_fld_pchar : PAnsiChar = 'int_fld_pchar';
  int_fld_PWideChar : PWideChar = 'int_fld_pwidechar';
  {$IFDEF DELPHI2009}
  int_fld_UnicodeString : UnicodeString = 'int_fld_unicodestring';
  {$ENDIF}
  bool_fld : UTF8String = 'bool_fld';
  ansichar_fld : UTF8String = 'ansichar_fld';
  extended_fld : UTF8String = 'extended_fld';
  extended_value : Extended = 1.1;
  pansichar_fld : UTF8String = 'pansichar_fld';
  pansichar_val : PAnsiChar = 'pansichar_val';
  widechar_fld : UTF8String = 'widechar_fld';
  widechar_val : WideChar = 'v';
  pwidechar_fld : UTF8String = 'pwidechar_fld';
  pwidechar_val : PWideChar = 'pwidechar_val';
  ansistring_fld : UTF8String = 'ansistring_fld';
  ansistring_val : UTF8String = 'ansistring_val';
  string_fld : UTF8String = 'string_fld';
  string_val : ShortString = 'string_val';
  currency_fld : UTF8String = 'currency_fld';
  currency_val : currency = 1.2;
  variant_fld : UTF8String = 'variant_fld';
  widestring_fld : UTF8String = 'widestring_fld';
  widestring_val : WideString = 'widestring_val';
  int64_fld : UTF8String = 'int64_fld';
  int64_val : Int64 = 10000000000;
  unicode_fld : UTF8String = 'unicode_fld';
  {$IFDEF DELPHI2009}
  unicode_val : UnicodeString = 'unicode_val';
  {$ENDIF}
var
  Def : TVarRecArray;
  Obj : IBson;
  variant_val : Variant;
  procedure PrepareDifferentFieldTypeTests;
  begin
    // Field as UTF8String
    Def[0].VType := vtAnsiString;
    Def[0].VAnsiString := pointer(int_fld);
    Def[1].VType := vtInteger;
    Def[1].VInteger := 1;
    // Field as WideString
    Def[2].VType := vtWideString;
    Def[2].VWideString := pointer(int_fld_wide);
    Def[3].VType := vtInteger;
    Def[3].VInteger := 1;
    // Field as ShortString
    Def[4].VType := vtString;
    Def[4].VString := @int_fld_string;
    Def[5].VType := vtInteger;
    Def[5].VInteger := 1;
    // Field as Char
    Def[6].VType := vtChar;
    Def[6].VChar := int_fld_char;
    Def[7].VType := vtInteger;
    Def[7].VInteger := 1;
    // Field as WideChar
    Def[8].VType := vtWideChar;
    Def[8].VWideChar := int_fld_widechar;
    Def[9].VType := vtInteger;
    Def[9].VInteger := 1;
    // Field as PAnsiChar
    Def[10].VType := vtPChar;
    Def[10].VPChar := int_fld_pchar;
    Def[11].VType := vtInteger;
    Def[11].VInteger := 1;
    // Field as PWideChar
    Def[12].VType := vtPWideChar;
    Def[12].VPWideChar := int_fld_PWideChar;
    Def[13].VType := vtInteger;
    Def[13].VInteger := 1;
    {$IFDEF DELPHI2009}
    // Field as UnicodeString
    Def[14].VType := vtUnicodeString;
    Def[14].VUnicodeString := pointer(int_fld_UnicodeString);
    Def[15].VType := vtInteger;
    Def[15].VInteger := 1;
    {$ELSE}
    Def[14].VType := vtWideString;
    Def[14].VWideString := pointer(int_fld_wide);
    Def[15].VType := vtInteger;
    Def[15].VInteger := 1;
    {$ENDIF}
  end;
  procedure PrepareDifferentValueTypesTests;
  begin
    // Value as Boolean
    Def[16].VType := vtAnsiString;
    Def[16].VAnsiString := pointer(bool_fld);
    Def[17].VType := vtBoolean;
    Def[17].VBoolean := True;
    // Value as AnsiChar
    Def[18].VType := vtAnsiString;
    Def[18].VAnsiString := pointer(ansichar_fld);
    Def[19].VType := vtChar;
    Def[19].VChar := 'a';
    // Value as Extended
    Def[20].VType := vtAnsiString;
    Def[20].VAnsiString := pointer(extended_fld);
    Def[21].VType := vtExtended;
    Def[21].VExtended := @extended_value;
    // Value as PChar
    Def[22].VType := vtAnsiString;
    Def[22].VAnsiString := pointer(pansichar_fld);
    Def[23].VType := vtPChar;
    Def[23].VPChar := pansichar_val;
    // Value as WideChar
    Def[24].VType := vtAnsiString;
    Def[24].VAnsiString := pointer(widechar_fld);
    Def[25].VType := vtWideChar;
    Def[25].VWideChar := widechar_val;
    // Value as PWideChar
    Def[26].VType := vtAnsiString;
    Def[26].VAnsiString := pointer(pwidechar_fld);
    Def[27].VType := vtPWideChar;
    Def[27].VPWideChar := pwidechar_val;
    // Value as UTF8String
    Def[28].VType := vtAnsiString;
    Def[28].VAnsiString := pointer(ansistring_fld);
    Def[29].VType := vtAnsiString;
    Def[29].VAnsiString := pointer(ansistring_val);
    // Value as shortstring
    Def[30].VType := vtAnsiString;
    Def[30].VAnsiString := pointer(string_fld);
    Def[31].VType := vtString;
    Def[31].VString := @string_val;
    // Value as currency
    Def[32].VType := vtAnsiString;
    Def[32].VAnsiString := pointer(currency_fld);
    Def[33].VType := vtCurrency;
    Def[33].VCurrency := @currency_val;
    // Value as variant
    Def[34].VType := vtAnsiString;
    Def[34].VAnsiString := pointer(variant_fld);
    Def[35].VType := vtVariant;
    Def[35].VVariant := @variant_val;
    // Value as Widestring
    Def[36].VType := vtAnsiString;
    Def[36].VAnsiString := pointer(widestring_fld);
    Def[37].VType := vtWideString;
    Def[37].VWideString := pointer(widestring_val);
    // Value as Int64
    Def[38].VType := vtAnsiString;
    Def[38].VAnsiString := pointer(int64_fld);
    Def[39].VType := vtInt64;
    Def[39].VInt64 := @int64_val;
    {$IFDEF DELPHI2009}
    // Value as UnicodeString
    Def[40].VType := vtAnsiString;
    Def[40].VAnsiString := pointer(unicode_fld);
    Def[41].VType := vtUnicodeString;
    Def[41].VInt64 := pointer(unicode_val);
    {$ENDIF}
  end;
begin
  variant_val := 1234;
  SetLength(Def, {$IFDEF DELPHI2009} 42 {$ELSE} 40 {$ENDIF});
  PrepareDifferentFieldTypeTests;
  PrepareDifferentValueTypesTests;
  Check(FIBsonBuffer.appendElementsAsArray(Def), 'call to appendElementsAsArray should return true');
  Obj := FIBsonBuffer.finish;
  CheckObjectWithAppendedElements(Obj);
end;

procedure TestIBsonBuffer.TestAppendElementsAsArrayWithErrors;
const
  fld : UTF8String = 'fld';
  int_val : Integer = 0;
var
  Def : TVarRecArray;
begin
  SetLength(Def, 2);
  Def[0].VType := vtInteger;
  Def[0].VAnsiString := @int_val;
  Def[1].VType := vtAnsiString;
  Def[1].VAnsiString := @fld;
  try
    FIBsonBuffer.appendElementsAsArray(Def);
    Fail('call to appendElementsAsArray should have raise exception');
  except
    on E : EBson do CheckEquals(E_ExpectedDefElementShouldBeAString, E.ErrorCode, 'appendElementsAsArray should have raised exception. error: ' + E.Message);
  end;

  SetLength(Def, 2);
  Def[0].VType := vtAnsiString;
  Def[0].VAnsiString := @fld;
  Def[1].VType := vtInterface;
  Def[1].VInterface := nil;
  try
    FIBsonBuffer.appendElementsAsArray(Def);
    Fail('call to appendElementsAsArray should have raise exception');
  except
    on E : EBson do CheckEquals(E_NilInterfacePointerNotSupported, E.ErrorCode, 'appendElementsAsArray should have raised exception. error: ' + E.Message);
  end;

  SetLength(Def, 0);
  try
    FIBsonBuffer.appendElementsAsArray(Def);
    Fail('call to appendElementsAsArray should have raise exception');
  except
    on E : EBson do CheckEquals(E_DefMustContainAMinimumOfTwoElements, E.ErrorCode, 'appendElementsAsArray should have raised exception. error: ' + E.Message);
  end;
end;

procedure TestIBsonBuffer.TestAppendStr_n;
var
  ReturnValue: Boolean;
  Value: UTF8String;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'STRFLD';
  Value := 'STRVAL';
  ReturnValue := FIBsonBuffer.AppendStr_n(Name, Value, 3);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEqualsString('STR', b.Value('STRFLD'), 'field on BSon object doesn''t match expected value');
end;

procedure TestIBsonBuffer.TestappendSymbol_n;
var
  ReturnValue: Boolean;
  Value: UTF8String;
  Name: UTF8String;
  b : IBson;
begin
  Name := 'SYMFLD';
  Value := 'SymbolTest';
  ReturnValue := FIBsonBuffer.appendSymbol_n(Name, Value, 3);
  Check(ReturnValue, 'ReturnValue should be True');
  b := FIBsonBuffer.finish;
  CheckEqualsString('Sym', b.Value(Name), 'Symbol value doesn''t match');
end;

procedure TestIBsonBuffer.TeststartObject;
var
  ReturnValue: Boolean;
  Name: UTF8String;
  b : IBson;
  it : IBsonIterator;
begin
  Name := 'OBJ';
  ReturnValue := FIBsonBuffer.startObject(Name);
  Check(ReturnValue, 'ReturnValue should be True');
  Check(FIBsonBuffer.AppendStr('STRFLD', 'STRVAL'), 'Call to AppendStr should return true');
  Check(FIBsonBuffer.Append('INTFLD', 1), 'Call to Append should return true');
  Check(FIBsonBuffer.finishObject, 'Call to FIBsonBuffer.finishObjects should return true');
  b := FIBsonBuffer.finish;
  it := b.iterator;
  Check(it <> nil, 'Call to subiterator should be  <> nil');
  it.Next;
  it := it.subiterator;
  Check(it <> nil, 'Call to subiterator should be  <> nil');
  it.Next;
  CheckEqualsString('STRVAL', it.Value, 'STRFLD should be equals to STRVAL');
  it.Next;
  CheckEquals(1, it.Value, 'INTFLD should be equals to 1');
end;

procedure TestIBsonBuffer.TeststartArray;
var
  ReturnValue: Boolean;
  Name: UTF8String;
  b : IBson;
  it : IBsonIterator;
  Arr : TIntegerArray;
begin
  Name := 'ARR';
  ReturnValue := FIBsonBuffer.startArray(Name);
  Check(ReturnValue, 'ReturnValue should be True');
    Check(FIBsonBuffer.Append('0', 10), 'Call to Append should return True');
    Check(FIBsonBuffer.Append('0', 20), 'Call to Append should return True');
    Check(FIBsonBuffer.Append('0', 30), 'Call to Append should return True');
  FIBsonBuffer.finishObject;
  b := FIBsonBuffer.finish;
  it := b.iterator;
  it.Next;
  Arr := it.asIntegerArray;
  CheckEquals(3, length(Arr), 'Array should contain three elements');
  CheckEquals(10, Arr[0], 'First element of array should be equals to 10');
  CheckEquals(20, Arr[1], 'First element of array should be equals to 20');
  CheckEquals(30, Arr[2], 'First element of array should be equals to 30');
end;

procedure TestIBsonBuffer.Testsize;
var
  InitialSize : Integer;
  ReturnValue: Integer;
begin
  InitialSize := FIBsonBuffer.size;
  CheckNotEquals(0, InitialSize, 'Initial value of Bson buffer should be different from zero');
  FIBsonBuffer.AppendStr('STR', 'VAL');
  ReturnValue := FIBsonBuffer.size;
  Check(ReturnValue > InitialSize, 'After inserting an element on Bson buffer size should be larger than initial size');
end;

{ TestIBsonIterator }

type
  PBinData = ^TBinData;
  TBinData = array [0..15] of Byte;

const
  ABinData : TBinData = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);

procedure TestIBsonIterator.SetUp;
var
  Buf : IBsonBuffer;
  i : integer;
begin
  Buf := NewBsonBuffer;
  Buf.AppendStr('STR', 'STRVAL');
  Buf.Append('Integer', Low(Integer));
  Buf.Append('Integer', High(Integer));
  Buf.Append('INT64', Low(Int64));
  Buf.Append('INT64', High(Int64));
  Buf.AppendStr('UTF8String', 'jステステl');
  // delphi5 MaxDouble constant is not strict value
  Buf.Append('Double', {$IFDEF DELPHIXE4}MaxDouble{$ELSE}1.7976931348623157081e+308{$ENDIF});
  Buf.Append('Double', {$IFDEF DELPHIXE4}MaxDouble{$ELSE}4.9406564584124654418e-324{$ENDIF});
  Buf.appendDate('DateTime', MinDateTime);
  FNow := Now;
  Buf.appendDate('DateTime', FNow);
  Buf.Append('Boolean', true);
  Buf.Append('Boolean', false);
  Buf.appendBinary('BIN', BSON_SUBTYPE_BINARY, @ABinData, sizeof(ABinData));
  SetLength(BoolArr, 2);
  BoolArr[0] := False;
  BoolArr[1] := True;
  Buf.appendArray('BOOLARR', BoolArr);
  Buf.appendCode('CODE', '123456');
  Buf.appendCodeWithScope('CODE_SCOPE', '666', BSON(['a', 1, 'b', 'c']));
  SetLength(DblArr, 5);
  for I := low(DblArr) to high(DblArr) do
    DblArr[i] := i + 0.5;
  Buf.appendArray('DBLARR', DblArr);
  SetLength(IntArr, 5);
  for i := low(IntArr) to high(IntArr) do
    IntArr[i] := i;
  Buf.appendArray('INTARR', IntArr);
  BsonOID := NewBsonOID;
  Buf.Append('BSONOID', BsonOID);
  BsonRegEx := NewBsonRegEx('123', '456');
  Buf.Append('BSONREGEX', BsonRegEx);
  SetLength(StrArr, 5);
  for I := low(StrArr) to high(StrArr) do
    StrArr[i] := IntToStr(i);
  Buf.appendArray('STRARR', StrArr);
  FTimeStamp := NewBsonTimestamp(DateTimeToUnix(Now), 0);
  Buf.append('TS', FTimeStamp);
  bb := BSON(['SUBINT', 123]);
  Buf.Append('SUBOBJ', bb);
  b := Buf.finish;
end;

procedure TestIBsonIterator.TearDown;
begin
  FIBsonIterator := nil;
  b := nil;
  bb := nil;
  BsonOID := nil;
  BsonRegEx := nil;
  FTimestamp := nil;
  BoolArr := nil;
  DblArr := nil;
  IntArr := nil;
  StrArr := nil;
  inherited;
end;

procedure TestIBsonIterator.TestAsInteger;
begin
  FIBsonIterator := b.find('Integer');
  CheckEquals(Low(Integer), FIBsonIterator.AsInteger);
  FIBsonIterator.Next;
  CheckEquals(High(Integer), FIBsonIterator.AsInteger);
end;

procedure TestIBsonIterator.TestAsInt64;
begin
  FIBsonIterator := b.find('INT64');
  CheckEquals(Low(Int64), FIBsonIterator.AsInt64);
  FIBsonIterator.Next;
  CheckEquals(High(Int64), FIBsonIterator.AsInt64);
end;

procedure TestIBsonIterator.TestAsUTF8String;
begin
  FIBsonIterator := b.find('UTF8String');
  CheckEqualsString('jステステl', FIBsonIterator.AsUTF8String, 'Should return jステステl');
end;

procedure TestIBsonIterator.TestAsDouble;
begin
  FIBsonIterator := b.find('Double');
  CheckEquals({$IFDEF DELPHIXE4}MaxDouble{$ELSE}1.7976931348623157081e+308{$ENDIF}, FIBsonIterator.AsDouble);
  FIBsonIterator.Next;
  CheckEquals({$IFDEF DELPHIXE4}MaxDouble{$ELSE}4.9406564584124654418e-324{$ENDIF}, FIBsonIterator.AsDouble);
end;

procedure TestIBsonIterator.TestAsDateTime;
begin
  FIBsonIterator := b.find('DateTime');
  CheckEquals(MinDateTime, FIBsonIterator.AsDateTime, DATE_TIME_EPSILON);
  FIBsonIterator.Next;
  CheckEquals(FNow, FIBsonIterator.AsDateTime, DATE_TIME_EPSILON);
end;

procedure TestIBsonIterator.TestAsBoolean;
begin
  FIBsonIterator := b.find('Boolean');
  CheckEquals(true, FIBsonIterator.AsBoolean);
  FIBsonIterator.Next;
  CheckEquals(false, FIBsonIterator.AsBoolean);
end;

procedure TestIBsonIterator.TestgetHandle;
var
  ReturnValue: Pointer;
begin
  FIBsonIterator := b.find('Integer');
  ReturnValue := FIBsonIterator.getHandle;
  CheckNotEquals(0, integer(ReturnValue), 'Call to FIBsonIterator.getHandle should return value <> nil');
end;

procedure TestIBsonIterator.TestgetBinary;
var
  ReturnValue: IBsonBinary;
  i : integer;
begin
  FIBsonIterator := b.find('BIN');
  ReturnValue := FIBsonIterator.asBinary;
  for i := low(ABinData) to high(ABinData) do
    CheckEquals(ABinData[i], PBinData(ReturnValue.getData)^[i], 'Binary data doesn''t match');
end;

procedure TestIBsonIterator.TestgetBooleanArray;
var
  ReturnValue: TBooleanArray;
begin
  FIBsonIterator := b.find('BOOLARR');
  ReturnValue := FIBsonIterator.asBooleanArray;
  CheckEquals(length(BoolArr), length(ReturnValue), 'Boolean array size doesn''t match');
  CheckEquals(BoolArr[0], ReturnValue[0], 'First element of boolean array doesn''t match');
  CheckEquals(BoolArr[1], ReturnValue[1], 'First element of boolean array doesn''t match');
end;

procedure TestIBsonIterator.TestgetCodeWScope;
var
  ReturnValue: IBsonCodeWScope;
begin
  FIBsonIterator := b.find('CODE_SCOPE');
  ReturnValue := FIBsonIterator.asCodeWScope;
  Check(ReturnValue <> nil, 'BsonCodeWScope object should be <> nil');
  CheckEqualsString('666', ReturnValue.getCode, 'Code doesn''t match');
  CheckEqualsString('{ "a" : 1, "b" : "c" }', ReturnValue.Scope.asJson);
end;

procedure TestIBsonIterator.TestgetDoubleArray;
var
  ReturnValue: TDoubleArray;
  i : integer;
begin
  FIBsonIterator := b.find('DBLARR');
  ReturnValue := FIBsonIterator.asDoubleArray;
  for i := low(DblArr) to high(DblArr) do
    CheckEquals(DblArr[i], ReturnValue[i], 'Double array element doesn''t match');
end;

procedure TestIBsonIterator.TestgetIntegerArray;
var
  ReturnValue : TIntegerArray;
  i : integer;
begin
  FIBsonIterator := b.find('INTARR');
  ReturnValue := FIBsonIterator.asIntegerArray;
  for i := low(IntArr) to high(IntArr) do
    CheckEquals(IntArr[i], ReturnValue[i], 'Integer array element doesn''t match');
end;

procedure TestIBsonIterator.TestgetOID;
var
  ReturnValue: IBsonOID;
begin
  FIBsonIterator := b.find('BSONOID');
  ReturnValue := FIBsonIterator.asOID;
  CheckEqualsString(BsonOID.AsString, ReturnValue.AsString, 'BsonOID doesn''t match');
end;

procedure TestIBsonIterator.TestgetRegex;
var
  ReturnValue: IBsonRegex;
begin
  FIBsonIterator := b.find('BSONREGEX');
  ReturnValue := FIBsonIterator.asRegex;
  CheckEqualsString(BsonRegEx.getPattern, ReturnValue.getPattern, 'Pattern of RegEx doesn''t match');
  CheckEqualsString(BsonRegEx.getOptions, ReturnValue.getOptions, 'Options of RegEx doesn''t match');
end;

procedure TestIBsonIterator.TestgetStringArray;
var
  ReturnValue: TStringArray;
  i : integer;
begin
  FIBsonIterator := b.find('STRARR');
  ReturnValue := FIBsonIterator.asStringArray;
  for i := low(StrArr) to high(StrArr) do
    CheckEqualsString(StrArr[i], ReturnValue[i], 'UTF8String array element doesn''t match');
end;

procedure TestIBsonIterator.TestgetTimestamp;
var
  ReturnValue: IBsonTimestamp;
begin
  FIBsonIterator := b.find('TS');
  ReturnValue := FIBsonIterator.asTimestamp;
  CheckEquals(FTimeStamp.getTime, ReturnValue.getTime, 'Timestamp date field doesn''t match');
  CheckEquals(FTimeStamp.getIncrement, ReturnValue.getIncrement, 'Timestamp increment field doesn''t match');
end;

procedure TestIBsonIterator.Testkey;
var
  ReturnValue: UTF8String;
begin
  FIBsonIterator := b.iterator;
  FIBsonIterator.next;
  ReturnValue := FIBsonIterator.key;
  CheckEqualsString('STR', ReturnValue, 'Key of first iterator element should be equals to STR');
  FIBsonIterator := b.find('TS');
  ReturnValue := FIBsonIterator.key;    
  CheckEqualsString('TS', ReturnValue, 'Key of last iterator element should be equals to TS');
end;

procedure TestIBsonIterator.TestKind;
var
  ReturnValue: TBsonType;
begin
  FIBsonIterator := b.iterator;
  FIBsonIterator.next;

  ReturnValue := FIBsonIterator.Kind;
  CheckEquals(integer(BSON_TYPE_UTF8), integer(ReturnValue), 'First element returned by iterator should be bsonSTRING');
  FIBsonIterator.Next;
  FIBsonIterator.Next;
  ReturnValue := FIBsonIterator.Kind;
  CheckEquals(integer(BSON_TYPE_INT32), integer(ReturnValue), 'Second element returned by iterator should be bsonINT');
  FIBsonIterator.Next;
  FIBsonIterator.Next;
  ReturnValue := FIBsonIterator.Kind;
  CheckEquals(integer(BSON_TYPE_INT64), integer(ReturnValue), 'Third element returned by iterator should be bsonLONG');
end;

procedure TestIBsonIterator.TestTryToReadPastEnd;
begin
  FIBsonIterator := b.find('SUBOBJ');
  while FIBsonIterator.Next do;
    FIBsonIterator.Kind;
  CheckFalse(FIBsonIterator.Next);
  Check(BSON_TYPE_EOD = FIBsonIterator.Kind);
end;

procedure TestIBsonIterator.Testsubiterator;
var
  ReturnValue: IBsonIterator;
begin
  FIBsonIterator := b.find('SUBOBJ');
  ReturnValue := FIBsonIterator.subiterator;
  Check(ReturnValue <> nil, 'FIBsonIterator.subiterator should be different from nil');
  ReturnValue.Next;
  CheckEquals(123, integer(ReturnValue.Value), 'Value of subiterator should be equals to 123');
end;

procedure TestIBsonIterator.TestSubiteratorDotNotationSubDoc;
begin
  b := BSON(['root', '{', 'sub', 5, '}']);
  FIBsonIterator := b.iterator.subiterator('root.sub');
  Check(FIBsonIterator <> nil);
  CheckEqualsString('sub', FIBsonIterator.key);
  CheckEquals(5, FIBsonIterator.AsInteger);
end;

procedure TestIBsonIterator.TestSubiteratorDotNotationArray;
begin
  b := BSON(['root', '{', 'arr', '[', '{', 'a', 1, '}', '{', 'b', 2, '}', ']', '}']);
  FIBsonIterator := b.find('root.arr.1.b');
  Check(FIBsonIterator <> nil);
  CheckEquals(2, FIBsonIterator.AsInteger);
end;

procedure TestIBsonIterator.TestValue;
var
  ReturnValue: Variant;
begin
  FIBsonIterator := b.iterator;
  FIBsonIterator.next;

  ReturnValue := FIBsonIterator.Value;
  CheckEqualsString('STRVAL', ReturnValue, 'ReturnValue should be equals to STRVAL');
end;

{ TestIBson }

procedure TestIBson.SetUp;
begin
  FIBson := BSON(['ID', 123, 'S', 'STR']);
end;

procedure TestIBson.TearDown;
begin
  FIBson := nil;
  inherited;
end;

procedure TestIBson.TestComplexBson;
var
  b : IBson;
  it, it2 : IBsonIterator;
begin
  b := BSON(['a', 1, 'b', '123', 'subobj', '{', 'c', 3, 'd', '456', '}']);
  Check(b <> nil);
  it := b.iterator;
  Check(it <> nil);
  Check(it.next);
  CheckEqualsString('a', it.key);
  CheckEquals(1, it.value);
  Check(it.next);
  CheckEqualsString('b', it.key);
  CheckEqualsString('123', it.value);
  Check(it.next);
  it2 := it.subiterator;
  Check(it2 <> nil);
  Check(it2.next);
  CheckEqualsString('c', it2.key);
  CheckEquals(3, it2.value);
  Check(it2.next);
  CheckEqualsString('d', it2.key);
  CheckEqualsString('456', it2.value);
  Check(not it2.next);
  Check(not it.next);
end;

procedure TestIBson.TestCreateFromJson;
const
  TestJson : PAnsiChar = '{ "str" : "the value" }';
  BadJson : PAnsiChar = '{ str : "the value" }';
var
  b : IBson;
  it : IBsonIterator;
begin
  b := NewBson(UTF8String(TestJson));
  it := b.find('str');
  Check(it <> nil, 'attribute str not found');
  CheckEqualsString('the value', it.value, 'value doesn''t match');

  try
    b := NewBson(UTF8String(BadJson));
    Fail('Call should have failed');
  except
    on E : EBson do Check(pos('Failed creating BSON from JSON', E.Message) = 1);
  end;
end;

procedure TestIBson.TestAsJson;
var
  b : IBson;
  s : string;
begin
  b := BSON(['ID', 123, 'S', 'STR']);
  s := b.asJson;
  CheckEqualsString('{ "ID" : 123, "S" : "STR" }', s);
end;

procedure TestIBson.Testfind;
var
  ReturnValue: IBsonIterator;
  Name: UTF8String;
begin
  Name := 'S';
  ReturnValue := FIBson.find(Name);
  Check(ReturnValue <> nil, 'Call to FIBson.Find should have returned an iterator');
  CheckEqualsString('STR', ReturnValue.Value, 'Iterator.Value should have returned STR');
end;

procedure TestIBson.Testiterator;
var
  ReturnValue: IBsonIterator;
begin
  ReturnValue := FIBson.iterator;
  Check(ReturnValue <> nil, 'Call to get Bson iterator should have returned value <> nil');
  ReturnValue.Next;
  CheckEquals(123, ReturnValue.Value, 'Initial value of iterator is 123');
end;

procedure TestIBson.TestMkVarRecArrayFromVarArray;
const
  ExtendedVal : Extended = 1.1;
  CurrencyVal : Currency = 1.2;
var
  VarArr : array of variant;
  Arr : TVarRecArray;
  d : TDateTime;
begin
  SetLength(VarArr, 8);
  VarArr[0] := 1;
  {$IFDEF DELPHI2009}
  VarArr[1] := UnicodeString('Hello');
  {$ELSE}
  VarArr[1] := Null;
  {$ENDIF}
  VarArr[2] := ExtendedVal;
  VarArr[3] := CurrencyVal;
  d := Now;
  VarArr[4] := d;
  VarArr[5] := True;
  {$IFDEF DELPHI2009}
  VarArr[6] := Int64(123);
  {$ELSE}
  VarArr[6] := Null;
  {$ENDIF}
  VarArr[7] := AnsiString('Alo');
  Arr := MkBSONVarRecArrayFromVarArray(VarArr, NewPrimitiveAllocator);
  try
    CheckEquals(8, length(Arr), 'Length of Arr doesn''t match');
    CheckEquals(vtInteger, Arr[0].VType, 'Type of first parameter doesn''t match');
    CheckEquals(1, Arr[0].VInteger, 'First value of Arr doesn''t match');
    {$IFDEF DELPHI2009}
    CheckEquals(vtUnicodeString, Arr[1].VType, 'Type of second parameter doesn''t match');
    CheckEqualsString('Hello', UnicodeString(Arr[1].VUnicodeString), 'Second value of arr doesn''t match');
    {$ENDIF}
    CheckEquals(vtExtended, Arr[2].VType, 'Type of third parameter doesn''t match');
    CheckEqualsString(Format('%.2g', [1.1]), Format('%.2g', [Arr[2].VExtended^]), 'Third parameter doesn''t match');
    CheckEquals({$IFDEF DELPHI2009} vtCurrency {$ELSE} vtExtended {$ENDIF}, Arr[3].VType, 'Type of fourth parameter doesn''t match');
    CheckEqualsString(Format('%.2g', [1.2]), Format('%.2g', [{$IFDEF DELPHI2009} Arr[3].VCurrency^ {$ELSE} Arr[3].VExtended^ {$ENDIF}]), 'Fourth parameter doesn''t match');
    CheckEquals(vtExtended, Arr[4].VType, 'Type of fifth array element doesn''t match');
    CheckEqualsString(DateTimeToStr(d), DateTimeToStr(Arr[4].VExtended^), 'Firth element doesn''t match');
    CheckEquals(vtBoolean, Arr[5].VType, 'Type of sixth parameter doesn''t match');
    CheckEquals(True, Arr[5].VBoolean, 'Sixth value of Arr doesn''t match');
    {$IFDEF DELPHI2009}
    CheckEquals(vtInt64, Arr[6].VType, 'Type of seventh parameter doesn''t match');
    CheckEquals(123, Arr[6].VInt64^, 'Seventh value of Arr doesn''t match');
    {$ENDIF}
    CheckEquals(vtAnsiString, Arr[7].VType, 'Type of eigth parameter doesn''t match');
    CheckEqualsString('Alo', AnsiString(Arr[7].VAnsiString), 'Eigth value of arr doesn''t match');
  finally
    CleanVarRecArray(Arr);
  end;
end;

procedure TestIBson.TestNewBsonCopy;
var
  ACopy : IBson;
begin
  ACopy := NewBsonCopy(FIBson);
  CheckEquals(123, ACopy.find('ID').value);
  CheckEqualsString('STR', ACopy.find('S').value);
end;

procedure TestIBson.TestSimpleBSON;
var
  AObj : IBSON;
begin
  AObj := BSON(['a', 1]);
  Check(AObj <> nil, 'BSON object should be <> nil');
end;

procedure TestIBson.Testsize;
var
  ReturnValue: Integer;
begin
  ReturnValue := FIBson.size;
  CheckNotEquals(0, ReturnValue, 'Call to FIBson.Size should return value <> zero');
end;

procedure TestIBson.TestValue;
var
  ReturnValue: Variant;
  Name: UTF8String;
begin
  Name := 'ID';
  ReturnValue := FIBson.Value(Name);
  CheckEquals(123, ReturnValue, 'ReturnValue should be equals to 123');
end;

{ TestArrayBuildingFunctions }

procedure TestArrayBuildingFunctions.TestBuildIntArray;
var
  Arr : TIntegerArray;
begin
  Arr := MkIntArray([0, 1, 2]);
  CheckEquals(0, Arr[0], 'Arr[0] value doesn''t match');
  CheckEquals(1, Arr[1], 'Arr[1] value doesn''t match');
  CheckEquals(2, Arr[2], 'Arr[2] value doesn''t match');
end;


procedure TestArrayBuildingFunctions.TestBuildDoubleArray;
var
  Arr : TDoubleArray;
begin
  Arr := MkDoubleArray([0.1, 1.1, 2.1]);
  CheckEqualsString(FloatToStr(0.1), FloatToStr(Arr[0]), 'Arr[0] value doesn''t match');
  CheckEqualsString(FloatToStr(1.1), FloatToStr(Arr[1]), 'Arr[1] value doesn''t match');
  CheckEqualsString(FloatToStr(2.1), FloatToStr(Arr[2]), 'Arr[2] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestBuildBooleanArray;
var
  Arr : TBooleanArray;
begin
  Arr := MkBoolArray([True, False, True]);
  Check(Arr[0], 'Arr[0] value doesn''t match');
  Check(not Arr[1], 'Arr[1] value doesn''t match');
  Check(Arr[2], 'Arr[2] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestAppendToBooleanArray;
var
  Arr : TBooleanArray;
  procedure CheckFirstElements;
  begin
    Check(Arr[0], 'Arr[0] value doesn''t match');
    Check(not Arr[1], 'Arr[1] value doesn''t match');
    Check(Arr[2], 'Arr[2] value doesn''t match');
    Check(not Arr[3], 'Arr[3] value doesn''t match');
    Check(not Arr[4], 'Arr[4] value doesn''t match');
    Check(Arr[5], 'Arr[5] value doesn''t match');
    Check(Arr[6], 'Arr[6] value doesn''t match');
  end;
begin
  Arr := MkBoolArray([True, False, True]);
  AppendToBoolArray([False, False, True, True], Arr);
  CheckEquals(7, length(Arr), 'Length of modified array doesn''t match');
  CheckFirstElements;
  SetLength(Arr, 10);
  AppendToBoolArray([True, True, False], Arr, 7);
  CheckEquals(10, length(Arr), 'Length of modified array doesn''t match');
  CheckFirstElements;
  Check(Arr[7], 'Arr[7] value doesn''t match');
  Check(Arr[8], 'Arr[8] value doesn''t match');
  Check(not Arr[9], 'Arr[9] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestAppendToDoubleArray;
var
  Arr : TDoubleArray;
  procedure CheckFirstElements;
  begin
    CheckEqualsString(FloatToStr(0.1), FloatToStr(Arr[0]), 'Arr[0] value doesn''t match');
    CheckEqualsString(FloatToStr(1.1), FloatToStr(Arr[1]), 'Arr[1] value doesn''t match');
    CheckEqualsString(FloatToStr(2.1), FloatToStr(Arr[2]), 'Arr[2] value doesn''t match');
    CheckEqualsString(FloatToStr(2.2), FloatToStr(Arr[3]), 'Arr[3] value doesn''t match');
    CheckEqualsString(FloatToStr(2.3), FloatToStr(Arr[4]), 'Arr[4] value doesn''t match');
  end;
begin
  Arr := MkDoubleArray([0.1, 1.1, 2.1]);
  AppendToDoubleArray([2.2, 2.3], Arr);
  CheckFirstElements;
  SetLength(Arr, 7);
  AppendToDoubleArray([2.4, 2.5], Arr, 5);
  CheckEqualsString(FloatToStr(2.4), FloatToStr(Arr[5]), 'Arr[5] value doesn''t match');
  CheckEqualsString(FloatToStr(2.5), FloatToStr(Arr[6]), 'Arr[6] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestAppendToIntArray;
var
  Arr : TIntegerArray;
  procedure CheckFirstElements;
  begin
    CheckEquals(0, Arr[0], 'Arr[0] value doesn''t match');
    CheckEquals(1, Arr[1], 'Arr[1] value doesn''t match');
    CheckEquals(2, Arr[2], 'Arr[2] value doesn''t match');
    CheckEquals(5, Arr[3], 'Arr[3] value doesn''t match');
    CheckEquals(6, Arr[4], 'Arr[4] value doesn''t match');
  end;
begin
  Arr := MkIntArray([0, 1, 2]);
  AppendToIntArray([5, 6], Arr);
  CheckFirstElements;
  SetLength(Arr, 7);
  AppendToIntArray([7, 8], Arr, 5);
  CheckFirstElements;
  CheckEquals(7, Arr[5], 'Arr[5] value doesn''t match');
  CheckEquals(8, Arr[6], 'Arr[6] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestBuildStrArray;
var
  Arr : TStringArray;
begin
  Arr := MkStrArray(['Hello', 'How', 'Are']);
  CheckEqualsString('Hello', Arr[0], 'Arr[0] value doesn''t match');
  CheckEqualsString('How', Arr[1], 'Arr[1] value doesn''t match');
  CheckEqualsString('Are', Arr[2], 'Arr[2] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestAppendToStrArray;
var
  Arr : TStringArray;
  procedure CheckFirstElements;
  begin
    CheckEqualsString('Hello', Arr[0], 'Arr[0] value doesn''t match');
    CheckEqualsString('How', Arr[1], 'Arr[1] value doesn''t match');
    CheckEqualsString('Are', Arr[2], 'Arr[2] value doesn''t match');
    CheckEqualsString('Doing', Arr[3], 'Arr[3] value doesn''t match');
    CheckEqualsString('Hope', Arr[4], 'Arr[4] value doesn''t match');
    CheckEqualsString('Well', Arr[5], 'Arr[5] value doesn''t match');
  end;
begin
  Arr := MkStrArray(['Hello', 'How', 'Are']);
  AppendToStrArray(['Doing', 'Hope', 'Well'], Arr);
  CheckFirstElements;
  SetLength(Arr, 8);
  AppendToStrArray(['T', 'Ze'], Arr, 6);
  CheckFirstElements;
  CheckEqualsString('T', Arr[6], 'Arr[6] value doesn''t match');
  CheckEqualsString('Ze', Arr[7], 'Arr[7] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestBuildVarRecArray;
var
  Arr : TVarRecArray;
begin
  Arr := MkVarRecArray([0, ShortString('Hi'), 2.1]);
  CheckEquals(vtInteger, Arr[0].VType, 'Type of Arr[0] doesn''t match');
  CheckEquals(0, Arr[0].VInteger, 'Arr[0] value doesn''t match');
  CheckEquals(vtString, Arr[1].VType, 'Type of Arr[1] doesn''t match');
  CheckEqualsString('Hi', Arr[1].VString^, 'Arr[1] value doesn''t match');
  CheckEquals(vtExtended, Arr[2].VType, 'Type of Arr[2] doesn''t match');
  CheckEqualsString(FloatToStr(2.1), FloatToStr(Arr[2].VExtended^), 'Arr[2] value doesn''t match');
end;

procedure TestArrayBuildingFunctions.TestAppendToVarRecArray;
var
  Arr : TVarRecArray;
  procedure CheckFirstElements;
  begin
    CheckEquals(vtInteger, Arr[0].VType, 'Type of Arr[0] doesn''t match');
    CheckEquals(0, Arr[0].VInteger, 'Arr[0] value doesn''t match');
    CheckEquals(vtString, Arr[1].VType, 'Type of Arr[1] doesn''t match');
    CheckEqualsString('Hi', Arr[1].VString^, 'Arr[1] value doesn''t match');
    CheckEquals(vtExtended, Arr[2].VType, 'Type of Arr[2] doesn''t match');
    CheckEqualsString(FloatToStr(2.1), FloatToStr(Arr[2].VExtended^), 'Arr[2] value doesn''t match');
    CheckEquals(vtInteger, Arr[3].VType, 'Type of Arr[3] doesn''t match');
    CheckEquals(4, Arr[3].VInteger, 'Arr[3] value doesn''t match');
    CheckEquals(vtBoolean, Arr[4].VType, 'Type of Arr[4] doesn''t match');
    Check(Arr[4].VBoolean, 'Arr[4] value doesn''t match');
  end;
begin
  Arr := MkVarRecArray([0, ShortString('Hi'), 2.1]);
  AppendToVarRecArray([4, True], Arr);
  CheckFirstElements;
  SetLength(Arr, 7);
  AppendToVarRecArray([5, False], Arr, 5);
  CheckFirstElements;
  CheckEquals(vtInteger, Arr[5].VType, 'Type of Arr[5] doesn''t match');
  CheckEquals(5, Arr[5].VInteger, 'Arr[5] value doesn''t match');
  CheckEquals(vtBoolean, Arr[6].VType, 'Type of Arr[6] doesn''t match');
  Check(not Arr[6].VBoolean, 'Arr[6] value doesn''t match');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestIBsonOID.Suite);
  RegisterTest(TestIBsonCodeWScope.Suite);
  RegisterTest(TestIBsonRegex.Suite);
  RegisterTest(TestIBsonTimestamp.Suite);
  RegisterTest(TestIBsonBinary.Suite);
  RegisterTest(TestIBsonBuffer.Suite);
  RegisterTest(TestIBsonIterator.Suite);
  RegisterTest(TestIBson.Suite);
  RegisterTest(TestArrayBuildingFunctions.Suite);
end.

