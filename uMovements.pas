unit uMovements;

interface

uses
  System.Types, uSettings, uBoard, uPlayer;

type
  TMovements = class
  private
    FSettings: TSettings;
    FPlayer: TPlayer;
    FBoard: TBoard;
  public
    procedure TurningCorner(position: TPointF; var direction: TPointF; next_direction: TPointF);
    procedure Collider(var position: TPointF; direction: TPointF);
    procedure Tunnel(var position: TPointF);
    procedure MoveDown;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveUp;

    constructor Create(ASettings: TSettings; ABoard: TBoard; APlayer: TPlayer);
  end;

implementation

constructor TMovements.Create(ASettings: TSettings; ABoard: TBoard; APlayer: TPlayer);
begin
  FSettings := ASettings;
  FBoard := ABoard;
  FPlayer := APlayer;
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

  for y := 0 to High(FBoard.Map) do
  begin
    for x := 0 to High(FBoard.Map[0]) do
    begin
      if (FBoard.Map[y, x] = '#') or (FBoard.Map[y, x] = '-') then
      begin
        x_wall := (x * FSettings.Scale) - (FSettings.Scale * 0.65);
        y_wall := (y * FSettings.Scale) - (FSettings.Scale * 0.65);
        wall_size := FSettings.Scale * 1.85;
        x_agent := temp_pos.X + (FSettings.Scale * 0.65);
        y_agent := temp_pos.Y + (FSettings.Scale * 0.65);
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
  if FSettings.EndGame then Exit;

  temp_pos := position;
  temp_pos.X := temp_pos.X + direction.X;
  temp_pos.Y := temp_pos.Y + direction.Y;

  for y := 0 to High(FBoard.Map) do
  begin
    for x := 0 to High(FBoard.Map[0]) do
    begin
      if (FBoard.Map[y, x] = '#') or (FBoard.Map[y, x] = '-') then
      begin
        x_wall := (x * FSettings.Scale) - (FSettings.Scale * 0.65);
        y_wall := (y * FSettings.Scale) - (FSettings.Scale * 0.65);
        wall_size := FSettings.Scale * 1.85;
        x_agent := temp_pos.X + (FSettings.Scale * 0.65);
        y_agent := temp_pos.Y + (FSettings.Scale * 0.65);

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
  if position.X >= FSettings.Scale * 27.5 then
    position.X := -(FSettings.Scale * 1.3)
  else if position.X <= -(FSettings.Scale * 1.3) then
    position.X := FSettings.Scale * 27.5;
end;

procedure TMovements.MoveUp;
begin
  if (FPlayer.Direction.x = 0) and (FPlayer.Direction.y > 0) then
  begin
    FPlayer.Direction := PointF(0, (-FSettings.Scale / 12) * FPlayer.SpeedFactor);
    FPlayer.NextDirection := PointF(0, (-FSettings.Scale / 12) * FPlayer.SpeedFactor);
  end
  else if (FPlayer.Direction.x <> 0) and (FPlayer.Direction.y = 0) then
  begin
    FPlayer.NextDirection := PointF(0, (-FSettings.Scale / 12) * FPlayer.SpeedFactor);
  end;
end;

procedure TMovements.MoveLeft;
begin
  if (FPlayer.Direction.x > 0) and (FPlayer.Direction.y = 0) then
  begin
    FPlayer.Direction := PointF((-FSettings.Scale / 12) * FPlayer.SpeedFactor, 0);
    FPlayer.NextDirection := PointF((-FSettings.Scale / 12) * FPlayer.SpeedFactor, 0);
  end
  else if (FPlayer.Direction.x = 0) and (FPlayer.Direction.y <> 0) then
  begin
    FPlayer.NextDirection := PointF((-FSettings.Scale / 12) * FPlayer.SpeedFactor, 0);
  end;
end;

procedure TMovements.MoveRight;
begin
  if (FPlayer.Direction.x < 0) and (FPlayer.Direction.y = 0) then
  begin
    FPlayer.Direction := PointF((FSettings.Scale / 12) * FPlayer.SpeedFactor, 0);
    FPlayer.NextDirection := PointF((FSettings.Scale / 12) * FPlayer.SpeedFactor, 0);
  end
  else if (FPlayer.Direction.x = 0) and (FPlayer.Direction.y <> 0) then
  begin
    FPlayer.NextDirection := PointF((FSettings.Scale / 12) * FPlayer.SpeedFactor, 0);
  end;
end;

procedure TMovements.MoveDown;
begin
  if (FPlayer.Direction.x = 0) and (FPlayer.Direction.y < 0) then
  begin
    FPlayer.Direction := PointF(0, (FSettings.Scale / 12) * FPlayer.SpeedFactor);
    FPlayer.NextDirection := PointF(0, (FSettings.Scale / 12) * FPlayer.SpeedFactor);
  end
  else if (FPlayer.Direction.x <> 0) and (FPlayer.Direction.y = 0) then
  begin
    FPlayer.NextDirection := PointF(0, (FSettings.Scale / 12) * FPlayer.SpeedFactor);
  end;
end;

end.
