unit PacMan.Classes.GhostManager;

interface

uses
  System.Types,
  FMX.Graphics,
  PacMan.Interfaces.GhostManager,
  PacMan.Interfaces.Game,
  PacMan.Interfaces.Ghost;

type
  TGhostManager = class(TInterfacedObject, iGhostManager)
  private
    FblueGhost: IGhost;
    ForangeGhost: IGhost;
    FpinkGhost: IGhost;
    FredGhost: IGhost;
    FHarmless: IGhost;
    FGame: IGame;

    function DirectionHarmlessGhostToPacMan(AGhost: IGhost): TPointF;
    function DirectionGhostToPacMan(AGhost: IGhost): TPointF;
    procedure NewRandomDirectionForGhost(AGhost: IGhost);
    procedure DrawGhost(Canvas: TCanvas; color: String; position: TPointF);
    procedure MoveGhostIntoGame(color: String);
    function RandomDirectionForGhost: TPointF;
    function RandomNextDirectionForGhost(direction: TPointF): TPointF;
    function GetBlueGhost: IGhost;
    function GetOrangeGhost: IGhost;
    function GetPinkGhost: IGhost;
    function GetRedGhost: IGhost;
    function GetHarmless: IGhost;

    procedure SetBlueGhost(const AValue: IGhost);
    procedure SetOrangeGhost(const AValue: IGhost);
    procedure SetPinkGhost(const AValue: IGhost);
    procedure SetRedGhost(const AValue: IGhost);
    procedure SetHarmless(const AValue: IGhost);
  public
    function DistanceGhostToPacMan(AGhost: IGhost): Single;
    procedure PowerPelletCollected;
    procedure GhostIntelligence(AGhost: IGhost);
    procedure Execute(Canvas: TCanvas);
    procedure GhostAI;
    property BlueGhost: IGhost read GetBlueGhost write SetBlueGhost;
    property OrangeGhost: IGhost read GetOrangeGhost write SetOrangeGhost;
    property PinkGhost: IGhost read GetPinkGhost write SetPinkGhost;
    property RedGhost: IGhost read GetRedGhost write SetRedGhost;
    property Harmless: IGhost read GetHarmless write SetHarmless;
    constructor Create(AGame: IGame);
    destructor Destroy; override;
  end;

implementation

uses
  PacMan.Classes.uGhost;

{ TGhostManager }

constructor TGhostManager.Create(AGame: IGame);
begin
  FGame := AGame;

  FblueGhost := TGhost.Create(FGame, 'Blue', 12, 13);
  ForangeGhost := TGhost.Create(FGame, 'Orange', 12, 14.5);
  FpinkGhost := TGhost.Create(FGame, 'Pink', 14, 13);
  FredGhost := TGhost.Create(FGame, 'Red', 14, 14.5);
  FHarmless := TGhost.Create(FGame, 'Harmless', 0, 0);
end;

destructor TGhostManager.Destroy;
var
  i: integer;
begin
  for i := 0 to High(BlueGhost.Images) do
  begin
    FblueGhost.Images[i].Free;
    ForangeGhost.Images[i].Free;
    FpinkGhost.Images[i].Free;
    FredGhost.Images[i].Free;
    FHarmless.Images[i].Free;
  end;

  inherited;
end;

function TGhostManager.DistanceGhostToPacMan(AGhost: IGhost): Single;
var
  ghost_x, ghost_y, pac_man_x, pac_man_y: Single;
  delta_x, delta_y: Single;
begin
  ghost_x := AGhost.position.X + (FGame.Settings.Scale * 0.65);
  ghost_y := AGhost.position.Y + (FGame.Settings.Scale * 0.65);
  pac_man_x := FGame.Player.position.X + (FGame.Settings.Scale * 0.65);
  pac_man_y := FGame.Player.position.Y + (FGame.Settings.Scale * 0.65);
  delta_x := Sqr(ghost_x - pac_man_x);
  delta_y := Sqr(ghost_y - pac_man_y);
  Result := Sqrt(delta_x + delta_y);
end;

procedure TGhostManager.GhostIntelligence(AGhost: IGhost);
var
  temp_ghost_pos: TPointF;
  temp_pos: TPointF;
  temp_dir: TPointF;
begin
  temp_ghost_pos := AGhost.position;
  AGhost.DistanceToPacMan := DistanceGhostToPacMan(AGhost);

  if AGhost.DistanceToPacMan <= FGame.Settings.Scale * 10 then
  begin
    if AGhost.harmlessMode then
      AGhost.NextDirection := DirectionHarmlessGhostToPacMan(AGhost)
    else
      AGhost.NextDirection := DirectionGhostToPacMan(AGhost);

    temp_dir := AGhost.direction;
    FGame.Movements.TurningCorner(AGhost.position, temp_dir, AGhost.NextDirection);
    AGhost.direction := temp_dir;
  end;

  if AGhost.direction = AGhost.NextDirection then
  begin
    if AGhost.harmlessMode then
      AGhost.NextDirection := DirectionHarmlessGhostToPacMan(AGhost)
    else
      AGhost.NextDirection := DirectionGhostToPacMan(AGhost);

    temp_pos := AGhost.position;
    FGame.Movements.Collider(temp_pos, AGhost.direction);
    AGhost.position := temp_pos;
  end;

  temp_pos := AGhost.position;
  FGame.Movements.Tunnel(temp_pos);
  FGame.Movements.Collider(temp_pos, AGhost.direction);
  AGhost.position := temp_pos;

  if temp_ghost_pos = AGhost.position then // Se o fantasma está preso ou não se moveu
  begin
    NewRandomDirectionForGhost(AGhost);
  end;
end;

function TGhostManager.DirectionHarmlessGhostToPacMan(AGhost: IGhost): TPointF;
var
  new_direction: TPointF;
  ghost_x, ghost_y, pac_man_x, pac_man_y: Single;
  delta_x, delta_y: Single;
begin
  new_direction := PointF(0, 0);
  ghost_x := AGhost.position.X;
  ghost_y := AGhost.position.Y;
  pac_man_x := FGame.Player.position.X;
  pac_man_y := FGame.Player.position.Y;
  delta_x := ghost_x - pac_man_x;
  delta_y := ghost_y - pac_man_y;

  if AGhost.direction.Y <> 0 then // Se o fantasma está se movendo verticalmente
  begin
    if delta_x <= 0 then // Pac-Man está à direita, fantasma foge para a esquerda
      new_direction.X := -FGame.Settings.Scale / 16
    else // Pac-Man está à esquerda, fantasma foge para a direita
      new_direction.X := FGame.Settings.Scale / 16;
  end;
  if AGhost.direction.X <> 0 then // Se o fantasma está se movendo horizontalmente
  begin
    if delta_y <= 0 then // Pac-Man está abaixo, fantasma foge para cima
      new_direction.Y := -FGame.Settings.Scale / 16
    else // Pac-Man está acima, fantasma foge para baixo
      new_direction.Y := FGame.Settings.Scale / 16;
  end;
  Result := new_direction;
end;

function TGhostManager.DirectionGhostToPacMan(AGhost: IGhost): TPointF;
var
  new_direction: TPointF;
  ghost_x, ghost_y, pac_man_x, pac_man_y: Single;
  delta_x, delta_y: Single;
begin
  new_direction := PointF(0, 0);
  ghost_x := AGhost.position.X;
  ghost_y := AGhost.position.Y;
  pac_man_x := FGame.Player.position.X;
  pac_man_y := FGame.Player.position.Y;
  delta_x := ghost_x - pac_man_x;
  delta_y := ghost_y - pac_man_y;

  if AGhost.direction.Y <> 0 then // Se o fantasma está se movendo verticalmente
  begin
    if delta_x <= 0 then // Pac-Man está à direita
      new_direction.X := FGame.Settings.Scale / 16
    else // Pac-Man está à esquerda
      new_direction.X := -FGame.Settings.Scale / 16;
  end;
  if AGhost.direction.X <> 0 then // Se o fantasma está se movendo horizontalmente
  begin
    if delta_y <= 0 then // Pac-Man está abaixo
      new_direction.Y := FGame.Settings.Scale / 16
    else // Pac-Man está acima
      new_direction.Y := -FGame.Settings.Scale / 16;
  end;
  Result := new_direction;
end;

procedure TGhostManager.NewRandomDirectionForGhost(AGhost: IGhost);
var
  new_direction: TPointF;
  temp_pos, temp_dir: TPointF;
begin
  new_direction := PointF(0, 0);
  temp_pos := AGhost.position;

  if AGhost.direction.X <> 0 then // Se estiver movendo horizontalmente
  begin
    if Random(2) = 0 then
      new_direction.Y := -FGame.Settings.Scale / 8
    else
      new_direction.Y := FGame.Settings.Scale / 8;
  end
  else if AGhost.direction.Y <> 0 then // Se estiver movendo verticalmente
  begin
    if Random(2) = 0 then
      new_direction.X := -FGame.Settings.Scale / 8
    else
      new_direction.X := FGame.Settings.Scale / 8;
  end;

  // Tenta mover para a nova direção
  FGame.Movements.Collider(temp_pos, new_direction);
  if temp_pos = AGhost.position then // Se não conseguiu mover (colidiu)
  begin
    new_direction.X := new_direction.X * -1; // Inverte a direção
    new_direction.Y := new_direction.Y * -1;
    FGame.Movements.Collider(temp_pos, new_direction); // Tenta mover na direção oposta
  end;

  temp_dir.X := new_direction.X / 2;
  temp_dir.Y := new_direction.Y / 2;

  AGhost.direction := temp_dir;
  AGhost.position := temp_pos;
end;

procedure TGhostManager.PowerPelletCollected;
begin
  BlueGhost.harmlessMode := true;
  OrangeGhost.harmlessMode := true;
  PinkGhost.harmlessMode := true;
  RedGhost.harmlessMode := true;
end;

procedure TGhostManager.Execute(Canvas: TCanvas);
begin
  if FGame.Settings.harmlessMode then
  begin
    if FGame.Settings.SpriteFrame = 60 then
    begin
      if BlueGhost.harmlessMode then
        BlueGhost.HarmlessModeTimer := BlueGhost.HarmlessModeTimer + 1;

      if OrangeGhost.harmlessMode then
        OrangeGhost.HarmlessModeTimer := OrangeGhost.HarmlessModeTimer + 1;

      if PinkGhost.harmlessMode then
        PinkGhost.HarmlessModeTimer := PinkGhost.HarmlessModeTimer + 1;

      if RedGhost.harmlessMode then
        RedGhost.HarmlessModeTimer := RedGhost.HarmlessModeTimer + 1;
    end;

    if BlueGhost.HarmlessModeTimer = 16 then
    begin
      BlueGhost.harmlessMode := False;
      BlueGhost.HarmlessModeTimer := 0;
    end;

    if OrangeGhost.HarmlessModeTimer = 16 then
    begin
      OrangeGhost.harmlessMode := False;
      OrangeGhost.HarmlessModeTimer := 0;
    end;

    if PinkGhost.HarmlessModeTimer = 16 then
    begin
      PinkGhost.harmlessMode := False;
      PinkGhost.HarmlessModeTimer := 0;
    end;

    if RedGhost.HarmlessModeTimer = 16 then
    begin
      RedGhost.harmlessMode := False;
      RedGhost.HarmlessModeTimer := 0;
    end;

    if (not BlueGhost.harmlessMode) and (not OrangeGhost.harmlessMode) and
      (not PinkGhost.harmlessMode) and (not RedGhost.harmlessMode) then
      FGame.Settings.harmlessMode := False;
  end;

  if BlueGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', BlueGhost.position)
  else
    DrawGhost(Canvas, 'blue', BlueGhost.position);

  if OrangeGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', OrangeGhost.position)
  else
    DrawGhost(Canvas, 'orange', OrangeGhost.position);

  if PinkGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', PinkGhost.position)
  else
    DrawGhost(Canvas, 'pink', PinkGhost.position);

  if RedGhost.harmlessMode then
    DrawGhost(Canvas, 'harmless', RedGhost.position)
  else
    DrawGhost(Canvas, 'red', RedGhost.position);

  if FGame.Settings.SpriteFrame = 60 then
  begin
    if BlueGhost.position = PointF(FGame.Settings.Scale * 12, FGame.Settings.Scale * 13) then
      MoveGhostIntoGame('blue')
    else if OrangeGhost.position = PointF(FGame.Settings.Scale * 12, FGame.Settings.Scale * 14.5)
    then
      MoveGhostIntoGame('orange')
    else if PinkGhost.position = PointF(FGame.Settings.Scale * 14, FGame.Settings.Scale * 13) then
      MoveGhostIntoGame('pink')
    else if RedGhost.position = PointF(FGame.Settings.Scale * 14, FGame.Settings.Scale * 14.5) then
      MoveGhostIntoGame('red');
  end;
end;

procedure TGhostManager.DrawGhost(Canvas: TCanvas; color: String; position: TPointF);
var
  imageIndex: integer;
  ghostBitmap: TBitmap;
begin
  imageIndex := FGame.Settings.SpriteFrame div 30;
  if imageIndex > 1 then
    imageIndex := 0;

  if color = 'blue' then
    ghostBitmap := BlueGhost.Images[imageIndex]
  else if color = 'orange' then
    ghostBitmap := OrangeGhost.Images[imageIndex]
  else if color = 'pink' then
    ghostBitmap := PinkGhost.Images[imageIndex]
  else if color = 'red' then
    ghostBitmap := RedGhost.Images[imageIndex]
  else
    ghostBitmap := Harmless.Images[imageIndex];
  // Desenhar o fantasma
  Canvas.DrawBitmap(ghostBitmap, RectF(0, 0, ghostBitmap.Width, ghostBitmap.Height),
    RectF(position.X, position.Y, position.X + Round(FGame.Settings.Scale * 1.3),
    position.Y + Round(FGame.Settings.Scale * 1.3)), 1);
end;

procedure TGhostManager.MoveGhostIntoGame(color: String);
begin
  if color = 'blue' then
  begin
    BlueGhost.position := PointF(FGame.Settings.Scale * 13.1, FGame.Settings.Scale * 10.6);
    BlueGhost.direction := RandomDirectionForGhost;
    BlueGhost.NextDirection := RandomNextDirectionForGhost(BlueGhost.direction);
  end
  else if color = 'orange' then
  begin
    OrangeGhost.position := PointF(FGame.Settings.Scale * 13.1, FGame.Settings.Scale * 10.6);
    OrangeGhost.direction := RandomDirectionForGhost;
    OrangeGhost.NextDirection := RandomNextDirectionForGhost(OrangeGhost.direction);
  end
  else if color = 'pink' then
  begin
    PinkGhost.position := PointF(FGame.Settings.Scale * 13.1, FGame.Settings.Scale * 10.6);
    PinkGhost.direction := RandomDirectionForGhost;
    PinkGhost.NextDirection := RandomNextDirectionForGhost(PinkGhost.direction);
  end
  else if color = 'red' then
  begin
    RedGhost.position := PointF(FGame.Settings.Scale * 13.1, FGame.Settings.Scale * 10.6);
    RedGhost.direction := RandomDirectionForGhost;
    RedGhost.NextDirection := RandomNextDirectionForGhost(RedGhost.direction);
  end;
end;

function TGhostManager.RandomDirectionForGhost: TPointF;
var
  move_up_or_sideways: integer;
  x_direction, y_direction: integer;
begin
  move_up_or_sideways := Random(2); // 0 ou 1
  x_direction := Random(2);
  y_direction := Random(2);

  if move_up_or_sideways = 0 then // Movimento horizontal
  begin
    if x_direction = 0 then
      Result := PointF(-FGame.Settings.Scale / 16, 0)
    else
      Result := PointF(FGame.Settings.Scale / 16, 0);
  end
  else // Movimento vertical
  begin
    if y_direction = 0 then
      Result := PointF(0, -FGame.Settings.Scale / 16)
    else
      Result := PointF(0, FGame.Settings.Scale / 16);
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
      new_direction.Y := -FGame.Settings.Scale / 16
    else
      new_direction.Y := FGame.Settings.Scale / 16;
  end
  else if direction.Y <> 0 then
  // Se estiver movendo verticalmente, a próxima direção será horizontal
  begin
    if Random(2) = 0 then
      new_direction.X := -FGame.Settings.Scale / 16
    else
      new_direction.X := FGame.Settings.Scale / 16;
  end;
  Result := new_direction;
end;

function TGhostManager.GetBlueGhost: IGhost;
begin
  Result := FblueGhost;
end;

function TGhostManager.GetHarmless: IGhost;
begin
  Result := FHarmless;
end;

function TGhostManager.GetOrangeGhost: IGhost;
begin
  Result := ForangeGhost;
end;

function TGhostManager.GetPinkGhost: IGhost;
begin
  Result := FpinkGhost;
end;

function TGhostManager.GetRedGhost: IGhost;
begin
  Result := FredGhost;
end;

procedure TGhostManager.SetBlueGhost(const AValue: IGhost);
begin
  FblueGhost := AValue;
end;

procedure TGhostManager.SetHarmless(const AValue: IGhost);
begin
  FHarmless := AValue;
end;

procedure TGhostManager.SetOrangeGhost(const AValue: IGhost);
begin
  OrangeGhost := AValue;
end;

procedure TGhostManager.SetPinkGhost(const AValue: IGhost);
begin
  FpinkGhost := AValue;
end;

procedure TGhostManager.SetRedGhost(const AValue: IGhost);
begin
  FredGhost := AValue;
end;

procedure TGhostManager.GhostAI;
begin
  if BlueGhost.position <> PointF(FGame.Settings.Scale * 12, FGame.Settings.Scale * 13) then
  begin
    GhostIntelligence(BlueGhost);
  end;
  if OrangeGhost.position <> PointF(FGame.Settings.Scale * 12, FGame.Settings.Scale * 14.5) then
  begin
    GhostIntelligence(OrangeGhost);
  end;
  if PinkGhost.position <> PointF(FGame.Settings.Scale * 14, FGame.Settings.Scale * 13) then
  begin
    GhostIntelligence(PinkGhost);
  end;
  if RedGhost.position <> PointF(FGame.Settings.Scale * 14, FGame.Settings.Scale * 14.5) then
  begin
    GhostIntelligence(RedGhost);
  end;
end;

end.
