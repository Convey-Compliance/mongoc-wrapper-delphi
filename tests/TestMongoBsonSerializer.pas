unit TestMongoBsonSerializer;
// should be encoded as UTF8 without BOM for Delphi5

{$i DelphiVersion_defines.inc}

interface

uses
  TestFramework,
  uLinkedListDefaultImplementor, uScope,
  {$IFNDEF VER130}Variants,{$EndIf}
  MongoBsonSerializer,
  uCnvDictionary;

type
  {$M+}
  TestTMongoBsonSerializer = class(TTestCase)
  private
    FSerializer: TBaseBsonSerializer;
    FDeserializer : TBaseBsonDeserializer;
    FScope: IScope;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreateDeserializer(FSerializer: TBaseBsonSerializer;
                                     const Value: string);
    procedure TestCreateSerializer;
    procedure TestSerializeObjectAsStringList_Flat;
    procedure TestSerializeObjectDeserializeWithDynamicBuilding;
    procedure TestSerializeObjectDeserializeWithDynamicBuilding_FailTypeNotFound;
    procedure TestSerializeObjectDeserializeWithDynamicBuildingOfObjProp;
    procedure TestSerializePrimitiveTypes;
    {$IFDEF DELPHI2007}
    procedure DynamicArrayOfObjects;
    {$ENDIF}
    procedure StringDictionarySimple;
    procedure StringDictionaryComplex;
  end;
  {$M-}

implementation

uses
  MongoBson, Classes, SysUtils, uDelphi5;

const
  DATE_TIME_EPSILON = 1000;

type
  TEnumeration = (eFirst, eSecond);
  TEnumerationSet = set of TEnumeration;
  TDynIntArr = array of Integer;
  TDynIntArrArr = array of array of Integer;

  {$M+}
  TIntSubObject = class
  private
    FTheInt: Integer;
  public
    constructor Create(ATheInt: Integer); overload;
  published
    property TheInt: Integer read FTheInt write FTheInt;
  end;

  TTestObject = class
  private
    FContext: Pointer;
    F_a: NativeUInt;
    FThe_02_AnsiChar: AnsiChar;
    FThe_00_Int: Integer;
    FThe_01_Int64: Int64;
    FThe_03_Enumeration: TEnumeration;
    FThe_04_Float: Extended;
    FThe_05_String: String;
    FThe_06_ShortString: ShortString;
    FThe_07_Set: TEnumerationSet;
    FThe_08_SubObject: TIntSubObject;
    {$IFDEF DELPHI2007}
    FThe_09_DynIntArr: TDynIntArr;
    {$ENDIF}
    FThe_10_WChar: WideChar;
    FThe_11_AnsiString: AnsiString;
    FThe_12_WideString: WideString;
    FThe_13_StringList: TStringList;
    FThe_14_VariantAsInteger : Variant;
    FThe_15_VariantAsString: Variant;
    FThe_16_VariantAsArray : Variant;
    FThe_17_VariantTwoDimArray : Variant;
    FThe_18_VariantAsArrayEmpty: Variant;
    FThe_19_Boolean: Boolean;
    FThe_20_DateTime: TDateTime;
    FThe_21_MemStream: TMemoryStream;
    FThe_22_BlankMemStream: TMemoryStream;
    FThe_23_EmptySet: TEnumerationSet;
    {$IFDEF DELPHI2007}
    FThe_24_DynIntArrArr: TDynIntArrArr;
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    property Context: Pointer read FContext write FContext;
  published
    property The_00_Int: Integer read FThe_00_Int write FThe_00_Int;
    property The_01_Int64: Int64 read FThe_01_Int64 write FThe_01_Int64;
    property The_02_AnsiChar: AnsiChar read FThe_02_AnsiChar write FThe_02_AnsiChar;
    property The_03_Enumeration: TEnumeration read FThe_03_Enumeration write FThe_03_Enumeration;
    property The_04_Float: Extended read FThe_04_Float write FThe_04_Float;
    property The_05_String: String read FThe_05_String write FThe_05_String;
    property The_06_ShortString: ShortString read FThe_06_ShortString write FThe_06_ShortString;
    property The_07_Set: TEnumerationSet read FThe_07_Set write FThe_07_Set;
    property The_08_SubObject: TIntSubObject read FThe_08_SubObject write FThe_08_SubObject;
    {$IFDEF DELPHI2007}
    property The_09_DynIntArr: TDynIntArr read FThe_09_DynIntArr write FThe_09_DynIntArr;
    {$ENDIF}
    property The_10_WChar: WideChar read FThe_10_WChar write FThe_10_WChar;
    property The_11_AnsiString: AnsiString read FThe_11_AnsiString write FThe_11_AnsiString;
    property The_12_WideString: WideString read FThe_12_WideString write FThe_12_WideString;
    property The_13_StringList: TStringList read FThe_13_StringList write FThe_13_StringList;
    property The_14_VariantAsInteger : Variant read FThe_14_VariantAsInteger write FThe_14_VariantAsInteger;
    property The_15_VariantAsString: Variant read FThe_15_VariantAsString write FThe_15_VariantAsString;
    property The_16_VariantAsArray: Variant read FThe_16_VariantAsArray write FThe_16_VariantAsArray;
    property The_17_VariantTwoDimArray: Variant read FThe_17_VariantTwoDimArray write FThe_17_VariantTwoDimArray;
    property The_18_VariantAsArrayEmpty: Variant read FThe_18_VariantAsArrayEmpty write FThe_18_VariantAsArrayEmpty;
    property The_19_Boolean: Boolean read FThe_19_Boolean write FThe_19_Boolean;
    property The_20_DateTime: TDateTime read FThe_20_DateTime write FThe_20_DateTime;
    property The_21_MemStream: TMemoryStream read FThe_21_MemStream;
    property The_22_BlankMemStream: TMemoryStream read FThe_22_BlankMemStream;
    property The_23_EmptySet: TEnumerationSet read FThe_23_EmptySet write FThe_23_EmptySet;
    {$IFDEF DELPHI2007}
    property The_24_DynIntArrArr: TDynIntArrArr read FThe_24_DynIntArrArr write FThe_24_DynIntArrArr;
    {$ENDIF}
    property _a: NativeUInt read F_a write F_a;
  end;

  TTestObjectWithObjectAsStringList = class
  private
    FObjectAsStringList: TObjectAsStringList;
    procedure SetObjectAsStringList(const Value: TObjectAsStringList);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property ObjectAsStringList: TObjectAsStringList read FObjectAsStringList write SetObjectAsStringList;
  end;

  TSubObjectArray = array of TIntSubObject;

  {$IFDEF DELPHI2007}
  TDynamicArrayOfObjectsContainer = class
  private
    FArr: TSubObjectArray;
  published
    property Arr: TSubObjectArray read FArr write FArr;
  end;
  {$ENDIF}

  TDictionaryHolder = class
  private
    FStrDict: TCnvStringDictionary;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property StrDict: TCnvStringDictionary read FStrDict write FStrDict;
  end;

  {$M-}

constructor TTestObject.Create;
begin
  inherited Create;
  FThe_08_SubObject := TIntSubObject.Create;
  FThe_13_StringList := TStringList.Create;
  FThe_21_MemStream := TMemoryStream.Create;
  FThe_22_BlankMemStream := TMemoryStream.Create;
end;

destructor TTestObject.Destroy;
begin
  FThe_22_BlankMemStream.Free;
  FThe_21_MemStream.Free;
  FThe_13_StringList.Free;
  FThe_08_SubObject.Free;
  inherited Destroy;
end;

procedure TestTMongoBsonSerializer.SetUp;
begin
  FSerializer := CreateSerializer(TObject);
  FDeserializer := CreateDeserializer(TObject);
  FScope := NewScope;
end;

procedure TestTMongoBsonSerializer.TearDown;
begin
  FDeserializer.Free;
  FSerializer.Free;
end;

procedure TestTMongoBsonSerializer.TestCreateDeserializer(FSerializer:
    TBaseBsonSerializer; const Value: string);
begin
  Check(FDeserializer <> nil, 'FDeserializer should be <> nil');
end;

procedure TestTMongoBsonSerializer.TestCreateSerializer;
begin
  Check(FSerializer <> nil, 'FSerializer should be <> nil');
end;

procedure TestTMongoBsonSerializer.TestSerializeObjectAsStringList_Flat;
var
  TestObject1, TestObject2 : TTestObjectWithObjectAsStringList;
  b : IBson;
  it, SubIt : IBsonIterator;
begin
  FSerializer.Target := NewBsonBuffer();
  TestObject1 := TTestObjectWithObjectAsStringList.Create();
  try
    TestObject1.ObjectAsStringList.Add('Name1=Value1');
    TestObject1.ObjectAsStringList.Add('Name2=Value2');
    TestObject1.ObjectAsStringList.Add('Name3=Value3');
    TestObject1.ObjectAsStringList.Add('Name4=Value4');
    TestObject1.ObjectAsStringList.Add('Name5=Value5');

    FSerializer.Serialize('', TestObject1);

    b := FSerializer.Target.finish;
    it := b.iterator;
    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('_type', it.key);
    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('ObjectAsStringList', it.key);
    Check(it.Kind = BSON_TYPE_DOCUMENT, 'Type of iterator value should be bsonObject');
    SubIt := it.subiterator;
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEqualsString('Name1', SubIt.key, 'Iterator should be equals to Value1');
    CheckEqualsString('Value1', SubIt.value, 'Iterator should be equals to Value1');
    SubIt.next;
    SubIt.next;
    SubIt.next;
    SubIt.next;
    CheckEqualsString('Name5', SubIt.key, 'Iterator should be equals to Value1');
    CheckEqualsString('Value5', SubIt.value, 'Iterator should be equals to Value1');

    TestObject2 := TTestObjectWithObjectAsStringList.Create;
    try
      FDeserializer.Source := b.iterator;
      FDeserializer.Deserialize(TObject(TestObject2), nil);

      CheckEqualsString('Name1=Value1', TestObject2.ObjectAsStringList[0]);
      CheckEqualsString('Name5=Value5', TestObject2.ObjectAsStringList[4]);
    finally
      FreeAndNil(TestObject2);
    end;
  finally
    FreeAndNil(TestObject1);
  end;
end;

function BuildTTestObject(const AClassName: string; AContext: Pointer): TObject;
begin
  Result := TTestObject.Create;
  (Result as TTestObject).Context := AContext;
end;

procedure TestTMongoBsonSerializer.TestSerializeObjectDeserializeWithDynamicBuilding;
var
  b: IBsonBuffer;
  AObj : TTestObject;
  it: IBsonIterator;
begin
  b := NewBsonBuffer;
  AObj := TTestObject.Create;
  try
    AObj.The_00_Int := 123;
    FSerializer.Target := b;
    FSerializer.Serialize('', AObj);
  finally
    FreeAndNil(AObj);
  end;

  it := b.finish.iterator;
  FDeserializer.Source := it;
  RegisterBuildableSerializableClass(TTestObject.ClassName, BuildTTestObject);
  try
    FDeserializer.Deserialize(TObject(AObj), pointer(1234));
    Check(AObj <> nil, 'Object returned from deserialization must be <> nil');
    CheckEquals(123, AObj.The_00_Int, 'The_00_Int attribute should be equals to 123');
    CheckEquals(1234, NativeUInt(AObj.Context), 'property Context should be equals to 1234');
  finally
    UnregisterBuildableSerializableClass(TTestObject.ClassName);
  end;
end;

function BuildTIntSubObject(const AClassName: string; AContext: Pointer): TObject;
begin
  Result := TIntSubObject.Create;
end;

procedure TestTMongoBsonSerializer.TestSerializeObjectDeserializeWithDynamicBuilding_FailTypeNotFound;
var
  AObj : TTestObject;
begin
  AObj := TTestObject.Create;
  try
    AObj.The_00_Int := 123;
    FSerializer.Target := NewBsonBuffer();
    FSerializer.Serialize('', AObj);
  finally
    AObj.Free;
  end;
  AObj := nil;
  FDeserializer.Source := FSerializer.Target.finish.iterator;
  try
    FDeserializer.Deserialize(TObject(AObj), nil);
    Fail('Should have raised exception that it cound not find suitable builder for class TestObject');
  except
    on E : Exception do CheckEqualsString('Suitable builder not found for class <TestObject>', E.Message);
  end;
end;

procedure TestTMongoBsonSerializer.TestSerializeObjectDeserializeWithDynamicBuildingOfObjProp;
var
  AObj : TTestObject;
begin
  AObj := TTestObject.Create;
  try
    FSerializer.Target := NewBsonBuffer();
    AObj.The_08_SubObject.TheInt := 123;
    FSerializer.Serialize('', AObj);
  finally
    AObj.Free;
  end;
  AObj := nil;
  AObj := TTestObject.Create;
  try
    AObj.The_08_SubObject.Free;
    AObj.The_08_SubObject := nil;
    FDeserializer.Source := FSerializer.Target.finish.iterator;
    FDeserializer.Deserialize(TObject(AObj), nil);
    Check(AObj.The_08_SubObject <> nil, 'AObj.The_08_SubObject must be <> nil after deserialization');
    CheckEquals(123, AObj.The_08_SubObject.TheInt, 'The_00_Int attribute should be equals to 123');
  finally
    AObj.Free;
  end;
end;

procedure TestTMongoBsonSerializer.TestSerializePrimitiveTypes;
const
  SomeData : PAnsiChar = '1234567890qwertyuiop';
  Buf      : PAnsiChar = '                    ';
var
  it, SubIt, SubSubIt : IBsonIterator;
  Obj : TTestObject;
  Obj2 : TTestObject;
  v : Variant;
  b : IBson;
  bin : IBsonBinary;
  dynIntArr : TDynIntArr;
  dynIntArrArr : TDynIntArrArr;
  I : Integer;
begin
  FSerializer.Target := NewBsonBuffer();
  Obj := TTestObject.Create;
  try
    Obj.The_00_Int := 10;
    Obj.The_01_Int64 := 11;
    Obj.The_02_AnsiChar := 'B';
    Obj.The_03_Enumeration := eSecond;
    Obj.The_04_Float := 1.5;
    {$IFDEF DELPHIXE}
    Obj.The_05_String := 'дом';
    {$ELSE}
    Obj.The_05_String := 'home';
    {$ENDIF}
    Obj.The_06_ShortString := 'Hello';
    Obj.The_07_Set := [eFirst, eSecond];
    Obj.The_08_SubObject.TheInt := 12;
    {$IFDEF DELPHI2007}
    Obj.The_10_WChar := #1076;
    {$ELSE}
    Obj.The_10_WChar := 'd';
    {$ENDIF}
    SetLength(dynIntArr, 2);
    dynIntArr[0] := 1;
    dynIntArr[1] := 2;
    {$IFDEF DELPHI2007}
    Obj.The_09_DynIntArr := dynIntArr;
    {$ENDIF}
    Obj.The_11_AnsiString := 'Hello World';
    Obj.The_12_WideString := 'дом дом';
    {$IFDEF DELPHIXE}
    Obj.The_13_StringList.Add('дом');
    Obj.The_13_StringList.Add('ом');
    {$ELSE}
    Obj.The_13_StringList.Add('home');
    Obj.The_13_StringList.Add('ome');
    {$ENDIF}
    Obj.The_14_VariantAsInteger := 14;
    {$IFDEF DELPHIXE}
    Obj.The_15_VariantAsString := 'дом дом дом';
    {$ELSE}
    Obj.The_15_VariantAsString := 'alo';
    {$ENDIF}
    v := VarArrayCreate([0, 1], varInteger);
    v[0] := 16;
    v[1] := 22;
    Obj.The_16_VariantAsArray := v;
    v := VarArrayCreate([0, 1, 0, 1], varInteger);
    v[0, 0] := 16;
    v[0, 1] := 22;
    v[1, 0] := 33;
    v[1, 1] := 44;
    Obj.The_17_VariantTwoDimArray := v;
    Obj.The_18_VariantAsArrayEmpty := Null;
    Obj.The_19_Boolean := True;
    Obj.The_20_DateTime := Now;
    Obj.The_21_MemStream.Write(SomeData^, length(SomeData));
    SetLength(dynIntArrArr, 2);
    for I := 0 to Length(dynIntArrArr) - 1 do
      SetLength(dynIntArrArr[I], 2);
    dynIntArrArr[0, 0] := 1;
    dynIntArrArr[0, 1] := 2;
    dynIntArrArr[1, 0] := 3;
    dynIntArrArr[1, 1] := 4;
    {$IFDEF DELPHI2007}
    Obj.The_24_DynIntArrArr := dynIntArrArr;
    {$ENDIF}

    FSerializer.Serialize('', Obj);

    b := FSerializer.Target.finish;
    it := b.iterator;
    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('_type', it.key);
    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_00_Int', it.key);
    CheckEquals(10, it.value, 'Iterator should be equals to 10');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_01_Int64', it.key);
    CheckEquals(11, it.AsInt64, 'Iterator should be equals to 11');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_02_AnsiChar', it.key);
    CheckEqualsString(AnsiChar('B'), ShortString(it.Value), 'Iterator should be equals to "B"');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_03_Enumeration', it.key);
    CheckEqualsString('eSecond', AnsiString(it.Value), 'Iterator should be equals to "eSecond"');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_04_Float', it.key);
    CheckEquals(1.5, it.Value, 'Iterator should be equals to 1.5');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_05_String', it.key);
    {$IFDEF DELPHIXE}
    CheckEqualsString('дом', it.Value, 'Iterator should be equals to "дом"');
    {$ELSE}
    CheckEqualsString('home', it.Value, 'Iterator should be equals to "home"');
    {$ENDIF}

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_06_ShortString', it.key);
    CheckEqualsString('Hello', it.Value, 'Iterator should be equals to "Hello"');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_07_Set', it.key);
    Check(it.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubIt := it.subiterator;
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEqualsString('eFirst', SubIt.Value, 'Iterator should be equals to "eFirst"');
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEqualsString('eSecond', SubIt.Value, 'Iterator should be equals to "eSecond"');
    Check(not SubIt.next, 'Iterator should be at end');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_08_SubObject', it.key);
    Check(it.Kind = BSON_TYPE_DOCUMENT, 'Type of iterator value should be bsonOBJECT');
    SubIt := it.subiterator;
    CheckTrue(Subit.Next, 'SubIterator should not be at end');
    CheckEqualsString('_type', Subit.key);
    CheckTrue(SubIt.Next, 'SubIterator should not be at end');
    CheckEquals(12, SubIt.Value, 'Iterator should be equals to 12');
    Check(not SubIt.next, 'Iterator should be at end');

    {$IFDEF DELPHI2007}
    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_09_DynIntArr', it.key);
    Check(it.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubIt := it.subiterator;
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(1, SubIt.Value, 'Iterator should be equals to 1');
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(2, SubIt.Value, 'Iterator should be equals to 2');
    Check(not SubIt.next, 'Iterator should be at end');
    {$ENDIF}

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_10_WChar', it.key);
    CheckEqualsWideString({$IFDEF DELPHI2007}#1076{$ELSE}'d'{$ENDIF}, UTF8Decode(it.AsUTF8String), 'Iterator does''t match');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_11_AnsiString', it.key);
    CheckEqualsString('Hello World', it.Value, 'Iterator should be equals to "Hello World"');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_12_WideString', it.key);
    CheckEqualsWideString('дом дом', UTF8Decode(it.AsUTF8String), 'Iterator doesn''t match');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_13_StringList', it.key);
    Check(it.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubIt := it.subiterator;
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    {$IFDEF DELPHIXE}
    CheckEqualsString('дом', SubIt.AsUTF8String, 'Iterator should be equals to "дом"');
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEqualsString('ом', SubIt.Value, 'Iterator should be equals to "ом"');
    {$ELSE}
    CheckEqualsString('home', SubIt.Value, 'Iterator should be equals to "home"');
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEqualsString('ome', SubIt.Value, 'Iterator should be equals to "ome"');
    {$ENDIF}
    Check(not SubIt.next, 'Iterator should be at end');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_14_VariantAsInteger', it.key);
    CheckEquals(14, it.value, 'Iterator should be equals to 14');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_15_VariantAsString', it.key);
    {$IFDEF DELPHIXE}
    CheckEqualsWideString('дом дом дом', UTF8Decode(it.AsUTF8String), 'Iterator doesn''t match');
    {$ELSE}
    CheckEqualsWideString('alo', UTF8Decode(it.AsUTF8String), 'Iterator doesn''t match');
    {$ENDIF}

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_16_VariantAsArray', it.key);
    Check(it.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubIt := it.subiterator;
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(16, SubIt.Value, 'Iterator should be equals to 16');
    CheckTrue(SubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(22, SubIt.Value, 'Iterator should be equals to 22');
    Check(not SubIt.next, 'Iterator should be at end');

    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_17_VariantTwoDimArray', it.key);
    Check(it.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubIt := it.subiterator;
    CheckTrue(SubIt.Next, 'Iterator should not be at end');
    Check(SubIt.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubSubIt := SubIt.subiterator;
    CheckTrue(SubSubIt.Next, 'Iterator should not be at end');
    Check(SubSubIt.Kind = BSON_TYPE_INT32, 'Type of iterator value should be bsonARRAY');
    CheckEquals(16, SubSubIt.Value, 'Iterator should be equals to 16');
    CheckTrue(SubSubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(22, SubSubIt.Value, 'Iterator should be equals to 22');
    SubIt.next;
    SubSubIt := SubIt.subiterator;
    CheckTrue(SubSubIt.Next, 'Iterator should not be at end');
    Check(SubSubIt.Kind = BSON_TYPE_INT32, 'Type of iterator value should be bsonARRAY');
    CheckEquals(33, SubSubIt.Value, 'Iterator should be equals to 16');
    CheckTrue(SubSubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(44, SubSubIt.Value, 'Iterator should be equals to 22');

    Check(it.next, 'Iterator should not be at end');
    Check(VarIsNull(it.value), 'expected null value');

    Check(it.next, 'Iterator should not be at end');
    Check(it.value, 'expected true');

    Check(it.next, 'Iterator should not be at end');
    CheckEquals(Obj.The_20_DateTime, it.value, 0.1, 'expected date to match');

    Check(it.next, 'Iterator should not be at end');
    Check(it.Kind = BSON_TYPE_BINARY, 'expecting binary bson');
    bin := it.asBinary;
    CheckEquals(length(SomeData), bin.Len, 'binary data expected');
    Check(CompareMem(SomeData, bin.Data, bin.len), 'memory doesn''t match');

    Check(it.next, 'Iterator should not be at end');
    Check(it.Kind = BSON_TYPE_ARRAY);

    {$IFDEF DELPHI2007}
    CheckTrue(it.Next, 'Iterator should not be at end');
    CheckEqualsString('The_24_DynIntArrArr', it.key);
    Check(it.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubIt := it.subiterator;
    CheckTrue(SubIt.Next, 'Iterator should not be at end');
    Check(SubIt.Kind = BSON_TYPE_ARRAY, 'Type of iterator value should be bsonARRAY');
    SubSubIt := SubIt.subiterator;
    CheckTrue(SubSubIt.Next, 'Iterator should not be at end');
    Check(SubSubIt.Kind = BSON_TYPE_INT32, 'Type of iterator value should be bsonARRAY');
    CheckEquals(1, SubSubIt.Value, 'Iterator should be equals to 16');
    CheckTrue(SubSubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(2, SubSubIt.Value, 'Iterator should be equals to 22');
    SubIt.next;
    SubSubIt := SubIt.subiterator;
    CheckTrue(SubSubIt.Next, 'Iterator should not be at end');
    Check(SubSubIt.Kind = BSON_TYPE_INT32, 'Type of iterator value should be bsonARRAY');
    CheckEquals(3, SubSubIt.Value, 'Iterator should be equals to 16');
    CheckTrue(SubSubIt.Next, 'Array SubIterator should not be at end');
    CheckEquals(4, SubSubIt.Value, 'Iterator should be equals to 22');
    {$ENDIF}

    CheckTrue(it.Next, 'Array SubIterator should not be at end');
    CheckEquals(0, it.Value, 'Iterator should be equals to 0'); // property _a

    Check(not it.next, 'Iterator should be at end');

    Obj2 := TTestObject.Create;
    Obj2.The_17_VariantTwoDimArray := VarArrayCreate([0, 1, 0, 1], varInteger);
    SetLength(dynIntArrArr, 2);
    for I := 0 to Length(dynIntArrArr) - 1 do
      SetLength(dynIntArrArr[I], 2);
    {$IFDEF DELPHI2007}
    obj2.The_24_DynIntArrArr := dynIntArrArr;
    {$ENDIF}
    try
      obj2.The_23_EmptySet := [eFirst];
      FDeserializer.Source := b.iterator;
      FDeserializer.Deserialize(TObject(Obj2), nil);

      CheckEquals(10, obj2.The_00_Int, 'Value of The_00_Int doesn''t match');
      CheckEquals(11, obj2.The_01_Int64, 'Value of The_01_Int64 doesn''t match');
      CheckEquals(integer(eSecond), integer(obj2.The_03_Enumeration), 'Value of The_03_Enumeration doesn''t match');
      CheckEquals(1.5, obj2.The_04_Float, 'Value of The_04_Float doesn''t match');
      {$IFDEF DELPHIXE}
      CheckEqualsString('дом', obj2.The_05_String, 'The_05_String should be equals to "дом"');
      {$ELSE}
      CheckEqualsString('home', obj2.The_05_String, 'The_05_String should be equals to "home"');
      {$ENDIF}
      CheckEqualsString('Hello', obj2.The_06_ShortString, 'The_06_ShortString should be equals to "Hello"');
      Check(obj2.The_07_Set = [eFirst, eSecond], 'obj2.The_07_Set = [eFirst, eSecond]');

      CheckEquals(12, Obj2.The_08_SubObject.TheInt, 'Obj.The_08_SubObject.TheInt should be 12');

      {$IFDEF DELPHI2007}
      CheckEquals(2, Length(Obj2.The_09_DynIntArr), 'Obj2.The_09_DynIntArr Length should = 2');
      CheckEquals(1, Obj2.The_09_DynIntArr[0], 'Value of The_09_DynIntArr[0] doesn''t match');
      CheckEquals(2, Obj2.The_09_DynIntArr[1], 'Value of The_09_DynIntArr[1] doesn''t match');
      {$ENDIF}

      CheckEqualsString('Hello World', Obj2.The_11_AnsiString, 'Obj2.The_11_AnsiString doesn''t match value');

      {$IFDEF DELPHIXE}
      CheckEqualsString('дом', Obj2.The_13_StringList[0]);
      CheckEqualsString('ом', Obj.The_13_StringList[1]);
      {$ELSE}
      CheckEqualsString('home', Obj2.The_13_StringList[0]);
      CheckEqualsString('ome', Obj.The_13_StringList[1]);
      {$ENDIF}

      CheckEqualsWideString({$IFDEF DELPHI2007}#1076{$ELSE}'d'{$ENDIF}, Obj2.The_10_WChar, 'Obj2.The_10_WChar doesn''t match');

      CheckEquals(14, Obj2.The_14_VariantAsInteger, 'Obj2.The_14_VariantAsInteger doesn''t match value');

      {$IFDEF DELPHIXE}
      CheckEqualsString('дом дом дом', Obj2.The_15_VariantAsString, 'Obj2.The_15_VariantAsString doesn''t match expected value');
      {$ELSE}
      CheckEqualsWideString('alo', UTF8Decode(Obj2.The_15_VariantAsString), 'Iterator doesn''t match');
      {$ENDIF}

      CheckEquals(0, VarArrayLowBound(Obj2.The_16_VariantAsArray, 1), 'Obj2.The_16_VariantAsArray low bound equals 0');
      CheckEquals(1, VarArrayHighBound(Obj2.The_16_VariantAsArray, 1), 'Obj2.The_16_VariantAsArray high bound equals 1');
      CheckEquals(16, Obj2.The_16_VariantAsArray[0], 'Value of The_16_VariantAsArray[0] doesn''t match');
      CheckEquals(22, Obj2.The_16_VariantAsArray[1], 'Value of The_16_VariantAsArray[1] doesn''t match');

      CheckEquals(16, Obj2.The_17_VariantTwoDimArray[0, 0], 'Value of The_17_VariantTwoDimArray[0, 0] doesn''t match');
      CheckEquals(22, Obj2.The_17_VariantTwoDimArray[0, 1], 'Value of The_17_VariantTwoDimArray[0, 1] doesn''t match');
      CheckEquals(33, Obj2.The_17_VariantTwoDimArray[1, 0], 'Value of The_17_VariantTwoDimArray[1, 0] doesn''t match');
      CheckEquals(44, Obj2.The_17_VariantTwoDimArray[1, 1], 'Value of The_17_VariantTwoDimArray[1, 1] doesn''t match');

      Check(Obj2.The_19_Boolean, 'Obj2.The_19_Boolean should be true');

      CheckEquals(obj.The_20_DateTime, obj2.The_20_DateTime, 0.1, 'obj.The_20_DateTime = obj2.The_20_DateTime');

      Check(obj2.The_23_EmptySet = [], 'The_23_EmptySet should be empty');

      CheckEquals(length(SomeData), obj2.The_21_MemStream.Size, 'data size doesn''t match');
      Check(CompareMem(SomeData, obj2.The_21_MemStream.Memory, obj2.The_21_MemStream.Size), 'memory doesn''t match');

      {$IFDEF DELPHI2007}
      CheckEquals(1, Obj2.The_24_DynIntArrArr[0, 0], 'Value of The_24_DynIntArrArr[0, 0] doesn''t match');
      CheckEquals(2, Obj2.The_24_DynIntArrArr[0, 1], 'Value of The_24_DynIntArrArr[0, 1] doesn''t match');
      CheckEquals(3, Obj2.The_24_DynIntArrArr[1, 0], 'Value of The_24_DynIntArrArr[1, 0] doesn''t match');
      CheckEquals(4, Obj2.The_24_DynIntArrArr[1, 1], 'Value of The_24_DynIntArrArr[1, 1] doesn''t match');
      {$ENDIF}
    finally
      Obj2.Free;
    end;
  finally
    Obj.Free;
  end;
end;

{$IFDEF DELPHI2007}
procedure TestTMongoBsonSerializer.DynamicArrayOfObjects;
var
  obj, deserializedObj: TDynamicArrayOfObjectsContainer;
  arr: TSubObjectArray;
  I: Integer;
  b: IBson;
  it, subit, subsubit: IBsonIterator;
begin
  SetLength(arr, 3);
  for I := 0 to Length(arr) - 1 do
  begin
    arr[I] := TIntSubObject.Create;
    arr[I].TheInt := 5 + I;
  end;
  obj := FScope.Add(TDynamicArrayOfObjectsContainer.Create);
  obj.Arr := arr;

  FSerializer.Target := NewBsonBuffer;
  FSerializer.Serialize('', obj);

  b := FSerializer.Target.finish;
  it := b.iterator;

  Check(it.next);
  Check(BSON_TYPE_UTF8 = it.Kind);
  CheckEqualsString('DynamicArrayOfObjectsContainer', it.AsUTF8String);
  Check(it.next);

  Check(BSON_TYPE_ARRAY = it.Kind);
  CheckEqualsString('Arr', it.key);
  subit := it.subiterator;
  for I := 0 to Length(arr) - 1 do
  begin
    Check(subit.next);
    Check(BSON_TYPE_DOCUMENT = subit.Kind);
    subsubit := subit.subiterator;
    begin
      Check(subsubit.next);
      CheckEqualsString(SERIALIZED_ATTRIBUTE_ACTUALTYPE, subsubit.key);
      CheckEqualsString('IntSubObject', subsubit.AsUTF8String);
      Check(subsubit.next);
      Check(subsubit.Kind = BSON_TYPE_INT32);
      CheckEqualsString('TheInt', subsubit.key);
      CheckEquals(arr[I].TheInt, subsubit.AsInteger);
      CheckFalse(subsubit.next);
    end;
  end;
  CheckFalse(subit.next);
  CheckFalse(it.next);

  deserializedObj := TDynamicArrayOfObjectsContainer.Create;
  it := b.iterator;
  it.next;
  FDeserializer.Source := it;

  FDeserializer.Deserialize(TObject(deserializedObj), nil);

  for I := 0 to Length(obj.Arr) - 1 do
    CheckEquals(obj.Arr[I].TheInt, deserializedObj.Arr[I].TheInt);
end;
{$ENDIF}

constructor TTestObjectWithObjectAsStringList.Create;
begin
  inherited Create;
  FObjectAsStringList := TObjectAsStringList.Create;
end;

destructor TTestObjectWithObjectAsStringList.Destroy;
begin
  FreeAndNil(FObjectAsStringList);
  inherited Destroy;
end;

procedure TTestObjectWithObjectAsStringList.SetObjectAsStringList(const Value: TObjectAsStringList);
begin
  FObjectAsStringList.Assign(Value);
end;

procedure TestTMongoBsonSerializer.StringDictionarySimple;
const
  SUBOBJ_VAL = -1;
  MAXINT = High(Integer);
  TEST_STR = 'test str';
  MIN_INT64 = Low(Int64);
  BOOL = true;
var
  dh, newDh: TDictionaryHolder;
  b: IBsonBuffer;
  date: TDateTime;
  subObj: TIntSubObject;
  newInt: Integer;
  newInt64: Int64;
  newStr: string;
  newBool: Boolean;
  newDouble: Double;
  DOUBLE_VAL: Double;
  newDate: TDateTime;
begin
  DOUBLE_VAL := 666.666;
  dh := TDictionaryHolder.Create;
  try
    dh.StrDict.AddOrSetValue('item1', TIntSubObject.Create(SUBOBJ_VAL));
    dh.StrDict.AddOrSetValue('item2', MAXINT);
    dh.StrDict.AddOrSetValue('item3', TEST_STR);
    dh.StrDict.AddOrSetValue('item4', MIN_INT64);
    dh.StrDict.AddOrSetValue('item5', BOOL);
    dh.StrDict.AddOrSetValue('item6', DOUBLE_VAL);
    date := Now;
    dh.StrDict.AddOrSetValueDate('item7', date);

    b := NewBsonBuffer;
    FSerializer := CreateSerializer(TCnvStringDictionary);
    FSerializer.Target := b;
    FSerializer.Serialize('dict', dh);
  finally
    dh.Free;
  end;

  newDh := TDictionaryHolder.Create;
  try
    FDeserializer := CreateDeserializer(TCnvStringDictionary);
    FDeserializer.Source := b.finish.find('dict').subiterator;
    FDeserializer.Deserialize(TObject(newDh), nil);

    Check(newDh.StrDict.TryGetValue('item1', TObject(subObj)));
    CheckEquals(SUBOBJ_VAL, subObj.TheInt);
    Check(newDh.StrDict.TryGetValue('item2', newInt));
    CheckEquals(MAXINT, newInt);
    Check(newDh.StrDict.TryGetValue('item3', newStr));
    CheckEqualsString(TEST_STR, newStr);
    Check(newDh.StrDict.TryGetValue('item4', newInt64));
    CheckEquals(MIN_INT64, newInt64);
    Check(newDh.StrDict.TryGetValue('item5', newBool));
    CheckEquals(BOOL, newBool);
    Check(newDh.StrDict.TryGetValue('item6', newDouble));
    CheckEquals(DOUBLE_VAL, newDouble);
    Check(newDh.StrDict.TryGetValueDate('item7', newDate));
    CheckEquals(date, newDate, DATE_TIME_EPSILON);
  finally
    newDh.Free;
  end;
end;

procedure TestTMongoBsonSerializer.StringDictionaryComplex;
var
  dh, newDh: TDictionaryHolder;
  bb: IBsonBuffer;
  b: IBson;
  it, subit, keyit, valueit: IBsonIterator;
  subObj: TIntSubObject;
  newInt: Integer;
begin
  DictionarySerializationMode := ForceComplex;
  dh := TDictionaryHolder.Create;
  try
    dh.StrDict.AddOrSetValue('item1', TIntSubObject.Create(5));
    dh.StrDict.AddOrSetValue('a', 1);

    bb := NewBsonBuffer;
    FSerializer := CreateSerializer(TCnvStringDictionary);
    FSerializer.Target := bb;
    FSerializer.Serialize('dict', dh);
  finally
    dh.Free;
  end;

  b := bb.finish;

  it := b.iterator;
  Check(it.next);
  Check(BSON_TYPE_DOCUMENT = it.Kind);
  CheckEqualsString('dict', it.key);

  it := it.subiterator;

  Check(it.next);
  Check(BSON_TYPE_UTF8 = it.Kind);
  CheckEqualsString(SERIALIZED_ATTRIBUTE_ACTUALTYPE, it.key);

  Check(it.next);
  Check(BSON_TYPE_ARRAY = it.Kind);
  CheckEqualsString('StrDict', it.key);

  it := it.subiterator;
  Check(it.next);
  Check(BSON_TYPE_DOCUMENT = it.Kind);
  CheckEqualsString(SERIALIZED_ATTRIBUTE_COLLECTION_KEY + SERIALIZED_ATTRIBUTE_COLLECTION_VALUE, it.key);

  subit := it.subiterator;
  Check(subit.next);
  Check(BSON_TYPE_DOCUMENT = subit.Kind);
  CheckEqualsString(SERIALIZED_ATTRIBUTE_COLLECTION_KEY, subit.key);

  keyit := subit.subiterator;
  Check(keyit.next);
  Check(BSON_TYPE_UTF8 = keyit.Kind);
  CheckEqualsString('item1', keyit.Value);

  Check(subit.next);
  Check(BSON_TYPE_DOCUMENT = subit.Kind);
  CheckEqualsString(SERIALIZED_ATTRIBUTE_COLLECTION_VALUE, subit.key);

  valueit := subit.subiterator;
  Check(valueit.next);
  Check(BSON_TYPE_DOCUMENT = valueit.Kind);

  Check(it.next);
  Check(BSON_TYPE_DOCUMENT = it.Kind);
  CheckEqualsString(SERIALIZED_ATTRIBUTE_COLLECTION_KEY + SERIALIZED_ATTRIBUTE_COLLECTION_VALUE, it.key);

  subit := it.subiterator;
  Check(subit.next);
  Check(BSON_TYPE_DOCUMENT = subit.Kind);
  CheckEqualsString(SERIALIZED_ATTRIBUTE_COLLECTION_KEY, subit.key);

  keyit := subit.subiterator;
  Check(keyit.next);
  Check(BSON_TYPE_UTF8 = keyit.Kind);
  CheckEqualsString('a', keyit.Value);

  Check(subit.next);
  Check(BSON_TYPE_DOCUMENT = subit.Kind);
  CheckEqualsString(SERIALIZED_ATTRIBUTE_COLLECTION_VALUE, subit.key);

  valueit := subit.subiterator;
  Check(valueit.next);
  Check(BSON_TYPE_INT32 = valueit.Kind);
  CheckEquals(1, valueit.Value);

  newDh := TDictionaryHolder.Create;
  try
    FDeserializer := CreateDeserializer(TCnvStringDictionary);
    FDeserializer.Source := b.find('dict').subiterator;
    FDeserializer.Deserialize(TObject(newDh), nil);

    Check(newDh.StrDict.TryGetValue('item1', TObject(subObj)));
    CheckEquals(5, subObj.TheInt);
    Check(newDh.StrDict.TryGetValue('a', newInt));
    CheckEquals(1, newInt);
  finally
    newDh.Free;
  end;

  DictionarySerializationMode := Simple;
end;

{ TIntSubObject }

constructor TIntSubObject.Create(ATheInt: Integer);
begin
  FTheInt := ATheInt;
end;

{ TDictionaryHolder }

constructor TDictionaryHolder.Create;
begin
  inherited;
  FStrDict := TCnvStringDictionary.Create(true);
end;

destructor TDictionaryHolder.Destroy;
begin
  FStrDict.Free;
  inherited;
end;

initialization
  RegisterBuildableSerializableClass(TIntSubObject.ClassName, BuildTIntSubObject);

  RegisterTest(TestTMongoBsonSerializer.Suite);

finalization
  UnregisterBuildableSerializableClass(TIntSubObject.ClassName);
end.

