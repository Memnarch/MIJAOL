program MIJAOL;

uses
  Vcl.Forms,
  Main in 'Main.pas' {ScreenForm},
  Level_1_1.Entities in 'Level_1_1.Entities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TScreenForm, ScreenForm);
  Application.Run;
end.
