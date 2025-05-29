unit PacMan.Classes.Player;

interface

uses
  FMX.Graphics,
  System.Types,
  System.IOUtils,
  System.SysUtils,

  PacMan.Utils,
  PacMan.Interfaces.Player,
  PacMan.Interfaces.Game;

type
  TPlayer = class(TInterfacedObject, IPlayer)
  private
    FSpeedFactor: Single;
    FPosition: TPointF;
    FDirection: TPointF;
    FNextDirection: TPointF;
    FImages: TArray<TBitmap>;
    FGame: IGame;

    function GetSpeedFactor: Single;
    function GetPosition: TPointF;
    function GetDirection: TPointF;
    function GetNextDirection: TPointF;
    function GetImages: TArray<TBitmap>;
    procedure SetPosition(const AValue: TPointF);
    procedure SetDirection(const AValue: TPointF);
    procedure SetNextDirection(const AValue: TPointF);
    procedure SetImages(const AValue: TArray<TBitmap>);
    procedure LoadImages;
    function PlayerRotation(imageIndex: Integer): TBitmap;
  public
    property SpeedFactor: Single read GetSpeedFactor;
    property Position: TPointF read GetPosition write SetPosition;
    property Direction: TPointF read GetDirection write SetDirection;
    property NextDirection: TPointF read GetNextDirection write SetNextDirection;
    property Images: TArray<TBitmap> read GetImages write SetImages;
    procedure Draw(Canvas: TCanvas);
    procedure CollectDots;
    constructor Create(AGame: IGame);
    destructor Destroy; override;
  end;

implementation

{ TPlayer }

constructor TPlayer.Create(AGame: IGame);
begin
  FGame := AGame;

  FSpeedFactor := 1.5;

  FPosition := PointF(FGame.Settings.Scale * 13.1, FGame.Settings.Scale * 22.6);
  FDirection := PointF(FGame.Settings.Scale / 12 * FSpeedFactor, 0);
  FNextDirection := PointF(FGame.Settings.Scale / 12 * FSpeedFactor, 0);

  LoadImages;
end;

procedure TPlayer.LoadImages;
var
  idxImage: integer;
begin
  SetLength(FImages, 7);

  for idxImage := 0 to 6 do
    CreateSprite(FImages[idxImage], TPath.Combine(GetCurrentDir,
      Format('img\Pac_Man_%d.png', [idxImage + 1])));
end;

procedure TPlayer.CollectDots;
var
  x, y: Integer;
  x_pac_man, y_pac_man: Single;
  x_dot, y_dot, radius: Single;
begin
  x_pac_man := FPosition.X + (FGame.Settings.Scale * 0.65);
  y_pac_man := FPosition.Y + (FGame.Settings.Scale * 0.65);

  for y := 0 to High(FGame.Board.Map) do
  begin
    for x := 0 to High(FGame.Board.Map[0]) do
    begin
      if FGame.Board.Map[y, x] = '.' then
      begin
        x_dot := (x * FGame.Settings.Scale) + (FGame.Settings.Scale / 4);
        y_dot := (y * FGame.Settings.Scale) + (FGame.Settings.Scale / 4);
        radius := FGame.Settings.Scale / 5;
        if (x_pac_man >= x_dot - radius) and (x_pac_man <= x_dot + radius) and
           (y_pac_man >= y_dot - radius) and (y_pac_man <= y_dot + radius) then
        begin
          FGame.Board.Map[y, x] := ' ';
          FGame.Settings.Score := FGame.Settings.Score + 1;
        end;
      end
      else if FGame.Board.Map[y, x] = 'o' then
      begin
        x_dot := (x * FGame.Settings.Scale) + (FGame.Settings.Scale / 4);
        y_dot := (y * FGame.Settings.Scale) + (FGame.Settings.Scale / 4);
        radius := FGame.Settings.Scale / 2;
        if (x_pac_man >= x_dot - radius) and (x_pac_man <= x_dot + radius) and
           (y_pac_man >= y_dot - radius) and (y_pac_man <= y_dot + radius) then
        begin
          FGame.Board.Map[y, x] := ' ';
          FGame.Settings.Score := FGame.Settings.Score + 5;
          FGame.Settings.HarmlessMode := True;

          FGame.GhostManager.PowerPelletCollected;
        end;
      end;
    end;
  end;
end;

destructor TPlayer.Destroy;
var
  i: integer;
begin
  for i := 0 to High(Images) do
    Images[i].Free;

  inherited;
end;

procedure TPlayer.Draw(Canvas: TCanvas);
var
  imageIndex: Integer;
  rotatedBitmap: TBitmap;
  x, y: Single;
begin
  x := Position.X;
  y := Position.Y;

  imageIndex := FGame.Settings.SpriteFrame div FGame.Settings.SpriteSpeed;
  imageIndex := imageIndex mod 7;

  rotatedBitmap := PlayerRotation(imageIndex);
  if Assigned(rotatedBitmap) then
  begin
    Canvas.DrawBitmap(rotatedBitmap,
                      RectF(0, 0, rotatedBitmap.Width, rotatedBitmap.Height),
                      RectF(x, y, x + Round(FGame.Settings.Scale * 1.3), y + Round(FGame.Settings.Scale * 1.3)),
                      1);
    rotatedBitmap.Free; // Free the temporary bitmap
  end;
end;

function TPlayer.GetDirection: TPointF;
begin
  Result := FDirection;
end;

function TPlayer.GetImages: TArray<TBitmap>;
begin
  Result := FImages;
end;

function TPlayer.GetNextDirection: TPointF;
begin
  Result := FNextDirection;
end;

function TPlayer.GetPosition: TPointF;
begin
  Result := FPosition;
end;

function TPlayer.GetSpeedFactor: Single;
begin
  Result := FSpeedFactor;
end;

function TPlayer.PlayerRotation(imageIndex: Integer): TBitmap;
var
  sourceBitmap: TBitmap;
begin
  sourceBitmap := Images[imageIndex];
  Result := TBitmap.Create;
  Result.SetSize(sourceBitmap.Width, sourceBitmap.Height);
  Result.Canvas.BeginScene;
  try
    Result.Canvas.DrawBitmap(sourceBitmap,
                             RectF(0, 0, sourceBitmap.Width, sourceBitmap.Height),
                             RectF(0, 0, Result.Width, Result.Height),
                             1);
  finally
    Result.Canvas.EndScene;
  end;

  // Apply rotation/flip to the Result bitmap
  if (Direction.X > 0) and (Direction.Y = 0) then
  begin
    // Sem rotação (já está para a direita)
  end
  else if (Direction.X = 0) and (Direction.Y > 0) then
  begin
    Result.Rotate(90); // Rotaciona 90 graus para baixo (corrigido)
  end
  else if (Direction.X < 0) and (Direction.Y = 0) then
  begin
    Result.FlipHorizontal; // Inverte horizontalmente para a esquerda
  end
  else if (Direction.X = 0) and (Direction.Y < 0) then
  begin
    Result.Rotate(-90); // Rotaciona -90 graus para cima (corrigido)
  end;
end;

procedure TPlayer.SetDirection(const AValue: TPointF);
begin
  FDirection := AValue;
end;

procedure TPlayer.SetImages(const AValue: TArray<TBitmap>);
begin
  FImages := AValue;
end;

procedure TPlayer.SetNextDirection(const AValue: TPointF);
begin
  FNextDirection := AValue;
end;

procedure TPlayer.SetPosition(const AValue: TPointF);
begin
  FPosition := AValue;
end;

end.

