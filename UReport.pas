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
