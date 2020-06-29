unit UReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, frxClass;

type
  TFormReport = class(TForm)
    DateTimePicker1: TDateTimePicker;
    BitBtn1: TBitBtn;
    frxReport: TfrxReport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormReport: TFormReport;

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

end.
