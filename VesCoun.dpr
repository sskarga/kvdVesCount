program VesCoun;

uses
  Forms,
  UMain in 'UMain.pas' {MainForm},
  UWeight in 'UWeight.pas',
  UConfig in 'UConfig.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
