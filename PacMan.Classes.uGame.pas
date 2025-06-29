unit PacMan.Classes.uGame;

interface

uses
  System.Types,
  System.UITypes,
  System.SysUtils,
  System.Math,
  FMX.Graphics,
  FMX.Objects,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  PacMan.Interfaces.Game,
  PacMan.Interfaces.Player,
  PacMan.Interfaces.Settings,
  PacMan.Interfaces.Board,
  PacMan.Interfaces.GhostManager,
  PacMan.Interfaces.Movements;

type
  TGame = class(TInterfacedObject, IGame)
  private
  class var
    FGame: IGame;
    FSettings: ISettings;
    FPlayer: IPlayer;
    FGhostManager: IGhostManager;
    FMovements: IMovements;
    FBoard: IBoard;
    FMainForm: TForm;
    PaintBox: TPaintBox;
    Timer: TTimer;
    procedure Setup(AMainForm: TForm);
    procedure PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
    procedure TimerTimer(Sender: TObject);
    procedure ClearWindow(Canvas: TCanvas);
    procedure GhostAndPacmanCollision;
    procedure RestartAfterGhostCollision;
    procedure CollectAllDots;
    procedure AnimationStep;
    procedure RestartGame;
  public
    procedure MovePlayer(key: Word; KeyChar: Char);
    procedure StartGame;

    function Player: IPlayer;
    function Settings: ISettings;
    function GhostManager: IGhostManager;
    function Board: IBoard;
    function Movements: IMovements;

    constructor Create(AMainForm: TForm);
    destructor Destroy; override;

    class function New(AMainForm: TForm): IGame;
  end;

implementation

uses
  PacMan.Classes.Settings, PacMan.Classes.Board, PacMan.Classes.Player,
  PacMan.Classes.Movements, PacMan.Classes.GhostManager;

{ TGame }

constructor TGame.Create(AMainForm: TForm);
begin
  FMainForm := AMainForm;
  PaintBox := TPaintBox.Create(AMainForm);
  PaintBox.Parent := AMainForm;
  Timer := TTimer.Create(AMainForm);
end;

destructor TGame.Destroy;
begin
  inherited;
end;

function TGame.Settings: ISettings;
begin
  result := FSettings;
end;

procedure TGame.Setup(AMainForm: TForm);
begin
  // Configure Form and PaintBox
  AMainForm.Width := Round(Settings.Scale * 27.5);
  AMainForm.Height := Round(Settings.Scale * 34.8);
  AMainForm.Caption := 'Pac-Man FMX';
  AMainForm.Position := TFormPosition.ScreenCenter;

  PaintBox.Align := TAlignLayout.Client;
  PaintBox.Width := AMainForm.Width;
  PaintBox.Height := AMainForm.Height;
  PaintBox.OnPaint := PaintBoxPaint;

  Timer.Interval := 1000 div 60; // 60 FPS
  Timer.OnTimer := TimerTimer;
  Timer.Enabled := True;
end;

procedure TGame.StartGame;
begin
  Board.LoadMap;
  Setup(FMainForm);
end;

procedure TGame.TimerTimer(Sender: TObject);
begin
  PaintBox.Repaint;
end;

procedure TGame.PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
var
  temp_pos, temp_dir: TPointF;
begin
  ClearWindow(Canvas);
  Board.Draw(Canvas);
  Player.CollectDots;
  temp_pos := Player.Position;
  temp_dir := Player.Direction;
  Movements.Tunnel(temp_pos);
  Movements.Collider(temp_pos, Player.Direction);
  Movements.TurningCorner(temp_pos, temp_dir, Player.NextDirection);
  Player.Position := temp_pos;
  Player.Direction := temp_dir;
  Player.Draw(Canvas);
  GhostManager.Execute(Canvas);
  GhostManager.GhostAI;
  GhostAndPacmanCollision;
  RestartAfterGhostCollision;
  Board.DrawScoreboard(Canvas);
  CollectAllDots;
  AnimationStep;
end;

function TGame.Board: IBoard;
begin
  result := FBoard;
end;

function TGame.Player: IPlayer;
begin
  result := FPlayer;
end;

procedure TGame.ClearWindow(Canvas: TCanvas);
begin
  Canvas.Fill.Color := TAlphaColors.Black;
  Canvas.FillRect(FMainForm.ClientRect, 0, 0, AllCorners, 1);
end;

procedure TGame.GhostAndPacmanCollision;
begin
  if GhostManager.DistanceGhostToPacMan(GhostManager.blueGhost) <= (Settings.Scale * 1.1) then
  begin
    if GhostManager.blueGhost.harmlessMode then
    begin
      GhostManager.blueGhost.Position := PointF(Settings.Scale * 12, Settings.Scale * 13);
      GhostManager.blueGhost.harmlessMode := False;
      GhostManager.blueGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
        (GhostManager.blueGhost);
      Settings.Score := Settings.Score + 10;
    end
    else
    begin
      if not Settings.EndGame then
      begin
        Settings.SpriteFrame := 0;
        Settings.SpriteSpeed := 1;
        Settings.Lives := Settings.Lives - 1;
      end;
      Settings.EndGame := True;
    end;
  end
  else if GhostManager.DistanceGhostToPacMan(GhostManager.OrangeGhost) <= (Settings.Scale * 1.1)
  then
  begin
    if GhostManager.OrangeGhost.harmlessMode then
    begin
      GhostManager.OrangeGhost.Position := PointF(Settings.Scale * 12, Settings.Scale * 14.5);
      GhostManager.OrangeGhost.harmlessMode := False;
      GhostManager.OrangeGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
        (GhostManager.OrangeGhost);
      Settings.Score := Settings.Score + 10;
    end
    else
    begin
      if not Settings.EndGame then
      begin
        Settings.SpriteFrame := 0;
        Settings.SpriteSpeed := 1;
        Settings.Lives := Settings.Lives - 1;
      end;
      Settings.EndGame := True;
    end;
  end
  else if GhostManager.DistanceGhostToPacMan(GhostManager.PinkGhost) <= (Settings.Scale * 1.1) then
  begin
    if GhostManager.PinkGhost.harmlessMode then
    begin
      GhostManager.PinkGhost.Position := PointF(Settings.Scale * 14, Settings.Scale * 13);
      GhostManager.PinkGhost.harmlessMode := False;
      GhostManager.PinkGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
        (GhostManager.PinkGhost);
      Settings.Score := Settings.Score + 10;
    end
    else
    begin
      if not Settings.EndGame then
      begin
        Settings.SpriteFrame := 0;
        Settings.SpriteSpeed := 1;
        Settings.Lives := Settings.Lives - 1;
      end;
      Settings.EndGame := True;
    end;
  end
  else if GhostManager.DistanceGhostToPacMan(GhostManager.RedGhost) <= (Settings.Scale * 1.1) then
  begin
    if GhostManager.RedGhost.harmlessMode then
    begin
      GhostManager.RedGhost.Position := PointF(Settings.Scale * 14, Settings.Scale * 14.5);
      GhostManager.RedGhost.harmlessMode := False;
      GhostManager.RedGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
        (GhostManager.RedGhost);
      Settings.Score := Settings.Score + 10;
    end
    else
    begin
      if not Settings.EndGame then
      begin
        Settings.SpriteFrame := 0;
        Settings.SpriteSpeed := 1;
        Settings.Lives := Settings.Lives - 1;
      end;
      Settings.EndGame := True;
    end;
  end;
end;

function TGame.GhostManager: IGhostManager;
begin
  result := FGhostManager;
end;

procedure TGame.RestartAfterGhostCollision;
begin
  if (FSettings.SpriteFrame = 60) and FSettings.EndGame and (FSettings.Lives > -1) then
  begin
    FSettings.EndGame := False;
    FSettings.harmlessMode := False;
    GhostManager.blueGhost.harmlessMode := False;
    GhostManager.OrangeGhost.harmlessMode := False;
    GhostManager.PinkGhost.harmlessMode := False;
    GhostManager.RedGhost.harmlessMode := False;
    GhostManager.blueGhost.HarmlessModeTimer := 0;
    GhostManager.OrangeGhost.HarmlessModeTimer := 0;
    GhostManager.PinkGhost.HarmlessModeTimer := 0;
    GhostManager.RedGhost.HarmlessModeTimer := 0;
    Player.Position := PointF(FSettings.Scale * 13.1, FSettings.Scale * 22.6);
    Player.Direction := PointF(FSettings.Scale / 12 * Player.SpeedFactor, 0);
    Player.NextDirection := PointF(FSettings.Scale / 12 * Player.SpeedFactor, 0);
    GhostManager.blueGhost.Position := PointF(FSettings.Scale * 12, FSettings.Scale * 13);
    GhostManager.OrangeGhost.Position := PointF(FSettings.Scale * 12, FSettings.Scale * 14.5);
    GhostManager.PinkGhost.Position := PointF(FSettings.Scale * 14, FSettings.Scale * 13);
    GhostManager.RedGhost.Position := PointF(FSettings.Scale * 14, FSettings.Scale * 14.5);
    GhostManager.blueGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.blueGhost);
    GhostManager.OrangeGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.OrangeGhost);
    GhostManager.PinkGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.PinkGhost);
    GhostManager.RedGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.RedGhost);
    FSettings.SpriteSpeed := 2;
    FSettings.EndGame := False; // Redefinir novamente para garantir
  end;
end;

procedure TGame.CollectAllDots;
var
  count: Integer;
  y, x: Integer;
begin
  count := 0;
  for y := 0 to High(Board.Map) do
  begin
    for x := 0 to High(Board.Map[0]) do
    begin
      if (Board.Map[y, x] = '.') or (Board.Map[y, x] = 'o') then
        Inc(count);
    end;
  end;

  if count = 0 then
  begin
    // Reinicia o n�vel (mant�m a pontua��o e vidas, mas reseta o mapa e posi��es)
    Settings.EndGame := False;
    Settings.harmlessMode := False;
    GhostManager.blueGhost.harmlessMode := False;
    GhostManager.OrangeGhost.harmlessMode := False;
    GhostManager.PinkGhost.harmlessMode := False;
    GhostManager.RedGhost.harmlessMode := False;
    GhostManager.blueGhost.HarmlessModeTimer := 0;
    GhostManager.OrangeGhost.HarmlessModeTimer := 0;
    GhostManager.PinkGhost.HarmlessModeTimer := 0;
    GhostManager.RedGhost.HarmlessModeTimer := 0;
    Player.Position := PointF(Settings.Scale * 13.1, Settings.Scale * 22.6);
    Player.Direction := PointF(Settings.Scale / 12 * Player.SpeedFactor, 0);
    Player.NextDirection := PointF(Settings.Scale / 12 * Player.SpeedFactor, 0);
    GhostManager.blueGhost.Position := PointF(Settings.Scale * 12, Settings.Scale * 13);
    GhostManager.OrangeGhost.Position := PointF(Settings.Scale * 12, Settings.Scale * 14.5);
    GhostManager.PinkGhost.Position := PointF(Settings.Scale * 14, Settings.Scale * 13);
    GhostManager.RedGhost.Position := PointF(Settings.Scale * 14, Settings.Scale * 14.5);
    GhostManager.blueGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.blueGhost);
    GhostManager.OrangeGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.OrangeGhost);
    GhostManager.PinkGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.PinkGhost);
    GhostManager.RedGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
      (GhostManager.RedGhost);
    Settings.SpriteSpeed := 2;
    Settings.EndGame := False;

    // Recarrega o mapa para o estado inicial
    Board.LoadMap;
  end;
end;

procedure TGame.AnimationStep;
begin
  if FSettings.SpriteFrame = 60 then
    FSettings.SpriteFrame := 0
  else
    FSettings.SpriteFrame := FSettings.SpriteFrame + FSettings.SpriteSpeed;
end;

function TGame.Movements: IMovements;
begin
  result := FMovements;
end;

procedure TGame.MovePlayer(key: Word; KeyChar: Char);
begin
  if Settings.EndGame then
    Exit; // N�o permite movimento se o jogo terminou

  case UpCase(KeyChar) of
    'R':
      RestartGame;
    'W':
      begin
        Movements.MoveUp;
        Exit;
      end;
    'A':
      begin
        Movements.MoveLeft;
        Exit;
      end;
    'S':
      begin
        Movements.MoveDown;
        Exit;
      end;
    'D':
      begin
        Movements.MoveRight;
        Exit;
      end;
  end;

  case key of
    VKUP:
      begin
        Movements.MoveUp;
        Exit;
      end;
    VKLEFT:
      begin
        Movements.MoveLeft;
        Exit;
      end;
    VKDOWN:
      begin
        Movements.MoveDown;
        Exit;
      end;
    VKRIGHT:
      begin
        Movements.MoveRight;
        Exit;
      end;
    VKESCAPE:
      Application.Terminate;
  end;
end;

class function TGame.New(AMainForm: TForm): IGame;
begin
  if not Assigned(FGame) then
  begin
    FGame := Self.Create(AMainForm);
    FSettings := TSettings.Create;
    FBoard := TBoard.Create(FGame);
    FPlayer := TPlayer.Create(FGame);
    FMovements := TMovements.Create(FGame);
    FGhostManager := TGhostManager.Create(FGame);
  end;

  result := FGame;
end;

procedure TGame.RestartGame;
begin
  Settings.SpriteFrame := 0;
  Settings.SpriteSpeed := 2;
  Settings.Score := 0;
  Settings.Lives := 5;
  Settings.EndGame := False;
  Settings.harmlessMode := False;
  GhostManager.blueGhost.harmlessMode := False;
  GhostManager.OrangeGhost.harmlessMode := False;
  GhostManager.PinkGhost.harmlessMode := False;
  GhostManager.RedGhost.harmlessMode := False;
  GhostManager.blueGhost.HarmlessModeTimer := 0;
  GhostManager.OrangeGhost.HarmlessModeTimer := 0;
  GhostManager.PinkGhost.HarmlessModeTimer := 0;
  GhostManager.RedGhost.HarmlessModeTimer := 0;
  Player.Position := PointF(Settings.Scale * 13.1, Settings.Scale * 22.6);
  Player.Direction := PointF(Settings.Scale / 12 * Player.SpeedFactor, 0);
  Player.NextDirection := PointF(Settings.Scale / 12 * Player.SpeedFactor, 0);
  GhostManager.blueGhost.Position := PointF(Settings.Scale * 12, Settings.Scale * 13);
  GhostManager.OrangeGhost.Position := PointF(Settings.Scale * 12, Settings.Scale * 14.5);
  GhostManager.PinkGhost.Position := PointF(Settings.Scale * 14, Settings.Scale * 13);
  GhostManager.RedGhost.Position := PointF(Settings.Scale * 14, Settings.Scale * 14.5);
  GhostManager.blueGhost.Direction := PointF(0, 0);
  GhostManager.OrangeGhost.Direction := PointF(0, 0);
  GhostManager.PinkGhost.Direction := PointF(0, 0);
  GhostManager.RedGhost.Direction := PointF(0, 0);
  GhostManager.blueGhost.NextDirection := PointF(0, 0);
  GhostManager.OrangeGhost.NextDirection := PointF(0, 0);
  GhostManager.PinkGhost.NextDirection := PointF(0, 0);
  GhostManager.RedGhost.NextDirection := PointF(0, 0);
  GhostManager.blueGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
    (GhostManager.blueGhost);
  GhostManager.OrangeGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
    (GhostManager.OrangeGhost);
  GhostManager.PinkGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
    (GhostManager.PinkGhost);
  GhostManager.RedGhost.DistanceToPacMan := GhostManager.DistanceGhostToPacMan
    (GhostManager.RedGhost);

  // Reset map to initial state
  Board.LoadMap;
end;

end.
