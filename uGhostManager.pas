unit uGhostManager;

interface

uses
  uGhost,
  uSettings, System.Types, uMovements, uPlayer, FMX.Graphics;

type
  TGhostManager = class
  private
    FblueGhost: TGhost;
    ForangeGhost: TGhost;
    FpinkGhost: TGhost;
    FredGhost: TGhost;
    FHarmless: TGhost;
    FSettings: TSettings;
    FMovements: TMovements;
    FPlayer: TPlayer;

    function DirectionHarmlessGhostToPacMan(AGhost: TGhost): TPointF;
    function DirectionGhostToPacMan(AGhost: TGhost): TPointF;
    procedure NewRandomDirectionForGhost(AGhost: TGhost);
    procedure DrawGhost(Canvas: TCanvas; color: String; position: TPointF);
    procedure MoveGhostIntoGame(color: String);
    function RandomDirectionForGhost: TPointF;
    function RandomNextDirectionForGhost(direction: TPointF): TPointF;
  public
    function DistanceGhostToPacMan(AGhost: TGhost): Single;
    procedure OnPowerPelletCollected;
    procedure GhostIntelligence(AGhost: TGhost);
    procedure Execute(Canvas: TCanvas);
    procedure GhostAI;

    property blueGhost: TGhost read FblueGhost write FblueGhost;
    property orangeGhost: TGhost read ForangeGhost write ForangeGhost;
    property pinkGhost: TGhost read FpinkGhost write FpinkGhost;
    property redGhost: TGhost read FredGhost write FredGhost;
    property Harmless: TGhost read FHarmless write FHarmless;
    constructor Create(ASettings: TSettings; AMovements: TMovements; APlayer: TPlayer);
    destructor Destroy; override;
  end;

implementation

{ TGhostManager }

constructor TGhostManager.Create(ASettings: TSettings; AMovements: TMovements; APlayer: TPlayer);
begin
  FSettings := ASettings;
  FMovements := AMovements;
  FPlayer := APlayer;

  FblueGhost := TGhost.Create(FSettings, 'Blue', 12, 13);
  ForangeGhost := TGhost.Create(FSettings, 'Orange', 12, 14.5);
  FpinkGhost := TGhost.Create(FSettings, 'Pink', 14, 13);
  FredGhost := TGhost.Create(FSettings, 'Red', 14, 14.5);
  FHarmless := TGhost.Create(FSettings, 'Harmless', 0, 0);
end;

destructor TGhostManager.Destroy;
var
  i: integer;
begin
  for i := 0 to High(blueGhost.Images) do
  begin
    FBlueGhost.Images[i].Free;
    FOrangeGhost.Images[i].Free;
    FPinkGhost.Images[i].Free;
    FRedGhost.Images[i].Free;
    FHarmless.Images[i].Free;
  end;

  FblueGhost.Free;
  ForangeGhost.Free;
  FpinkGhost.Free;
  FredGhost.Free;
  FHarmless.Free;

  inherited;
end;

function TGhostManager.DistanceGhostToPacMan(AGhost: TGhost): Single;
var
  ghost_x, ghost_y, pac_man_x, pac_man_y: Single;
  delta_x, delta_y: Single;
begin
  ghost_x := AGhost.position.X + (FSettings.Scale * 0.65);
  ghost_y := AGhost.position.Y + (FSettings.Scale * 0.65);
  pac_man_x := FPlayer.position.X + (FSettings.Scale * 0.65);
  pac_man_y := FPlayer.position.Y + (FSettings.Scale * 0.65);
  delta_x := Sqr(ghost_x - pac_man_x);
  delta_y := Sqr(ghost_y - pac_man_y);
  Result := Sqrt(delta_x + delta_y);
end;

procedure TGhostManager.GhostIntelligence(AGhost: TGhost);
var
  temp_ghost_pos: TPointF;
  temp_pos: TPointF;
  temp_dir: TPointF;
begin
  temp_ghost_pos := AGhost.position;
  AGhost.DistanceToPacMan := DistanceGhostToPacMan(AGhost);

  if AGhost.DistanceToPacMan <= FSettings.Scale * 10 then
  begin
    if AGhost.harmlessMode then
      AGhost.NextDirection := DirectionHarmlessGhostToPacMan(AGhost)
    else
      AGhost.NextDirection := DirectionGhostToPacMan(AGhost);

    temp_dir := AGhost.direction;
    FMovements.TurningCorner(AGhost.position, temp_dir, AGhost.NextDirection);
    AGhost.direction := temp_dir;
  end;

  if AGhost.direction = AGhost.NextDirection then
  begin
    if AGhost.harmlessMode then
      AGhost.NextDirection := DirectionHarmlessGhostToPacMan(AGhost)
    else
      AGhost.NextDirection := DirectionGhostToPacMan(AGhost);

    temp_pos := AGhost.position;
    FMovements.Collider(temp_pos, AGhost.direction);
    AGhost.position := temp_pos;
  end;

  temp_pos := AGhost.position;
  FMovements.Tunnel(temp_pos);
  FMovements.Collider(temp_pos, AGhost.direction);
  AGhost.position := temp_pos;

  if temp_ghost_pos = AGhost.position then // Se o fantasma está preso ou não se moveu
  begin
    NewRandomDirectionForGhost(AGhost);
  end;
end;

function TGhostManager.DirectionHarmlessGhostToPacMan(AGhost: TGhost): TPointF;
var
  new_direction: TPointF;
  ghost_x, ghost_y, pac_man_x, pac_man_y: Single;
  delta_x, delta_y: Single;
begin
  new_direction := PointF(0, 0);
  ghost_x := AGhost.position.X;
  ghost_y := AGhost.position.Y;
  pac_man_x := FPlayer.position.X;
  pac_man_y := FPlayer.position.Y;
  delta_x := ghost_x - pac_man_x;
  delta_y := ghost_y - pac_man_y;

  if AGhost.direction.Y <> 0 then // Se o fantasma está se movendo verticalmente
  begin
    if delta_x <= 0 then // Pac-Man está à direita, fantasma foge para a esquerda
      new_direction.X := -FSettings.Scale / 16
    else // Pac-Man está à esquerda, fantasma foge para a direita
      new_direction.X := FSettings.Scale / 16;
  end;
  if AGhost.direction.X <> 0 then // Se o fantasma está se movendo horizontalmente
  begin
    if delta_y <= 0 then // Pac-Man está abaixo, fantasma foge para cima
      new_direction.Y := -FSettings.Scale / 16
    else // Pac-Man está acima, fantasma foge para baixo
      new_direction.Y := FSettings.Scale / 16;
  end;
  Result := new_direction;
end;

function TGhostManager.DirectionGhostToPacMan(AGhost: TGhost): TPointF;
var
  new_direction: TPointF;
  ghost_x, ghost_y, pac_man_x, pac_man_y: Single;
  delta_x, delta_y: Single;
begin
  new_direction := PointF(0, 0);
  ghost_x := AGhost.position.X;
  ghost_y := AGhost.position.Y;
  pac_man_x := FPlayer.position.X;
  pac_man_y := FPlayer.position.Y;
  delta_x := ghost_x - pac_man_x;
  delta_y := ghost_y - pac_man_y;

  if AGhost.direction.Y <> 0 then // Se o fantasma está se movendo verticalmente
  begin
    if delta_x <= 0 then // Pac-Man está à direita
      new_direction.X := FSettings.Scale / 16
    else // Pac-Man está à esquerda
      new_direction.X := -FSettings.Scale / 16;
  end;
  if AGhost.direction.X <> 0 then // Se o fantasma está se movendo horizontalmente
  begin
    if delta_y <= 0 then // Pac-Man está abaixo
      new_direction.Y := FSettings.Scale / 16
    else // Pac-Man está acima
      new_direction.Y := -FSettings.Scale / 16;
  end;
  Result := new_direction;
end;

procedure TGhostManager.NewRandomDirectionForGhost(AGhost: TGhost);
var
  new_direction: TPointF;
  temp_pos, temp_dir: TPointF;
begin
  new_direction := PointF(0, 0);
  temp_pos := AGhost.position;

  if AGhost.direction.X <> 0 then // Se estiver movendo horizontalmente
  begin
    if Random(2) = 0 then
      new_direction.Y := -FSettings.Scale / 8
    else
      new_direction.Y := FSettings.Scale / 8;
  end
  else if AGhost.direction.Y <> 0 then // Se estiver movendo verticalmente
  begin
    if Random(2) = 0 then
      new_direction.X := -FSettings.Scale / 8
    else
      new_direction.X := FSettings.Scale / 8;
  end;

  // Tenta mover para a nova direção
  FMovements.Collider(temp_pos, new_direction);
  if temp_pos = AGhost.position then // Se não conseguiu mover (colidiu)
  begin
    new_direction.X := new_direction.X * -1; // Inverte a direção
    new_direction.Y := new_direction.Y * -1;
    FMovements.Collider(temp_pos, new_direction); // Tenta mover na direção oposta
  end;

  temp_dir.X := new_direction.X / 2;
  temp_dir.Y := new_direction.Y / 2;

  AGhost.direction := temp_dir;
  AGhost.position := temp_pos;
end;

procedure TGhostManager.OnPowerPelletCollected;
begin
  blueGhost.harmlessMode := true;
  orangeGhost.harmlessMode := true;
  pinkGhost.harmlessMode := true;
  redGhost.harmlessMode := true;
end;

procedure TGhostManager.Execute(Canvas: TCanvas);
begin
  if FSettings.harmlessMode then
  begin
    if FSettings.SpriteFrame = 60 then
      FSettings.HarmlessModeTimer := FSettings.HarmlessModeTimer + 1;

    if FSettings.HarmlessModeTimer = 16 then
    begin
      FSettings.harmlessMode := False;
      blueGhost.harmlessMode := False;
      orangeGhost.harmlessMode := False;
      pinkGhost.harmlessMode := False;
      redGhost.harmlessMode := False;
      FSettings.HarmlessModeTimer := 0;
    end;
  end;

  if blueGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', blueGhost.position)
  else
    DrawGhost(Canvas, 'blue', blueGhost.position);

  if orangeGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', orangeGhost.position)
  else
    DrawGhost(Canvas, 'orange', orangeGhost.position);

  if pinkGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', pinkGhost.position)
  else
    DrawGhost(Canvas, 'pink', pinkGhost.position);

  if redGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', redGhost.position)
  else
    DrawGhost(Canvas, 'red', redGhost.position);

  if FSettings.SpriteFrame = 60 then
  begin
    if blueGhost.position = PointF(FSettings.Scale * 12, FSettings.Scale * 13) then
      MoveGhostIntoGame('blue')
    else if orangeGhost.position = PointF(FSettings.Scale * 12, FSettings.Scale * 14.5) then
      MoveGhostIntoGame('orange')
    else if pinkGhost.position = PointF(FSettings.Scale * 14, FSettings.Scale * 13) then
      MoveGhostIntoGame('pink')
    else if redGhost.position = PointF(FSettings.Scale * 14, FSettings.Scale * 14.5) then
      MoveGhostIntoGame('red');
  end;
end;

procedure TGhostManager.DrawGhost(Canvas: TCanvas; color: String; position: TPointF);
var
  imageIndex: Integer;
  ghostBitmap: TBitmap;
begin
  imageIndex := FSettings.SpriteFrame div 30;
  if imageIndex > 1 then
    imageIndex := 0;

  if color = 'blue' then
    ghostBitmap := blueGhost.Images[imageIndex]
  else if color = 'orange' then
    ghostBitmap := orangeGhost.Images[imageIndex]
  else if color = 'pink' then
    ghostBitmap := pinkGhost.Images[imageIndex]
  else if color = 'red' then
    ghostBitmap := redGhost.Images[imageIndex]
  else
    ghostBitmap := Harmless.Images[imageIndex];
  // Desenhar o fantasma
  Canvas.DrawBitmap(ghostBitmap, RectF(0, 0, ghostBitmap.Width, ghostBitmap.Height),
    RectF(position.X, position.Y, position.X + Round(FSettings.Scale * 1.3),
    position.Y + Round(FSettings.Scale * 1.3)), 1);
end;

procedure TGhostManager.MoveGhostIntoGame(color: String);
begin
  if color = 'blue' then
  begin
    blueGhost.position := PointF(FSettings.Scale * 13.1, FSettings.Scale * 10.6);
    blueGhost.direction := RandomDirectionForGhost;
    blueGhost.NextDirection := RandomNextDirectionForGhost(blueGhost.direction);
  end
  else if color = 'orange' then
  begin
    orangeGhost.position := PointF(FSettings.Scale * 13.1, FSettings.Scale * 10.6);
    orangeGhost.direction := RandomDirectionForGhost;
    orangeGhost.NextDirection := RandomNextDirectionForGhost(orangeGhost.direction);
  end
  else if color = 'pink' then
  begin
    pinkGhost.position := PointF(FSettings.Scale * 13.1, FSettings.Scale * 10.6);
    pinkGhost.direction := RandomDirectionForGhost;
    pinkGhost.NextDirection := RandomNextDirectionForGhost(pinkGhost.direction);
  end
  else if color = 'red' then
  begin
    redGhost.position := PointF(FSettings.Scale * 13.1, FSettings.Scale * 10.6);
    redGhost.direction := RandomDirectionForGhost;
    redGhost.NextDirection := RandomNextDirectionForGhost(redGhost.direction);
  end;
end;

function TGhostManager.RandomDirectionForGhost: TPointF;
var
  move_up_or_sideways: Integer;
  x_direction, y_direction: Integer;
begin
  move_up_or_sideways := Random(2); // 0 ou 1
  x_direction := Random(2);
  y_direction := Random(2);

  if move_up_or_sideways = 0 then // Movimento horizontal
  begin
    if x_direction = 0 then
      Result := PointF(-FSettings.Scale / 16, 0)
    else
      Result := PointF(FSettings.Scale / 16, 0);
  end
  else // Movimento vertical
  begin
    if y_direction = 0 then
      Result := PointF(0, -FSettings.Scale / 16)
    else
      Result := PointF(0, FSettings.Scale / 16);
  end;
end;

function TGhostManager.RandomNextDirectionForGhost(direction: TPointF): TPointF;
var
  new_direction: TPointF;
begin
  new_direction := PointF(0, 0);
  if direction.X <> 0 then // Se estiver movendo horizontalmente, a próxima direção será vertical
  begin
    if Random(2) = 0 then
      new_direction.Y := -FSettings.Scale / 16
    else
      new_direction.Y := FSettings.Scale / 16;
  end
  else if direction.Y <> 0 then
  // Se estiver movendo verticalmente, a próxima direção será horizontal
  begin
    if Random(2) = 0 then
      new_direction.X := -FSettings.Scale / 16
    else
      new_direction.X := FSettings.Scale / 16;
  end;
  Result := new_direction;
end;

procedure TGhostManager.GhostAI;
begin
  if blueGhost.Position  <> PointF(FSettings.Scale * 12, FSettings.Scale * 13) then
  begin
    GhostIntelligence(blueGhost);
  end;
  if OrangeGhost.Position <> PointF(FSettings.Scale * 12, FSettings.Scale * 14.5) then
  begin
    GhostIntelligence(OrangeGhost);
  end;
  if PinkGhost.Position <> PointF(FSettings.Scale * 14, FSettings.Scale * 13) then
  begin
    GhostIntelligence(PinkGhost);
  end;
  if RedGhost.Position <> PointF(FSettings.Scale * 14, FSettings.Scale * 14.5) then
  begin
    GhostIntelligence(RedGhost);
  end;
end;

end.
