program VesCoun;

uses
  Forms,
  UMain in 'UMain.pas' {MainForm},
  UWeight in 'UWeight.pas',
  UConfig in 'UConfig.pas',
  UChangeResource in 'UChangeResource.pas' {FormChangeResource},
  UReport in 'UReport.pas' {FormReport};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormChangeResource, FormChangeResource);
  Application.CreateForm(TFormReport, FormReport);
  Application.Run;
end.
