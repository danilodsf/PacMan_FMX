unit PacMan.Classes.Board;

interface

uses
  FMX.Graphics,
  FMX.Types,
  System.Types,
  System.SysUtils,
  System.UITypes,
  System.Math,
  FMX.Forms,
  PacMan.Interfaces.Game,
  PacMan.Interfaces.Board;

type
  TBoard = class(TInterfacedObject, IBoard)
  private
    font: TFont;
    FMap: TArray<TArray<Char>>;
    FGame: IGame;
    function GetMap: TArray<TArray<Char>>;
    procedure SetMap(const AValue: TArray<TArray<Char>>);
  public
    property Map: TArray<TArray<Char>> read GetMap write SetMap;
    procedure Draw(ACanvas: TCanvas);
    procedure LoadMap;
    procedure DrawScoreboard(Canvas: TCanvas);

    constructor Create(AGame: IGame);
    destructor Destroy; override;
  end;

implementation

constructor TBoard.Create(AGame: IGame);
begin
  FGame := AGame;

  font := TFont.Create;
  font.Family := 'Courier New';
  font.Size := Round(FGame.Settings.Scale * 1.5);
  font.Style := [TFontStyle.fsBold];
end;

destructor TBoard.Destroy;
begin
  font.Free;
  inherited;
end;

procedure TBoard.Draw(ACanvas: TCanvas);
var
  x, y: Integer;
  rect: TRectF;
begin
  for y := 0 to High(FMap) do
  begin
    for x := 0 to High(FMap[0]) do
    begin
      if FMap[y, x] = '#' then
      begin
        ACanvas.Fill.Color := TAlphaColors.Blue;
        rect := RectF(x * FGame.Settings.Scale, y * FGame.Settings.Scale, (x + 1) * FGame.Settings.Scale, (y + 1) * FGame.Settings.Scale);
        ACanvas.FillRect(rect, 0, 0, AllCorners, 1);
      end
      else if FMap[y, x] = '-' then
      begin
        ACanvas.Fill.Color := TAlphaColors.White;
        rect := RectF(x * FGame.Settings.Scale, y * FGame.Settings.Scale, (x + 1) * FGame.Settings.Scale, (y + 1) * FGame.Settings.Scale);
        ACanvas.FillRect(rect, 0, 0, AllCorners, 1);
      end
      else if (FMap[y, x] = ' ') or (FMap[y, x] = '.') or (FMap[y, x] = 'o') then
      begin
        ACanvas.Fill.Color := TAlphaColors.Black;
        rect := RectF((x * FGame.Settings.Scale) - (FGame.Settings.Scale / 2), (y * FGame.Settings.Scale) - (FGame.Settings.Scale / 2),
                      (x * FGame.Settings.Scale) + (FGame.Settings.Scale * 1.5) - (FGame.Settings.Scale / 2), (y * FGame.Settings.Scale) + (FGame.Settings.Scale * 1.5) - (FGame.Settings.Scale / 2));
        ACanvas.FillRect(rect, 0, 0, AllCorners, 1);
      end;
    end;
  end;

  for y := 0 to High(FMap) do
  begin
    for x := 0 to High(FMap[0]) do
    begin
      if FMap[y, x] = '.' then
      begin
        ACanvas.Fill.Color := TAlphaColors.White;
        ACanvas.FillEllipse(RectF((x * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) - (FGame.Settings.Scale / 5), (y * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) - (FGame.Settings.Scale / 5),
                                 (x * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) + (FGame.Settings.Scale / 5), (y * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) + (FGame.Settings.Scale / 5)), 1);
      end
      else if FMap[y, x] = 'o' then
      begin
        ACanvas.Fill.Color := TAlphaColors.White;
        ACanvas.FillEllipse(RectF((x * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) - (FGame.Settings.Scale / 2), (y * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) - (FGame.Settings.Scale / 2),
                                 (x * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) + (FGame.Settings.Scale / 2), (y * FGame.Settings.Scale) + (FGame.Settings.Scale / 4) + (FGame.Settings.Scale / 2)), 1);
      end;
    end;
  end;
end;

procedure TBoard.LoadMap;
const
  MapStr: array[0..30] of string = (
    '############################',
    '#............##............#',
    '#.####.#####.##.#####.####.#',
    '#o####.#####.##.#####.####o#',
    '#.####.#####.##.#####.####.#',
    '#..........................#',
    '#.####.##.########.##.####.#',
    '#.####.##.########.##.####.#',
    '#......##....##....##......#',
    '######.##### ## #####.######',
    '     #.##### ## #####.#     ',
    '     #.##          ##.#     ',
    '     #.## ###--### ##.#     ',
    '######.## #      # ##.######',
    '      .   #      #   .      ',
    '######.## #      # ##.######',
    '     #.## ######## ##.#     ',
    '     #.##          ##.#     ',
    '     #.## ######## ##.#     ',
    '######.## ######## ##.######',
    '#............##............#',
    '#.####.#####.##.#####.####.#',
    '#.####.#####.##.#####.####.#',
    '#o..##.......  .......##..o#',
    '###.##.##.########.##.##.###',
    '###.##.##.########.##.##.###',
    '#......##....##....##......#',
    '#.##########.##.##########.#',
    '#.##########.##.##########.#',
    '#..........................#',
    '############################');
var
  y: Integer;
  TmpMap: TArray<TArray<Char>>;
begin
  SetLength(TmpMap, Length(MapStr));
  for y := 0 to High(MapStr) do
    TmpMap[y] := MapStr[y].ToCharArray;

  FMap := TmpMap;
end;

procedure TBoard.SetMap(const AValue: TArray<TArray<Char>>);
begin
  FMap := AValue;
end;

procedure TBoard.DrawScoreboard(Canvas: TCanvas);
var
  score_text, lives_text, end_text, game_text: String;
  x_score_pos, y_score_pos, x_lives_pos, y_lives_pos: Single;
  x_end_pos, y_end_pos, x_game_pos, y_game_pos: Single;
  textRect: TRectF; // Used for FillText
begin
  Canvas.Fill.Color := TAlphaColors.White; // Define a cor do texto
  Canvas.font.Assign(font); // Atribui a fonte configurada

  score_text := Format('Score: %d', [FGame.Settings.Score]);
  lives_text := Format('Lives: %dX', [Max(FGame.Settings.Lives, 0)]);

  // Desenha o placar de Score
  // Calculate text width for centering
  // FMX TCanvas.TextWidth returns the width of the text with the current font
  x_score_pos := (Application.MainForm.Width / 2) - (Canvas.TextWidth(score_text) / 2);
  y_score_pos := FGame.Settings.Scale * 30.75;
  textRect := RectF(x_score_pos, y_score_pos, x_score_pos + Canvas.TextWidth(score_text),
    y_score_pos + Canvas.TextHeight(score_text));
  Canvas.FillText(textRect, score_text, False, 1, [], TTextAlign.Center, TTextAlign.Center);

  // Desenha o placar de Lives
  x_lives_pos := (Application.MainForm.Width / 2) - (Canvas.TextWidth(lives_text) / 2);
  y_lives_pos := FGame.Settings.Scale * 32;
  textRect := RectF(x_lives_pos, y_lives_pos, x_lives_pos + Canvas.TextWidth(lives_text),
    y_lives_pos + Canvas.TextHeight(lives_text));
  Canvas.FillText(textRect, lives_text, False, 1, [], TTextAlign.Center, TTextAlign.Center);

  if FGame.Settings.Lives = -1 then
  begin
    end_text := 'GAME';
    game_text := 'OVER';

    // Desenha "GAME"
    x_end_pos := (Application.MainForm.Width / 2) - (Canvas.TextWidth(end_text) / 2);
    y_end_pos := FGame.Settings.Scale * 12.25;
    textRect := RectF(x_end_pos, y_end_pos, x_end_pos + Canvas.TextWidth(end_text),
      y_end_pos + Canvas.TextHeight(end_text));
    Canvas.FillText(textRect, end_text, False, 1, [], TTextAlign.Center, TTextAlign.Center);

    // Desenha "OVER"
    x_game_pos := (Application.MainForm.Width / 2) - (Canvas.TextWidth(game_text) / 2);
    y_game_pos := FGame.Settings.Scale * 13.75;
    textRect := RectF(x_game_pos, y_game_pos, x_game_pos + Canvas.TextWidth(game_text),
      y_game_pos + Canvas.TextHeight(game_text));
    Canvas.FillText(textRect, game_text, False, 1, [], TTextAlign.Center, TTextAlign.Center);
  end;
end;

function TBoard.GetMap: TArray<TArray<Char>>;
begin
  Result := FMap;
end;

end.
