unit UReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, frxClass, UMain, UConfig;

type
  TFormReport = class(TForm)
    DateTimePicker: TDateTimePicker;
    btnCreateReport: TBitBtn;
    frxReport: TfrxReport;
    frxUserDataSet: TfrxUserDataSet;
    procedure btnCreateReportClick(Sender: TObject);
    procedure frxReportGetValue(const VarName: String; var Value: Variant);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormReport: TFormReport;
  ReportWeightData: RDataWeight;
  ReadDataWeight: IDataWeight;

implementation

{$R *.dfm}

{

procedure TMainForm.N3Click(Sender: TObject);
begin
  frxReport.Variables.Clear;
  frxReport.Variables[' ' + 'My Report'] := Null;
  frxReport.Variables['Date Period'] := 'DatePeriod';
  frxReport.ShowReport;
end;

procedure TMainForm.frxReportBeforePrint(Sender: TfrxReportComponent);
var
  Cross: TfrxCrossView;
  i, j: Integer;
begin
  if Sender is TfrxCrossView then
  begin
    Cross := TfrxCrossView(Sender);

    for i:= 0 to 10 do
    begin
      Cross.AddValue([i], ['Coll1'], [1]);
      Cross.AddValue([i], ['Coll2'], [2]);
      Cross.AddValue([i], ['Coll3'], [3]);
      Cross.AddValue([i], ['Coll4'], [4]);
    end;
  end;
end;

procedure TMainForm.frxReportGetValue(const VarName: String;
  var Value: Variant);
begin
  if CompareText(VarName, 'DatePeriod') = 0 then Value := DateTimeToStr(Now);
end;

procedure TMainForm.frxUserDataSet1GetValue(const VarName: String;
  var Value: Variant);
begin

if VarName = 'Column1' then
    Value := getPropertyByIndex(frxUserDataSet2.RecNo, 1)
  else if VarName = 'Column2' then
    Value := getPropertyByIndex(frxUserDataSet2.RecNo, 2)
  else if VarName = 'Column3' then
    Value := getPropertyByIndex(frxUserDataSet2.RecNo, 3)

end;

}

procedure TFormReport.btnCreateReportClick(Sender: TObject);
begin
    ReadDataWeight := TXMLDataWeight.Create();
    if ReadDataWeight.Load(DateTimePicker.DateTime, ReportWeightData) then
    begin
      frxUserDataSet.RangeEnd := reCount;
      frxUserDataSet.RangeEndCount := Length(ReportWeightData.weight[0])-1;
      frxReport.ShowReport;
    end
    else
    begin
      MessageDlg('Данные не найдены.',  mtWarning, [mbOK], 0);
    end;
end;

procedure TFormReport.frxReportGetValue(const VarName: String;
  var Value: Variant);
begin
  if CompareText(VarName, 'DateReport') = 0 then Value := DateToStr(DateTimePicker.DateTime);

  if CompareText(VarName, 'id') = 0 then
    Value := frxUserDataSet.RecNo + 1;

  if CompareText(VarName, 'name') = 0 then
    Value := curConfig.weightNames[frxUserDataSet.RecNo];

  if CompareText(VarName, 'resshift1') = 0 then
    Value := ReportWeightData.weight[0,frxUserDataSet.RecNo+1] * ReportWeightData.factor;

  if CompareText(VarName, 'resshift2') = 0 then
    Value := ReportWeightData.weight[1,frxUserDataSet.RecNo+1] * ReportWeightData.factor;

  if CompareText(VarName, 'resshift') = 0 then
    Value := (
                ReportWeightData.weight[0, frxUserDataSet.RecNo+1] +
                ReportWeightData.weight[1, frxUserDataSet.RecNo+1]
              ) * ReportWeightData.factor;

  if CompareText(VarName, 'resultshift1') = 0 then
    Value := ReportWeightData.weight[0, 0] * ReportWeightData.factor;

  if CompareText(VarName, 'resultshift2') = 0 then
    Value := ReportWeightData.weight[1, 0] * ReportWeightData.factor;

  if CompareText(VarName, 'resultshift') = 0 then
    Value := (ReportWeightData.weight[0, 0] + ReportWeightData.weight[1, 0]) * ReportWeightData.factor;
end;

procedure TFormReport.FormShow(Sender: TObject);
begin
    DateTimePicker.DateTime := Now;
end;

end.
