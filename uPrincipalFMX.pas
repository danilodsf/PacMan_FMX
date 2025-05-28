unit uPrincipalFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.IOUtils;

type
  TFormPacMan = class(TForm)
    GameTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure GameTimerTimer(Sender: TObject);
  private
    FCanvasBitmap: TBitmap;
    FMap: TArray<TArray<Char>>;
    FScale: Integer;
    FPacmanPos, FPacmanDir: TPointF;
    FPacmanFrame: Integer;
    FPacmanAngle: Single;
    FScore: Integer;
    FPacmanSprites: array[0..5] of TBitmap;
    procedure LoadMap;
    procedure LoadPacmanSprites;
    procedure DrawMap;
    procedure DrawPacman;
    procedure MovePacman;
    procedure CollectDots;
    procedure DrawHUD;
  public
    { Public declarations }
  end;

var
  FormPacMan: TFormPacMan;

implementation


{$R *.fmx}

procedure TFormPacMan.CollectDots;
var
  px, py: Integer;
begin
  px := Round(FPacmanPos.X + FScale / 2) div FScale;
  py := Round(FPacmanPos.Y + FScale / 2) div FScale;
  if (py >= 0) and (py <= High(FMap)) and
     (px >= 0) and (px <= High(FMap[py])) and
     (FMap[py][px] = '.') then
  begin
    FMap[py][px] := ' ';
    Inc(FScore);
  end;
end;

procedure TFormPacMan.DrawHUD;
begin
  FCanvasBitmap.Canvas.BeginScene;
  FCanvasBitmap.Canvas.Fill.Color := TAlphaColorRec.White;
  FCanvasBitmap.Canvas.FillText(TRectF.Create(10, ClientHeight - 30, 300, ClientHeight),
    Format('Score: %d', [FScore]), False, 1, [], TTextAlign.Leading, TTextAlign.Center);
  FCanvasBitmap.Canvas.EndScene;

  Canvas.BeginScene;
  Canvas.DrawBitmap(FCanvasBitmap, FCanvasBitmap.BoundsF, ClientRect, 1, True);
  Canvas.EndScene;
end;

procedure TFormPacMan.DrawMap;
var
  x, y: Integer;
  c: Char;
begin
  with FCanvasBitmap.Canvas do
  begin
    BeginScene;
    Clear(TAlphaColorRec.Black);
    for y := 0 to High(FMap) do
      for x := 0 to High(FMap[y]) do
      begin
        c := FMap[y][x];
        case c of
          '#':
            begin
              Fill.Color := TAlphaColorRec.Blue;
              FillRect(TRectF.Create(x * FScale, y * FScale, (x + 1) * FScale, (y + 1) * FScale), 0, 0, [], 1);
            end;
          '.':
            begin
              Fill.Color := TAlphaColorRec.White;
              FillEllipse(TRectF.Create(x * FScale + FScale / 2 - 2, y * FScale + FScale / 2 - 2,
                                         x * FScale + FScale / 2 + 2, y * FScale + FScale / 2 + 2), 1);
            end;
        end;
      end;
    EndScene;
  end;
end;

procedure TFormPacMan.DrawPacman;
var
  bmp: TBitmap;
  dst: TRectF;
begin
  bmp := FPacmanSprites[FPacmanFrame];
  dst := TRectF.Create(FPacmanPos.X, FPacmanPos.Y, FPacmanPos.X + FScale, FPacmanPos.Y + FScale);
  FCanvasBitmap.Canvas.BeginScene;
  FCanvasBitmap.Canvas.DrawBitmap(bmp, bmp.BoundsF, dst, 1, True);
  FCanvasBitmap.Canvas.EndScene;
end;

procedure TFormPacMan.FormCreate(Sender: TObject);
begin
  FScale := 26;
  ClientWidth := Round(FScale * 27.5);
  ClientHeight := Round(FScale * 35);

  FCanvasBitmap := TBitmap.Create(ClientWidth, ClientHeight);
  FPacmanPos := PointF(13.1 * FScale, 22.6 * FScale);
  FPacmanDir := PointF(FScale / 16, 0);
  FPacmanFrame := 0;
  FPacmanAngle := 0;
  FScore := 0;

  LoadMap;
  LoadPacmanSprites;

  GameTimer.Interval := 100;
  GameTimer.Enabled := True;
end;

procedure TFormPacMan.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  FCanvasBitmap.Free;
  for i := 0 to 5 do
    FPacmanSprites[i].Free;
end;

procedure TFormPacMan.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  case Key of
    vkLeft:
      begin
        FPacmanDir := PointF(-FScale / 16, 0);
        FPacmanAngle := 180;
      end;
    vkRight:
      begin
        FPacmanDir := PointF(FScale / 16, 0);
        FPacmanAngle := 0;
      end;
    vkUp:
      begin
        FPacmanDir := PointF(0, -FScale / 16);
        FPacmanAngle := 270;
      end;
    vkDown:
      begin
        FPacmanDir := PointF(0, FScale / 16);
        FPacmanAngle := 90;
      end;
  end;
end;

procedure TFormPacMan.GameTimerTimer(Sender: TObject);
begin
  FPacmanFrame := (FPacmanFrame + 1) mod 6;
  MovePacman;
  CollectDots;
  DrawMap;
  DrawPacman;
  DrawHUD;
end;

procedure TFormPacMan.LoadMap;
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
begin
  SetLength(FMap, Length(MapStr));
  for y := 0 to High(MapStr) do
    FMap[y] := MapStr[y].ToCharArray;
end;

procedure TFormPacMan.LoadPacmanSprites;
var
  i: Integer;
  FileName: string;
begin
  for i := 0 to 5 do
  begin
    FileName := TPath.Combine('img', Format('Pac_Man_%d.png', [i + 1]));
    FPacmanSprites[i] := TBitmap.CreateFromFile(FileName);
  end;
end;

procedure TFormPacMan.MovePacman;
begin
  FPacmanPos := FPacmanPos + FPacmanDir;
end;

end.


