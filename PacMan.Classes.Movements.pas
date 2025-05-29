unit PacMan.Classes.Movements;

interface

uses
  System.Types, PacMan.Interfaces.Game, PacMan.Interfaces.Movements;

type
  TMovements = class(TInterfacedObject, iMovements)
  private
    FGame: IGame;
  public
    procedure TurningCorner(position: TPointF; var direction: TPointF; next_direction: TPointF);
    procedure Collider(var position: TPointF; direction: TPointF);
    procedure Tunnel(var position: TPointF);
    procedure MoveDown;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveUp;

    constructor Create(AGame: IGame);
  end;

implementation

constructor TMovements.Create(AGame: IGame);
begin
  FGame := AGame;
end;

procedure TMovements.TurningCorner(position: TPointF; var direction: TPointF; next_direction: TPointF);
var
  turned_corner: Boolean;
  temp_pos: TPointF;
  x, y: Integer;
  x_wall, y_wall, wall_size: Single;
  x_agent, y_agent: Single;
begin
  turned_corner := True;
  temp_pos := position;
  temp_pos.X := temp_pos.X + (next_direction.X * 16);
  temp_pos.Y := temp_pos.Y + (next_direction.Y * 16);

  for y := 0 to High(FGame.Board.Map) do
  begin
    for x := 0 to High(FGame.Board.Map[0]) do
    begin
      if (FGame.Board.Map[y, x] = '#') or (FGame.Board.Map[y, x] = '-') then
      begin
        x_wall := (x * FGame.Settings.Scale) - (FGame.Settings.Scale * 0.65);
        y_wall := (y * FGame.Settings.Scale) - (FGame.Settings.Scale * 0.65);
        wall_size := FGame.Settings.Scale * 1.85;
        x_agent := temp_pos.X + (FGame.Settings.Scale * 0.65);
        y_agent := temp_pos.Y + (FGame.Settings.Scale * 0.65);
        if (x_agent >= x_wall) and (x_agent <= x_wall + wall_size) and
           (y_agent >= y_wall) and (y_agent <= y_wall + wall_size) then
        begin
          turned_corner := False;
          Break; // Sai do loop interno
        end;
      end;
    end;
    if not turned_corner then Break; // Sai do loop externo
  end;

  if turned_corner then
  begin
    direction := next_direction;
  end;
end;

procedure TMovements.Collider(var position: TPointF; direction: TPointF);
var
  x, y: Integer;
  x_wall, y_wall, wall_size: Single;
  x_agent, y_agent: Single;
  temp_pos: TPointF;
begin
  if FGame.Settings.EndGame then Exit;

  temp_pos := position;
  temp_pos.X := temp_pos.X + direction.X;
  temp_pos.Y := temp_pos.Y + direction.Y;

  for y := 0 to High(FGame.Board.Map) do
  begin
    for x := 0 to High(FGame.Board.Map[0]) do
    begin
      if (FGame.Board.Map[y, x] = '#') or (FGame.Board.Map[y, x] = '-') then
      begin
        x_wall := (x * FGame.Settings.Scale) - (FGame.Settings.Scale * 0.65);
        y_wall := (y * FGame.Settings.Scale) - (FGame.Settings.Scale * 0.65);
        wall_size := FGame.Settings.Scale * 1.85;
        x_agent := temp_pos.X + (FGame.Settings.Scale * 0.65);
        y_agent := temp_pos.Y + (FGame.Settings.Scale * 0.65);

        if (x_agent >= x_wall) and (x_agent <= x_wall + wall_size) and
           (y_agent >= y_wall) and (y_agent <= y_wall + wall_size) then
        begin
          // Colisão detectada, reverte o movimento
          position := position; // Mantém a posição anterior
          Exit;
        end;
      end;
    end;
  end;
  position := temp_pos; // Atualiza a posição se não houver colisão
end;

procedure TMovements.Tunnel(var position: TPointF);
begin
  if position.X >= FGame.Settings.Scale * 27.5 then
    position.X := -(FGame.Settings.Scale * 1.3)
  else if position.X <= -(FGame.Settings.Scale * 1.3) then
    position.X := FGame.Settings.Scale * 27.5;
end;

procedure TMovements.MoveUp;
begin
  if (FGame.Player.Direction.x = 0) and (FGame.Player.Direction.y > 0) then
  begin
    FGame.Player.Direction := PointF(0, (-FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor);
    FGame.Player.NextDirection := PointF(0, (-FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor);
  end
  else if (FGame.Player.Direction.x <> 0) and (FGame.Player.Direction.y = 0) then
  begin
    FGame.Player.NextDirection := PointF(0, (-FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor);
  end;
end;

procedure TMovements.MoveLeft;
begin
  if (FGame.Player.Direction.x > 0) and (FGame.Player.Direction.y = 0) then
  begin
    FGame.Player.Direction := PointF((-FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor, 0);
    FGame.Player.NextDirection := PointF((-FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor, 0);
  end
  else if (FGame.Player.Direction.x = 0) and (FGame.Player.Direction.y <> 0) then
  begin
    FGame.Player.NextDirection := PointF((-FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor, 0);
  end;
end;

procedure TMovements.MoveRight;
begin
  if (FGame.Player.Direction.x < 0) and (FGame.Player.Direction.y = 0) then
  begin
    FGame.Player.Direction := PointF((FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor, 0);
    FGame.Player.NextDirection := PointF((FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor, 0);
  end
  else if (FGame.Player.Direction.x = 0) and (FGame.Player.Direction.y <> 0) then
  begin
    FGame.Player.NextDirection := PointF((FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor, 0);
  end;
end;

procedure TMovements.MoveDown;
begin
  if (FGame.Player.Direction.x = 0) and (FGame.Player.Direction.y < 0) then
  begin
    FGame.Player.Direction := PointF(0, (FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor);
    FGame.Player.NextDirection := PointF(0, (FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor);
  end
  else if (FGame.Player.Direction.x <> 0) and (FGame.Player.Direction.y = 0) then
  begin
    FGame.Player.NextDirection := PointF(0, (FGame.Settings.Scale / 12) * FGame.Player.SpeedFactor);
  end;
end;

end.
