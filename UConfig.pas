unit UConfig;

//------------------------------------------------------------------------------
                                  interface
//------------------------------------------------------------------------------

uses SysUtils, Variants, Classes, xmldom, XMLIntf, msxmldom, XMLDoc, ActiveX;

// Смены
type
  RShifts = record
    id: Byte;           // номер смены
    startHour : Word;   // начало смены - часы
    endHour : Word;     // конец смены - часы
  end;

// Данные о весе
type
  RDataWeight = record
    curIDResurce: integer;  // Текущий ресурс id
    factor : Double;  // Коэф.
    weight: array of array of Double;  // Массив весов [IDСмена - 1, IDРесурс], [IDСмена - 1, 0] - Вес за смену
  end;

// конфигурация
type
  RConfig = record
    weightFactor : Double;       // Поправочный коэф веса
    weightPassageTime : Double;  // Время смеси на ленте в секундах

    ServerProgId : string;       // Id OPC сервера
    OPCUpdateRate: Integer;      // Частота опроса данных
    OPCTagWeight: string;        // имя тега - веса
    OPCTagStatus: string;        // имя тега - статуса

    weightNames: array of string;  // Список ресурсов id - 1
    workShifts: array of RShifts;  // Список смен     id - 1

    // для обновления информации вызвать - changeShift(RConfig)
    shiftDate: TDateTime; // Дата смены
    shiftId: Byte;        // Номер смены  id - 1
  end;

// интерфейс получения и сохранения конфигурации
type
  IConfig = interface(IInterface)
    // Методы
    function Save(conf: RConfig): Boolean;
    function Load(var conf: RConfig): Boolean;
    function GetFileName(): string;
    // Свойства
    property fileName: string read GetFileName;
  end;


// Получение и сохранения конфига в XML
type
  TXMLConfig = class(TInterfacedObject, IConfig)
  private
    { Private declarations }
    _fileName: string;

    function GetFileName(): string;

  public
    Constructor Create(fileName: string);
    property fileName: string read GetFileName;

    function Save(conf: RConfig): Boolean; overload;
    function Save(conf: RConfig; filename: string): Boolean; overload;

    function Load(var conf: RConfig): Boolean; overload;
    function Load(var conf: RConfig; filename: string): Boolean; overload;
  end;

function changeShift(var conf: RConfig): Boolean; // get current shift

// интерфейс получения и сохранения конфигурации
type
  IDataWeight = interface(IInterface)
    // Методы
    function Save(Date: TDateTime; data: RDataWeight): Boolean;
    function Load(Date: TDateTime; var data: RDataWeight): Boolean;
  end;

type
  TFileDataWeight = class(TInterfacedObject, IDataWeight)
  private
    function GetFileName(date: TDateTime): string;
  public
    function Save(Date: TDateTime; data: RDataWeight): Boolean;
    function Load(Date: TDateTime; var data: RDataWeight): Boolean;
  end;

type
  TXMLDataWeight = class(TInterfacedObject, IDataWeight)
  private
    function GetFileName(date: TDateTime): string;
  public
    function Save(Date: TDateTime; data: RDataWeight): Boolean;
    function Load(Date: TDateTime; var data: RDataWeight): Boolean;
  end;

var
  curIDResurce: integer;
  arrWeight: array of array of Double; // Массив весов [IDСмена - 1, IDРесурс], [IDСмена - 1, 0] - Вес за смену

//------------------------------------------------------------------------------
                                implementation
//------------------------------------------------------------------------------
uses DateUtils;


constructor TXMLConfig.Create(fileName: string);
begin
  //inherited;
  self._fileName := fileName;
end;


function TXMLConfig.GetFileName(): string;
begin
  Result:= _fileName;
end;


function TXMLConfig.Load(var conf: RConfig): Boolean;
begin
  Result := self.Load(conf, Self.fileName);
end;

function TXMLConfig.Load(var conf: RConfig; filename: string): Boolean;
var
  XMLConfig: IXMLDocument;
  i: Integer;
  id: Integer;
  name: string;
  node, chNode: ixmlnode;
begin
  Result:= False;
  if FileExists(filename) then
  begin
    XMLConfig := TXMLDocument.Create(nil);

      try
        XMLConfig.LoadFromFile(filename);
        xmlConfig.Active:= True;

        node := xmlConfig.DocumentElement.ChildNodes['calibration'];
        conf.weightFactor := StrToFloat(node.Attributes['factor']);
        conf.weightPassageTime := StrToFloat(node.Attributes['passageTime']);

        node := xmlConfig.DocumentElement.ChildNodes['connection'];
        conf.ServerProgId := Trim(node.ChildNodes['serverProgId'].text);
        conf.OPCUpdateRate:= StrToInt(node.ChildNodes['updateRate'].text);
        conf.OPCTagWeight := Trim(node.ChildNodes['tagWeight'].text);
        conf.OPCTagStatus := Trim(node.ChildNodes['tagStatus'].text);

        node := xmlConfig.DocumentElement.ChildNodes['resources'];
        SetLength(conf.weightNames, node.ChildNodes.Count);
        for i:= 0 to node.ChildNodes.Count - 1 do
        begin
          chNode := node.ChildNodes[i];
          id  := StrToInt(chNode.Attributes['id']) - 1;
          name:= Trim(chNode.Attributes['name']);
          conf.weightNames[id] := name;
        end;

        node := xmlConfig.DocumentElement.ChildNodes['shifts'];
        SetLength(conf.workShifts, node.ChildNodes.Count);
        for i:= 0 to node.ChildNodes.Count - 1 do
        begin
          chNode := node.ChildNodes[i];

          id  := StrToInt(chNode.Attributes['id']) - 1;
          conf.workShifts[id].startHour := StrToInt(chNode.Attributes['timeHourStart']);
          conf.workShifts[id].endHour := StrToInt(chNode.Attributes['timeHourEnd']);
        end;

        Result:= True;
      finally
        xmlConfig.Active:=False;
      end;

  end
  else
    Result:= False;

end;


function TXMLConfig.Save(conf: RConfig): Boolean;
begin
  Result := self.Save(conf, Self.fileName);
end;


function TXMLConfig.Save(conf: RConfig; filename: string): Boolean;
var
  Xml: IXMLDocument;
  i: Integer;
  id: Integer;
  name: string;
  root, node, chNode: ixmlnode;
begin
  Result:= False;
  Xml := TXMLDocument.Create(nil);

    try
      Xml.Active := True;
      Xml.Version := '1.0';
      Xml.Encoding := 'windows-1251';

      root:=Xml.ChildNodes['setting'];

      node := root.ChildNodes['calibration'];
      node.Attributes['factor'] := FloatToStr(conf.weightFactor);
      node.Attributes['passageTime'] := FloatToStr(conf.weightPassageTime);

      node := root.ChildNodes['connection'];
      node.ChildNodes['serverProgId'].text := conf.ServerProgId;
      node.ChildNodes['updateRate'].text := IntToStr(conf.OPCUpdateRate);
      node.ChildNodes['tagWeight'].text := conf.OPCTagWeight;
      node.ChildNodes['tagStatus'].text := conf.OPCTagStatus;

      node := root.AddChild('resources');

      for i:= 0 to Length(conf.weightNames) - 1 do
      begin
         chNode := node.AddChild('resource');
         chNode.Attributes['id'] := IntToStr(i+1);
         chNode.Attributes['name'] := conf.weightNames[i];
      end;

      node := root.AddChild('shifts');

      for i:= 0 to Length(conf.workShifts) - 1 do
      begin
         chNode := node.AddChild('shift');
         chNode.Attributes['id'] := IntToStr(i+1);
         chNode.Attributes['timeHourStart'] := IntToStr(conf.workShifts[i].startHour);
         chNode.Attributes['timeHourEnd'] := IntToStr(conf.workShifts[i].endHour);
      end;

      Xml.SaveToFile(filename);

      Result:= True;
    finally
      Xml.Active := False;
    end;

end;

function changeShift(var conf: RConfig): Boolean;
var
  i : Integer;
  Y, M, D, H, Min, Sec, MilSec: Word;
  shiftDate: TDateTime;
  shiftId: Byte;

  find: Boolean;
begin
  Result := False;
  find := False;

  DecodeDateTime(Now(), Y, M, D, H, Min, Sec, MilSec);
  for i:= 0 to Length(conf.workShifts) - 1 do
  begin

    if (conf.workShifts[i].startHour < conf.workShifts[i].endHour) then
    begin
      if (H >= conf.workShifts[i].startHour) and (H < conf.workShifts[i].endHour) then
      begin
        shiftDate := EncodeDateTime(Y, M, D, 0, 0, 0, 0);
        find := True;
      end;
    end
    else
    begin
      if ( conf.workShifts[i].startHour <= 23 ) and (conf.workShifts[i].endHour >= 0 ) then
      begin
        shiftDate := EncodeDateTime(Y, M, (D - 1), 0, 0, 0, 0);
        find := True;
      end;
    end;


    if find then
    begin
      shiftId := i;
      conf.shiftDate := shiftDate;
      conf.shiftId := shiftId;

      if (shiftDate <> conf.shiftDate) or (shiftId <> conf.shiftId) then
          Result := True;

      Break;
    end;

  end;

end;

function TFileDataWeight.GetFileName(date: TDateTime): string;
const
  path = 'data';
var
  dir : string;
  Y, M, D, H, Min, Sec, MilSec: Word;

  day: string;
  mounth: string;
begin
  dir := path;  // GetCurrentDir
  DecodeDateTime(date, Y, M, D, H, Min, Sec, MilSec);

  day := Format('%.2d',[D]);
  mounth := Format('%.2d',[M]);

  if not DirectoryExists(dir) then
    MkDir(dir);

  dir := dir + '/' + IntToStr(Y) + '-' + mounth;

  if not DirectoryExists(dir) then
    MkDir(dir);

  Result := dir + '/' + IntToStr(Y) + '-' + mounth + '-' + day + '.dat';
end;

function TFileDataWeight.Save(Date: TDateTime; data: RDataWeight): Boolean;
var
  Stream: TStream;
begin
  Result := False;

  Stream:= TFileStream.Create(Self.GetFileName(Date), fmCreate);
  try
    Stream.WriteBuffer(data, SizeOf(data));
    Result := True;
  finally
    Stream.Free;
  end;

end;

function TFileDataWeight.Load(Date: TDateTime; var data: RDataWeight): Boolean;
var
  Stream: TStream;
  fileName: string;
begin
  Result := False;

  fileName := Self.GetFileName(Date);

  if FileExists(fileName) then
  begin

    Stream:= TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
    try
      Stream.ReadBuffer(data, SizeOf(data));
      Result := True;
    finally
      Stream.Free;
    end;

  end;

end;


function TXMLDataWeight.GetFileName(date: TDateTime): string;
const
  path = 'data';
var
  dir : string;
  Y, M, D, H, Min, Sec, MilSec: Word;

  day: string;
  mounth: string;
begin
  dir := path;  // GetCurrentDir
  DecodeDateTime(date, Y, M, D, H, Min, Sec, MilSec);

  day := Format('%.2d',[D]);
  mounth := Format('%.2d',[M]);

  if not DirectoryExists(dir) then
    MkDir(dir);

  dir := dir + '/' + IntToStr(Y) + '-' + mounth;

  if not DirectoryExists(dir) then
    MkDir(dir);

  Result := dir + '/' + IntToStr(Y) + '-' + mounth + '-' + day + '.xml';
end;

function TXMLDataWeight.Save(Date: TDateTime; data: RDataWeight): Boolean;
var
  Xml: IXMLDocument;
  i, j: Integer;
  root, node, chNode, resNode: ixmlnode;
begin
  Result := False;
  Xml := TXMLDocument.Create(nil);

    try
      Xml.Active := True;
      Xml.Version := '1.0';
      Xml.Encoding := 'windows-1251';

      root:=Xml.ChildNodes['report'];

      root.AddChild('update').Text := DateTimeToStr(Now);

      node := root.ChildNodes['calibration'];
      node.Attributes['factor'] := FloatToStr(data.factor);

      node := root.ChildNodes['curResource'];
      node.Attributes['id'] := FloatToStr(data.curIDResurce);

      node := root.AddChild('shifts');

      for i:= 0 to Length(data.weight) - 1 do
      begin
         chNode := node.AddChild('shift');
         chNode.Attributes['id'] := IntToStr(i+1);

         for j:= 0 to Length(data.weight[i]) - 1 do
         begin
           resNode := chNode.AddChild('resource');
           resNode.Attributes['id'] := IntToStr(j);
           resNode.Attributes['weight'] := FloatToStr(data.weight[i,j]);
         end;
      end;

      Xml.SaveToFile(Self.GetFileName(Date));

      Result:= True;
    finally
      Xml.Active := False;
    end
end;

function TXMLDataWeight.Load(Date: TDateTime; var data: RDataWeight): Boolean;
var
  fileName: string;
  Xml: IXMLDocument;
  i, j, dshift, dres: Integer;
  root, node, chNode, resNode: ixmlnode;
begin
  Result := False;

  fileName := Self.GetFileName(Date);

  if FileExists(fileName) then
  begin

    Xml := TXMLDocument.Create(nil);

    try
      XML.LoadFromFile(filename);
      XML.Active:= True;

      node := XML.DocumentElement.ChildNodes['calibration'];
      data.factor := StrToFloat(node.Attributes['factor']);

      node := XML.DocumentElement.ChildNodes['curResource'];
      data.curIDResurce := StrToInt(node.Attributes['id']);

      node := XML.DocumentElement.ChildNodes['shifts'];

      SetLength(data.weight, node.ChildNodes.Count);

      for i:= 0 to node.ChildNodes.Count - 1 do
      begin
         chNode := node.ChildNodes[i];
         dshift := StrToInt(chNode.Attributes['id']) - 1;

         SetLength(data.weight[i], chNode.ChildNodes.Count);

         for j:= 0 to chNode.ChildNodes.Count - 1 do
         begin
           resNode := chNode.ChildNodes[j];
           dres := StrToInt(resNode.Attributes['id']);
           data.weight[dshift, dres] := StrToFloat(resNode.Attributes['weight']);
         end;
      end;

      Result:= True;
    finally
      XML.Active:=False;
    end;


  end;

end;

end.
