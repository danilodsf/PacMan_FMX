unit uPlayer;

interface

uses
  System.Types, FMX.Graphics, uUtils, System.IOUtils, System.SysUtils,
  uSettings, uBoard;

type
  THarmlessGhostsProc = procedure of object;

type
  TPlayer = class
  private
    FSpeedFactor: Single;
    FPosition: TPointF;
    FDirection: TPointF;
    FNextDirection: TPointF;
    FImages: TArray<TBitmap>;
    FSettings: TSettings;
    FBoard: TBoard;
    FOnPowerPelletCollected: THarmlessGhostsProc;
    procedure LoadImages;
    function PlayerRotation(imageIndex: Integer): TBitmap;
  public
    property SpeedFactor: Single read FSpeedFactor;
    property Position: TPointF read FPosition write FPosition;
    property Direction: TPointF read FDirection write FDirection;
    property NextDirection: TPointF read FNextDirection write FNextDirection;
    property Images: TArray<TBitmap> read FImages write FImages;
    property OnPowerPelletCollected: THarmlessGhostsProc read FOnPowerPelletCollected write FOnPowerPelletCollected;

    procedure Draw(Canvas: TCanvas);
    procedure CollectDots;
    constructor Create(ASettings: TSettings; ABoard: TBoard);
    destructor Destroy; override;
  end;

implementation

{ TPlayer }

constructor TPlayer.Create(ASettings: TSettings; ABoard: TBoard);
begin
  FSettings := ASettings;
  FBoard := ABoard;

  FSpeedFactor := 1.5;

  FPosition := PointF(FSettings.Scale * 13.1, FSettings.Scale * 22.6);
  FDirection := PointF(FSettings.Scale / 12 * FSpeedFactor, 0);
  FNextDirection := PointF(FSettings.Scale / 12 * FSpeedFactor, 0);

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
  x_pac_man := FPosition.X + (FSettings.Scale * 0.65);
  y_pac_man := FPosition.Y + (FSettings.Scale * 0.65);

  for y := 0 to High(FBoard.Map) do
  begin
    for x := 0 to High(FBoard.Map[0]) do
    begin
      if FBoard.Map[y, x] = '.' then
      begin
        x_dot := (x * FSettings.Scale) + (FSettings.Scale / 4);
        y_dot := (y * FSettings.Scale) + (FSettings.Scale / 4);
        radius := FSettings.Scale / 5;
        if (x_pac_man >= x_dot - radius) and (x_pac_man <= x_dot + radius) and
           (y_pac_man >= y_dot - radius) and (y_pac_man <= y_dot + radius) then
        begin
          FBoard.Map[y, x] := ' ';
          FSettings.Score := FSettings.Score + 1;
        end;
      end
      else if FBoard.Map[y, x] = 'o' then
      begin
        x_dot := (x * FSettings.Scale) + (FSettings.Scale / 4);
        y_dot := (y * FSettings.Scale) + (FSettings.Scale / 4);
        radius := FSettings.Scale / 2;
        if (x_pac_man >= x_dot - radius) and (x_pac_man <= x_dot + radius) and
           (y_pac_man >= y_dot - radius) and (y_pac_man <= y_dot + radius) then
        begin
          FBoard.Map[y, x] := ' ';
          FSettings.Score := FSettings.Score + 5;
          FSettings.HarmlessMode := True;

          if Assigned(FOnPowerPelletCollected) then
            FOnPowerPelletCollected();
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

  imageIndex := FSettings.SpriteFrame div FSettings.SpriteSpeed;
  imageIndex := imageIndex mod 7;

  rotatedBitmap := PlayerRotation(imageIndex);
  if Assigned(rotatedBitmap) then
  begin
    Canvas.DrawBitmap(rotatedBitmap,
                      RectF(0, 0, rotatedBitmap.Width, rotatedBitmap.Height),
                      RectF(x, y, x + Round(FSettings.Scale * 1.3), y + Round(FSettings.Scale * 1.3)),
                      1);
    rotatedBitmap.Free; // Free the temporary bitmap
  end;
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

end.

