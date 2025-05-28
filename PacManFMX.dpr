program PacManFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {PacManForm},
  uGhost in 'uGhost.pas',
  uPlayer in 'uPlayer.pas',
  uGhostManager in 'uGhostManager.pas',
  uUtils in 'uUtils.pas',
  uGame in 'uGame.pas',
  uSettings in 'uSettings.pas',
  uMovements in 'uMovements.pas',
  uBoard in 'uBoard.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TPacManForm, PacManForm);
  Application.Run;
end.
