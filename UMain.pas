unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnMan, ActnColorMaps, XPMan, StdCtrls, Menus, ExtCtrls,
  ComCtrls, TeEngine, Series, TeeProcs, Chart, DateUtils, UWeight, TLoggerUnit,
  TConfiguratorUnit, ActiveX, xmldom, XMLIntf, msxmldom, XMLDoc, UConfig,
  prOpcClient;

type
  TMainForm = class(TForm)
    XPManifest: TXPManifest;
    pnlTop: TPanel;
    mmMain: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    GroupBox1: TGroupBox;
    lbAllWeight: TLabel;
    GroupBox2: TGroupBox;
    spl1: TSplitter;
    Label2: TLabel;
    Label3: TLabel;
    StatusBar: TStatusBar;
    pnlBottom: TPanel;
    pnlChartShift: TPanel;
    chtSheft: TChart;
    arsrsSeries1: TAreaSeries;
    Panel1: TPanel;
    chtLive: TChart;
    arsrsMain: TFastLineSeries;
    Timer1: TTimer;
    XMLConfig: TXMLDocument;
    OpcSimpleClient: TOpcSimpleClient;
    Memo1: TMemo;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OpcSimpleClient1Groups0DataChange(Sender: TOpcGroup;
      ItemIndex: Integer; const NewValue: Variant; NewQuality: Word;
      NewTimestamp: TDateTime);
  private
    { Private declarations }
    procedure LiveChartInit();
    procedure LiveChartAdd(data: Double);

    procedure ShiftChartInit(startShift, endShift : TDateTime);
    procedure ShiftChartAdd(data: Double);
    procedure ShiftChartLoadData(LoadAll : Boolean = False);

  public
    { Public declarations }
  end;


  procedure EventChangeWeight(weight: Double);

const
  CHARTLIVE_COUNT_POINT = 250;  // Количество отображаемых точек на графике live
  CHARTSHIFT_STEP_MINUT = 5;  // Шаг отображения данных

var
  MainForm: TMainForm;
  workDirectory: string;  // Рабочая директория
  log : TLogger;          // Логгер
  Config: IConfig;        // Конфигурация
  curConfig: RConfig;     // Текущая конфигурация

  // ID tag opc
  idStatus : Integer;
  idWeight : Integer;
  idConnected : Integer;


  arrChartShiftData: array of Double;  // Для графика смены
  arrChartShiftTime: array of Double;  // Для графика смены

  arrChartLiveData: array of Double;
  indexLiveData: Integer;             // Указатель на данных в массиве arrChartLiveData

  CountWeight: TCountWeight;


implementation



{$R *.dfm}

// Version
function GetMyVersion:string;
type
  TVerInfo=packed record
    Nevazhno: array[0..47] of byte;
    Minor,Major,Build,Release: word;
  end;
var
  s:TResourceStream;
  v:TVerInfo;
begin
  result:='';
  try
    s:=TResourceStream.Create(HInstance,'#1',RT_VERSION);
    if s.Size>0 then begin
      s.Read(v,SizeOf(v));
      result:=IntToStr(v.Major)+'.'+IntToStr(v.Minor)+'.'+
              IntToStr(v.Release)+'.'+IntToStr(v.Build);
    end;
  s.Free;
  except;
  end;
end;

// Live Chart
procedure TMainForm.LiveChartInit();
var
  i : Integer;
  startTime: TDateTime;
  lenArrayLiveData: Integer;
begin
  chtLive.Series[0].Clear;

  startTime := Now();
  chtLive.Series[0].BeginUpdate;
  for i:= 0 to CHARTLIVE_COUNT_POINT do
  begin
    chtLive.Series[0].Add(
        0,
        FormatDateTime(
          'hh:mm',
          IncSecond(startTime, Round(curConfig.weightPassageTime*(CHARTLIVE_COUNT_POINT-i)*-1))
        )
    );
  end;
  chtLive.Series[0].EndUpdate;

  lenArrayLiveData := (CHARTSHIFT_STEP_MINUT*60) div Round(curConfig.weightPassageTime);
  SetLength(arrChartLiveData, lenArrayLiveData);
  indexLiveData := 0;
end;

procedure TMainForm.LiveChartAdd(data: Double);
begin
  chtLive.Series[0].Add(data,FormatDateTime('hh:mm', Now));
  chtLive.BottomAxis.AutomaticMinimum:=false;
  chtLive.BottomAxis.Minimum:=chtLive.BottomAxis.Minimum+1;
end;

// Shift Chart
procedure TMainForm.ShiftChartInit(startShift, endShift : TDateTime);
var
  i : Integer;
  shiftMinut: Integer;
  chartMax: Integer;
begin
  chtSheft.Series[0].Clear;

  SetLength(arrChartShiftData, 0);
  SetLength(arrChartShiftTime, 0);

  shiftMinut := MinutesBetween(endShift, startShift);
  chartMax := shiftMinut div CHARTSHIFT_STEP_MINUT + 1;

  SetLength(arrChartShiftData, chartMax);
  SetLength(arrChartShiftTime, chartMax);

  chtSheft.BottomAxis.Minimum := 0;
  chtSheft.BottomAxis.Maximum := chartMax;
end;

procedure TMainForm.ShiftChartLoadData(LoadAll : Boolean = False);
var
  i : Integer;
begin
  chtSheft.Series[0].BeginUpdate;
  for i := 0 to Length(arrChartShiftData) do
  begin
    chtSheft.Series[0].Add(
      arrChartShiftData[i],
      FormatDateTime('hh:mm', arrChartShiftTime[i] )
    );

    if (LoadAll = False) then
      if (MinutesBetween(Now(), arrChartShiftTime[i]) < 5) then Break;

  end;
  chtSheft.Series[0].EndUpdate;
end;

procedure TMainForm.ShiftChartAdd(data: Double);
var
  i : Integer;
  shiftMinut: Integer;
  chartMax: Integer;

  TimeXPoint: TDateTime;
  Y, M, D, H, Min, Sec, MilSec: Word;
begin
  DecodeDateTime(Now(), Y, M, D, H, Min, Sec, MilSec);
  TimeXPoint := EncodeDateTime(Y, M, D, H, (Min div CHARTSHIFT_STEP_MINUT) * CHARTSHIFT_STEP_MINUT, 0, 0);
  chtSheft.Series[0].Add(data, FormatDateTime('hh:mm', TimeXPoint));
end;



procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  LiveChartAdd(Random(100));
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i : Integer;
  startTime: TDateTime;
begin
  CoInitialize(nil);

  workDirectory := ExtractFileDir(ParamStr(0));
  SetCurrentDir(workDirectory);

  TConfiguratorUnit.doPropertiesConfiguration(
              workDirectory + '\log4delphi.properties');

  log := TLogger.getInstance;
  log.Info('------------------------ START ------------------------');
  log.Info('Config logfile: log4delphi.properties');
  log.info('Version: '+ GetMyVersion);

  Config := TXMLConfig.Create(workDirectory+'\config.xml');


  if Config.Load(curConfig) = True then
  begin
    OpcSimpleClient.ProgID := curConfig.ServerProgId;
    OpcSimpleClient.Groups.Groups[0].Items.Clear;
    OpcSimpleClient.Groups.Groups[0].Items.add(curConfig.OPCTagWeight);
    OpcSimpleClient.Groups.Groups[0].Items.add(curConfig.OPCTagStatus);
    OpcSimpleClient.Groups.Groups[0].Items.add(curConfig.OPCTagConnected);
    OpcSimpleClient.Groups.Groups[0].UpdateRate := curConfig.OPCUpdateRate;
    OpcSimpleClient.Connect;

    changeShift(curConfig);
  end
  else
  begin
      MessageDlg('Не найден файл конфигурации или поврежден.', mtError,[mbOk], 0);
  end;
  {
  changeShift(curConfig);

  LiveChartInit();
  ShiftChartInit(EncodeDateTime(2020, 06, 08, 07, 0, 0, 0), EncodeDateTime(2020, 06, 08, 19, 0, 0, 0));

  startTime:= EncodeDateTime(2020, 06, 08, 07, 0, 0, 0);
  for i:= 0 to 100 do
  begin
    arrChartShiftData[i] := Random(100);
    arrChartShiftTime[i] := IncMinute(startTime, Round(5*i));
  end;

  ShiftChartLoadData(True);

  CountWeight := TCountWeight.Create(7.35, EventChangeWeight); }
end;


procedure EventChangeWeight(weight: Double);
begin
  MainForm.LiveChartAdd(weight);
  MainForm.lbAllWeight.Caption := FloatToStr(weight);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  OpcSimpleClient.Disconnect;
  log.Info('------------------------ STOP -------------------------');
  log.Free;
  CoUninitialize;
end;

procedure TMainForm.OpcSimpleClient1Groups0DataChange(Sender: TOpcGroup;
  ItemIndex: Integer; const NewValue: Variant; NewQuality: Word;
  NewTimestamp: TDateTime);
begin
  Memo1.Lines.Add('change ['+ IntToStr(ItemIndex) +']> ' + OpcSimpleClient.Groups.Groups[0].Items[ItemIndex] + ' = '
   + FloatToStr(OpcSimpleClient.Groups.Groups[0].ItemValue[3]) + ' - '
   + DateTimeToStr(NewTimestamp));
end;

end.
