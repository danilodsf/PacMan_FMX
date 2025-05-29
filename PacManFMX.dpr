program PacManFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {PacManForm},
  PacMan.uUtils in 'PacMan.uUtils.pas',
  PacMan.Classes.uGhost in 'PacMan.Classes.uGhost.pas',
  PacMan.Classes.Player in 'PacMan.Classes.Player.pas',
  PacMan.Classes.GhostManager in 'PacMan.Classes.GhostManager.pas',
  PacMan.Classes.uGame in 'PacMan.Classes.uGame.pas',
  PacMan.Classes.Settings in 'PacMan.Classes.Settings.pas',
  PacMan.Classes.Movements in 'PacMan.Classes.Movements.pas',
  PacMan.Classes.Board in 'PacMan.Classes.Board.pas',
  PacMan.Interfaces.Game in 'PacMan.Interfaces.Game.pas',
  PacMan.Interfaces.Player in 'PacMan.Interfaces.Player.pas',
  PacMan.Interfaces.Settings in 'PacMan.Interfaces.Settings.pas',
  PacMan.Interfaces.Board in 'PacMan.Interfaces.Board.pas',
  PacMan.Interfaces.Movements in 'PacMan.Interfaces.Movements.pas',
  PacMan.Interfaces.GhostManager in 'PacMan.Interfaces.GhostManager.pas',
  PacMan.Interfaces.Ghost in 'PacMan.Interfaces.Ghost.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TPacManForm, PacManForm);
  Application.Run;
end.
