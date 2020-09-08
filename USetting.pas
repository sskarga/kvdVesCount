unit USetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Mask, Grids;

type
  TFormSetting = class(TForm)
    PageControl: TPageControl;
    tsFactor: TTabSheet;
    tsConnect: TTabSheet;
    tsShift: TTabSheet;
    tsResource: TTabSheet;
    btnSave: TBitBtn;
    BitBtnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtCalcInput: TEdit;
    edtCalcOut: TEdit;
    lbl4: TLabel;
    btnCalc: TBitBtn;
    GroupBox2: TGroupBox;
    lbl5: TLabel;
    Label1: TLabel;
    edtIdOpc: TEdit;
    lbl6: TLabel;
    edtTegWeight: TEdit;
    lbl7: TLabel;
    edtTagStatus: TEdit;
    lbl8: TLabel;
    edtOpcRate: TEdit;
    lbl9: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    grp1: TGroupBox;
    lbl10: TLabel;
    lbl11: TLabel;
    grp2: TGroupBox;
    lbl12: TLabel;
    lbl13: TLabel;
    ListBoxWeight: TListBox;
    edtFieldRes: TEdit;
    BitBtn1: TBitBtn;
    BitDelete: TBitBtn;
    btnEdit: TBitBtn;
    edtShift1Begin: TEdit;
    edtShift1End: TEdit;
    edtShift2Begin: TEdit;
    edtShift2End: TEdit;
    edtFactor: TEdit;
    edtPassageTime: TEdit;
    procedure edtFloatKeyPress(Sender: TObject; var Key: Char);
    procedure edtIntKeyPress(Sender: TObject; var Key: Char);
    procedure btnCalcClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtShift1Begin1Exit(Sender: TObject);
    procedure edtShift1End1Exit(Sender: TObject);
    procedure edtShift2Begin1Exit(Sender: TObject);
    procedure edtShift2End1Exit(Sender: TObject);
    procedure ListBoxWeightDblClick(Sender: TObject);
    procedure BitDeleteClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FormSetting: TFormSetting;

implementation

{$R *.dfm}

uses
  UConfig, UMain, Math;

procedure TFormSetting.edtFloatKeyPress(Sender: TObject; var Key: Char);
var
  k: integer;
begin
  if TEdit(Sender).Text = '0' then
    if not (key in [',', #8]) then
      key := #0;

  if key in ['0'..'9', ',', #8] then
  begin
    if key = ',' then
    begin
      if TEdit(Sender).Text = '' then
        key := #0;
      for k := 1 to Length(TEdit(Sender).Text) do
      begin
        if TEdit(Sender).Text[k] = ',' then
          key := #0;
      end;
    end;
  end
  else
    key := #0;
end;

procedure TFormSetting.edtIntKeyPress(Sender: TObject; var Key: Char);var
  k: integer;
begin
  if TEdit(Sender).Text = '0' then
    if not (key in [#8]) then
      key := #0;

  if key in ['0'..'9', #8] then
  begin
    if key = ',' then
    begin
      if TEdit(Sender).Text = '' then
        key := #0;
      for k := 1 to Length(TEdit(Sender).Text) do
      begin
        if TEdit(Sender).Text[k] = ',' then
          key := #0;
      end;
    end;
  end
  else
    key := #0;
end;

procedure TFormSetting.btnCalcClick(Sender: TObject);
var
  tfactor: Double;
  valIn  : Double;
  valOut : Double;
begin
  tfactor:= curConfig.weightFactor;

  try
    valIn := StrToFloat(edtCalcInput.Text);
    valOut:= StrToFloat(edtCalcOut.Text);
    tfactor:= RoundTo( (valOut / ( valIn / tfactor)) , -2);
  except
    MessageDlg('Ошибка входных данных',  mtError, [mbOK], 0);
  end;

  edtFactor.Text:= FloatToStr(tfactor);
end;

procedure TFormSetting.FormShow(Sender: TObject);
var
  i: Integer;
begin
  PageControl.ActivePageIndex := 0;
  edtFactor.Text := FloatToStr(curConfig.weightFactor);
  edtCalcInput.Text := '1';
  edtCalcOut.Text := '1';
  edtPassageTime.Text :=  FloatToStr(curConfig.weightPassageTime);
  edtIdOpc.Text := curConfig.ServerProgId;
  edtTegWeight.Text := curConfig.OPCTagWeight;
  edtTagStatus.Text := curConfig.OPCTagStatus;
  edtOpcRate.Text := IntToStr(curConfig.OPCUpdateRate);
  edtShift1Begin.Text  := IntToStr(curConfig.workShifts[0].startHour);
  edtShift1End.Text  := IntToStr(curConfig.workShifts[0].endHour);
  edtShift2Begin.Text  := IntToStr(curConfig.workShifts[1].startHour);
  edtShift2End.Text  := IntToStr(curConfig.workShifts[1].endHour);

  ListBoxWeight.Items.Clear;
  for i:=0 to Length(curConfig.weightNames) - 1 do
  begin
    ListBoxWeight.Items.add(curConfig.weightNames[i]);
  end;
end;

procedure TFormSetting.edtShift1Begin1Exit(Sender: TObject);
begin
    if StrToInt(edtShift1Begin.Text) > 23 then
        edtShift1Begin.Text:= IntToStr(curConfig.workShifts[0].startHour);
end;

procedure TFormSetting.edtShift1End1Exit(Sender: TObject);
begin
   if StrToInt(edtShift1End.Text) > 23 then
        edtShift1End.Text:= IntToStr(curConfig.workShifts[0].endHour);

   edtShift2Begin.Text := edtShift1End.Text;
end;

procedure TFormSetting.edtShift2Begin1Exit(Sender: TObject);
begin
   if StrToInt(edtShift2Begin.Text) > 23 then
        edtShift2Begin.Text:= IntToStr(curConfig.workShifts[1].startHour);

   edtShift1End.Text := edtShift2Begin.Text;
end;

procedure TFormSetting.edtShift2End1Exit(Sender: TObject);
begin
   if StrToInt(edtShift2End.Text) > 23 then
        edtShift2End.Text:= IntToStr(curConfig.workShifts[1].endHour);
end;

procedure TFormSetting.ListBoxWeightDblClick(Sender: TObject);
begin
  edtFieldRes.Text := ListBoxWeight.Items[ListBoxWeight.ItemIndex];
  if (ListBoxWeight.Items.Count - 1) = ListBoxWeight.ItemIndex then
    BitDelete.Enabled := True
  else
    BitDelete.Enabled := False;
end;

procedure TFormSetting.BitDeleteClick(Sender: TObject);
begin
  if MessageDlg('Внимание! Удаление элемента в середине или в начале списка' + #13#10 +
   'приведет к изменению индексов - сопоставление ресурса и веса.' + #13#10 +
   'Удалить?', 
    mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    ListBoxWeight.Items.Delete(ListBoxWeight.ItemIndex);
  end;
end;

procedure TFormSetting.BitBtn1Click(Sender: TObject);
begin
    ListBoxWeight.Items.add(Trim(edtFieldRes.Text));
end;

procedure TFormSetting.btnEditClick(Sender: TObject);
begin
   ListBoxWeight.Items[ListBoxWeight.ItemIndex] := edtFieldRes.Text;
end;

procedure TFormSetting.btnSaveClick(Sender: TObject);
var
  i: Integer;
begin
  PageControl.ActivePageIndex := 0;
  curConfig.weightFactor:= StrToFloat(edtFactor.Text);
  curWeightData.factor:= curConfig.weightFactor;

  curConfig.weightPassageTime := StrToFloat(edtPassageTime.Text);

  curConfig.ServerProgId := edtIdOpc.Text;
  curConfig.OPCTagWeight := edtTegWeight.Text;
  curConfig.OPCTagStatus := edtTagStatus.Text;
  curConfig.OPCUpdateRate := StrToInt(edtOpcRate.Text);

  curConfig.workShifts[0].startHour := StrToInt(edtShift1Begin.Text);
  curConfig.workShifts[0].endHour  := StrToInt(edtShift1End.Text);
  curConfig.workShifts[1].startHour := StrToInt(edtShift2Begin.Text);
  curConfig.workShifts[1].endHour  := StrToInt(edtShift2End.Text);

  SetLength(curConfig.weightNames, ListBoxWeight.Items.Count);

  for i:=0 to ListBoxWeight.Items.Count - 1 do
  begin
    curConfig.weightNames[i] := ListBoxWeight.Items[i];
  end;
end;

end.
