unit UMain;

//------------------------------------------------------------------------------
                                   interface
//------------------------------------------------------------------------------

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnMan, ActnColorMaps, XPMan, StdCtrls, Menus, ExtCtrls,
  ComCtrls, TeEngine, Series, TeeProcs, Chart, DateUtils, UWeight, TLoggerUnit,
  TConfiguratorUnit, ActiveX, xmldom, XMLIntf, msxmldom, XMLDoc, UConfig,
  prOpcClient, UChangeResource, ToolWin, ActnList, StdActns, ActnCtrls,
  XPStyleActnCtrls, ImgList, USetting;

type
  TMainForm = class(TForm)
    XPManifest: TXPManifest;
    pnlTop: TPanel;
    mmMain: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    GroupBox1: TGroupBox;
    lblWeightAll: TLabel;
    GroupBox2: TGroupBox;
    spl1: TSplitter;
    lblWeightResource: TLabel;
    StatusBar: TStatusBar;
    pnlBottom: TPanel;
    pnlChartShift: TPanel;
    chtSheft: TChart;
    arsrsSeriesShift: TAreaSeries;
    Panel1: TPanel;
    chtLive: TChart;
    arsrsMain: TFastLineSeries;
    Timer1: TTimer;
    OpcSimpleClient: TOpcSimpleClient;
    grp1: TGroupBox;
    lblShift: TLabel;
    spl2: TSplitter;
    lblStatus: TLabel;
    lblResourceName: TLabel;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ilAction16: TImageList;
    ActionList: TActionList;
    actExit: TFileExit;
    actReport: TAction;
    actChangeResource: TAction;
    actResetWeight: TAction;
    N8: TMenuItem;
    ToolBar: TToolBar;
    btnReport: TToolButton;
    ToolButton1: TToolButton;
    btnChangeResource: TToolButton;
    btnResetWeight: TToolButton;
    actInfo: TAction;
    ToolButton2: TToolButton;
    btnInfo: TToolButton;
    actVersion1: TMenuItem;
    actSetting: TAction;
    N9: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OpcSimpleClient1Groups0DataChange(Sender: TOpcGroup;
      ItemIndex: Integer; const NewValue: Variant; NewQuality: Word;
      NewTimestamp: TDateTime);
    procedure lblResourceNameDblClick(Sender: TObject);
    procedure actReportExecute(Sender: TObject);
    procedure actChangeResourceExecute(Sender: TObject);
    procedure actResetWeightExecute(Sender: TObject);
    procedure lblWeightResourceDblClick(Sender: TObject);
    procedure actInfoExecute(Sender: TObject);
    procedure actSettingExecute(Sender: TObject);
    procedure OpcSimpleClientConnect(Sender: TObject);
    procedure OpcSimpleClientDisconnect(Sender: TObject);
    procedure OpcSimpleClientServerShutdown(Sender: TObject);
  private
    { Private declarations }
    procedure LiveChartInit();
    procedure LiveChartAdd(data: Double);

    procedure ShiftChartInit();
    procedure ChangeStatus();
    procedure UpdateViewWeight();


  public
    { Public declarations }
  end;


  procedure EventChangeWeight(weight: Double);

const
  CHARTLIVE_COUNT_POINT = 250;  // Количество отображаемых точек на графике live
  CHARTSHIFT_STEP_MINUT = 5;  // Шаг отображения данных в минутах
  // Controller state
  CONTROLLER_ALARM_TENZO = 1;
  CONTROLLER_WAIT = 0;
  CONTROLLER_WORK = 2;

  // FileName Chart Shift Data
  FILE_CHART_SHIFT_DATA = 'data/shiftChart.dat';

var
  MainForm: TMainForm;
  workDirectory: string;  // Рабочая директория
  log : TLogger;          // Логгер
  Config: IConfig;        // Конфигурация
  curConfig: RConfig;     // Текущая конфигурация

  flagLastUpdateShiftChart: Integer;

  DataWeight: IDataWeight;
  curWeightData: RDataWeight; // Текущий вес
  WeightReset: Double; // Вес для сброса счетчика

  // ID tag opc
  idStatus : Integer;
  idWeight : Integer;

  // Значение тегов
  tagStatus : Integer = CONTROLLER_WAIT;

  CountWeight: TCountWeight; // Учет веса

  // Вычисление среднего
  arrAvgWeight: array of Double;
  avgIndex: Integer;

//------------------------------------------------------------------------------
                                implementation
//------------------------------------------------------------------------------

{$R *.dfm}

uses UReport, Math, UCharHelp;

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
    if s.Size>0 then
    begin
      s.Read(v,SizeOf(v));
      result:=IntToStr(v.Major)+'.'+IntToStr(v.Minor)+'.'+
              IntToStr(v.Release)+'.'+IntToStr(v.Build);
    end;
    s.Free;
  except;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  lenArrAvg: Integer;
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

  flagLastUpdateShiftChart := 0;

  Config := TXMLConfig.Create(workDirectory + '\config.xml');

  if Config.Load(curConfig) = True then
  begin
    log.Info('Config loaded');
    // Получаем смену
    changeShift(curConfig);
    
    // Инициализируем структуру для хранения всех ресурсов и смен
    log.Info('Init structur');
    curWeightData.factor := curConfig.weightFactor;
    curWeightData.curIDResurce := 1;
    curWeightData.factor := 1;
    SetLength(curWeightData.weight, Length(curConfig.workShifts), Length(curConfig.weightNames)+1);

    // Расчет среднего = 60 - секунд в минуте, 30 - таймер Timer1
    lenArrAvg:= Ceil((60 * CHARTSHIFT_STEP_MINUT + 30) / Ceil(curConfig.weightPassageTime)) + 1;
    SetLength(arrAvgWeight, lenArrAvg);
    avgIndex := 0;

    log.Info('Load data weight');
    DataWeight := TXMLDataWeight.Create();
    DataWeight.Load(curConfig.shiftDate, curWeightData);

    WeightReset := 0;
    UpdateViewWeight;

    CountWeight := TCountWeight.Create(curConfig.weightPassageTime, EventChangeWeight);

    // Config OPC Client
    log.Info('Init and connect opc client');
    idStatus := CONTROLLER_WAIT;

    OpcSimpleClient.ProgID := curConfig.ServerProgId;
    OpcSimpleClient.Groups.Groups[0].Items.Clear;

    idWeight := OpcSimpleClient.Groups.Groups[0].Items.add(curConfig.OPCTagWeight);
    idStatus := OpcSimpleClient.Groups.Groups[0].Items.add(curConfig.OPCTagStatus);
    OpcSimpleClient.Groups.Groups[0].UpdateRate := curConfig.OPCUpdateRate;

    OpcSimpleClient.Connect;
    Sleep(500);
    OpcSimpleClient.Groups.Groups[0].Active := True;
    
    log.Info('Init chart');
    LiveChartInit();
    ShiftChartInit();
  end
  else
  begin
     log.Info('Config not loaded. Destroy application.');
     MessageDlg('Не найден файл конфигурации или поврежден.', mtError,[mbOk], 0);
     Application.Free;
  end;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  OpcSimpleClient.Groups.Groups[0].Active := False;
  OpcSimpleClient.Disconnect;
  DataWeight.Save(curConfig.shiftDate, curWeightData);
  log.Info('------------------------ STOP -------------------------');
  log.Free;
  CoUninitialize;
end;

procedure TMainForm.UpdateViewWeight();
begin
  lblShift.Caption := IntToStr(curConfig.shiftId+1);
  lblResourceName.Caption := '  ' + curConfig.weightNames[curWeightData.curIDResurce-1];
  lblWeightResource.Caption := FloatToStrF(
        (
         curWeightData.weight[curConfig.shiftId, curWeightData.curIDResurce] -  WeightReset
        ) * curWeightData.factor,
        ffNumber, 8, 1) + '  ';

  lblWeightAll.Caption := FloatToStrF(
         curWeightData.weight[curConfig.shiftId, 0] * curWeightData.factor,
         ffNumber, 8, 1);
end;

procedure TMainForm.OpcSimpleClient1Groups0DataChange(Sender: TOpcGroup;
  ItemIndex: Integer; const NewValue: Variant; NewQuality: Word;
  NewTimestamp: TDateTime);
begin
  //OpcDataChange(ItemIndex, NewValue);
  if ItemIndex = idWeight then
  begin
    CountWeight.PeriodSetWeight(NewValue, NewTimestamp);
  end;

  if ItemIndex = idStatus then
  begin
    if NewValue <> null then
      tagStatus := NewValue;
    ChangeStatus;
  end;
end;

procedure TMainForm.ChangeStatus();
begin
    case tagStatus  of
      CONTROLLER_ALARM_TENZO:
        begin
          lblStatus.Caption := 'Авария тензодатчика';
          lblStatus.Color := clRed;
          lblStatus.Font.Color := clWhite;
          log.Error('Status: Load cell failure.');
        end;

      CONTROLLER_WAIT:
        begin
          lblStatus.Caption := 'Ожидание';
          lblStatus.Color := clBtnFace;
          lblStatus.Font.Color := clWindowText;
          log.Info('Status: Waiting.');
        end;

      CONTROLLER_WORK:
        begin
          lblStatus.Caption := 'Учет веса';
          lblStatus.Color := clLime; //clBtnFace;
          lblStatus.Font.Color := clWindowText;
          log.Info('Status: Weight accounting.');
        end;
    end;    

end;

procedure EventChangeWeight(weight: Double);
var
  shiftID : Integer;
  resourceID: Integer;
begin

  if tagStatus = CONTROLLER_WORK then
  begin
    shiftID    := curConfig.shiftId;
    resourceID := curWeightData.curIDResurce;

    log.Trace(
        'ShiftID/ResurceID '+ IntToStr(shiftID + 1) +
        '/'+ IntToStr(resourceID) +
        '. Weight = ' + FloatToStr(weight)
        );

    curWeightData.weight[shiftID, 0] := curWeightData.weight[shiftID, 0] + weight;
    curWeightData.weight[shiftID, resourceID] := curWeightData.weight[shiftID, resourceID] + weight;

    MainForm.UpdateViewWeight;
    MainForm.LiveChartAdd(weight);

    // avg
    arrAvgWeight[avgIndex]:= weight;
  end
  else
  begin
    MainForm.LiveChartAdd(0);
    //avg
    arrAvgWeight[avgIndex]:= 0;
  end;

  // avg index
  if avgIndex < Length(arrAvgWeight) then
        inc(avgIndex);

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
end;

procedure TMainForm.LiveChartAdd(data: Double);
begin
  chtLive.Series[0].Add(data,FormatDateTime('hh:mm', Now));
  chtLive.BottomAxis.AutomaticMinimum:=false;
  chtLive.BottomAxis.Minimum:=chtLive.BottomAxis.Minimum+1;
end;

// Shift Chart
procedure TMainForm.ShiftChartInit();
var
  Y, M, D, H, Min, Sec, MilSec: Word;
  aMin, AMax : Double;
begin
  chtSheft.Series[0].Clear;

  DecodeDateTime(Now, Y, M, D, H, Min, Sec, MilSec);

  if curConfig.workShifts[curConfig.shiftId].startHour < curConfig.workShifts[curConfig.shiftId].endHour then
    begin
      AMax := EncodeDateTime(Y, M, D, curConfig.workShifts[curConfig.shiftId].endHour, 0, 0, 0);
      aMin := EncodeDateTime(Y, M, D, curConfig.workShifts[curConfig.shiftId].startHour, 0, 0, 0);
    end
  else
    begin
      aMin := EncodeDateTime(Y, M, D, curConfig.workShifts[curConfig.shiftId].startHour, 0, 0, 0);

      DecodeDateTime(Tomorrow, Y, M, D, H, Min, Sec, MilSec);
      AMax := EncodeDateTime(Y, M, D, curConfig.workShifts[curConfig.shiftId].endHour, 0, 0, 0);
    end;

  chtSheft.BottomAxis.Maximum := AMax;
  chtSheft.BottomAxis.Minimum := aMin;

  // Load Data

  if checkCurrentShiftFile(FILE_CHART_SHIFT_DATA, curConfig.shiftDate, curConfig.shiftId) then
    begin
      LoadPointToChart(FILE_CHART_SHIFT_DATA, chtSheft.Series[0]);
    end
  else
    begin
      if FileExists(FILE_CHART_SHIFT_DATA) then
        if DeleteFile(FILE_CHART_SHIFT_DATA) then
          log.Info('Data Chart Shift cleared (file delete). File: ' + FILE_CHART_SHIFT_DATA)
        else
          log.Error('Data Chart Shift file not delete. File: ' + FILE_CHART_SHIFT_DATA);
    end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  Y, M, D, H, Min, Sec, MilSec: Word;
  i: integer;
  avg: Double;
begin
  DataWeight.Save(curConfig.shiftDate, curWeightData);

  DecodeDateTime(Now, Y, M, D, H, Min, Sec, MilSec);

  if Min = 0 then
  begin
    if changeShift(curConfig) then
    begin
      log.Info('--- New shift ID = '+ IntToStr(curConfig.shiftId) + ' ---');
      ShiftChartInit();
      WeightReset:= 0;
    end;
  end;

  if (Min mod CHARTSHIFT_STEP_MINUT = 0) and (flagLastUpdateShiftChart <> Min) then
  begin
    flagLastUpdateShiftChart := Min;

    // Avg
    avg := 0;
    if avgIndex > 1 then
    begin
      for i:= 0 to avgIndex do
          avg := avg + arrAvgWeight[i];
      avg := Round(avg/avgIndex)
    end;

    chtSheft.Series[0].AddXY(Now, avg);
    avgIndex := 0;

    if AddPointChartToFile(
                        FILE_CHART_SHIFT_DATA,
                        Now,
                        avg,
                        curConfig.shiftDate,
                        curConfig.shiftId)
    then
      log.Trace('Add weight to chart Shift.')
    else
      log.Error('Not save data chart shift to file.');
  end;

end;

procedure TMainForm.lblResourceNameDblClick(Sender: TObject);
begin
  actChangeResource.Execute;
end;


procedure TMainForm.actReportExecute(Sender: TObject);
begin
  FormReport.ShowModal;
end;

procedure TMainForm.actChangeResourceExecute(Sender: TObject);
var
  i: Integer;
begin

  FormChangeResource.cbbResource.Items.BeginUpdate;
  FormChangeResource.cbbResource.Items.Clear;
  for i:= 0 to Length(curConfig.weightNames) do
  begin
    FormChangeResource.cbbResource.Items.Add(curConfig.weightNames[i]);
  end;
  FormChangeResource.cbbResource.Items.EndUpdate;

  if FormChangeResource.ShowModal = mrYes then
  begin
    if curWeightData.curIDResurce <> FormChangeResource.cbbResource.ItemIndex+1 then
    begin
        log.Info('Change resource. New ID = ' + IntToStr(FormChangeResource.cbbResource.ItemIndex+1));
        curWeightData.curIDResurce := FormChangeResource.cbbResource.ItemIndex+1;
        DataWeight.Save(curConfig.shiftDate, curWeightData);
        WeightReset:= 0;
        MainForm.UpdateViewWeight;
    end;
  end;

end;

procedure TMainForm.actResetWeightExecute(Sender: TObject);
begin
    if MessageDlg('Сбросить счетчик?',  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
        WeightReset := curWeightData.weight[curConfig.shiftId, curWeightData.curIDResurce];
        log.Info('Reset count resource. WeightReset = ' + FloatToStr(WeightReset));
        UpdateViewWeight;
    end;
end;

procedure TMainForm.lblWeightResourceDblClick(Sender: TObject);
begin
  actResetWeight.Execute;
end;

procedure TMainForm.actInfoExecute(Sender: TObject);
var
  msgvar: string;
begin
  msgvar:= 'Версия ' + GetMyVersion + #13#10 + 'ПО "Учет веса" 2020г.';
  MessageBox(Handle, PAnsiChar(msgvar), 'Версия', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
end;

procedure TMainForm.actSettingExecute(Sender: TObject);
begin
  if FormSetting.ShowModal = mrYes then
  begin
    WeightReset := 0;
    if Config.Save(curConfig) and DataWeight.Save(curConfig.shiftDate, curWeightData) then
    begin
      log.Info('Config save.');
      MessageDlg('Конфигурация сохранена.' + #13#10 +
       'Перезапустите программу.',  mtInformation, [mbOK], 0);
    end
    else
    begin
     log.Info('Config not save.');
     MessageDlg('Ошибка сохранения конфигурации.',  mtError, [mbOK], 0);
    end;
     

  end;
end;

procedure TMainForm.OpcSimpleClientConnect(Sender: TObject);
begin
  log.Info('Opc client - Connect');
end;

procedure TMainForm.OpcSimpleClientDisconnect(Sender: TObject);
begin
  log.Warn('Opc client - Disconnect');
end;

procedure TMainForm.OpcSimpleClientServerShutdown(Sender: TObject);
begin
  log.Warn('Opc client - Server shutdown');
end;

end.
