program VesCoun;

uses
  Forms,
  UMain in 'UMain.pas' {MainForm},
  UWeight in 'UWeight.pas',
  UConfig in 'UConfig.pas',
  UChangeResource in 'UChangeResource.pas' {FormChangeResource},
  UReport in 'UReport.pas' {FormReport},
  USetting in 'USetting.pas' {FormSetting},
  UKeyValue in 'UKeyValue.pas',
  UCharHelp in 'UCharHelp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormChangeResource, FormChangeResource);
  Application.CreateForm(TFormReport, FormReport);
  Application.CreateForm(TFormSetting, FormSetting);
  Application.Run;
end.
