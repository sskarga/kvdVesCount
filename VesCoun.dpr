program VesCoun;

uses
  Forms,
  Windows,
  Dialogs,
  UMain in 'UMain.pas' {MainForm},
  UWeight in 'UWeight.pas',
  UConfig in 'UConfig.pas',
  UChangeResource in 'UChangeResource.pas' {FormChangeResource},
  UReport in 'UReport.pas' {FormReport},
  USetting in 'USetting.pas' {FormSetting},
  UKeyValue in 'UKeyValue.pas',
  UCharHelp in 'UCharHelp.pas';

{$R *.res}

var
 H: THandle;

begin
   // Запрет на запуск нескольких копий
  H := CreateMutex(nil, True, 'Ves2342');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    showmessage('Программа уже запущена!');
    Exit;
  end;


  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormChangeResource, FormChangeResource);
  Application.CreateForm(TFormReport, FormReport);
  Application.CreateForm(TFormSetting, FormSetting);
  Application.Run;
end.
