unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Types, Vcl.Imaging.pngimage;

type
  TFormPacman = class(TForm)
    imgGame: TImage;
    tmrGameLoop: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrGameLoopTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FScale: Integer;
    FMap: TArray<TArray<Char>>;
    FPacmanPos, FPacmanDir: TPointF;
    FScore, FLives: Integer;
    FPacmanSprites: array[0..5] of TPngImage;
    FPacmanFrameIndex: Integer;
    FRotationAngle: Single;
    procedure LoadMap;
    procedure LoadPacmanSprites;
    procedure FreePacmanSprites;
    procedure DrawBoard;
    procedure DrawPacman;
    procedure MovePacman;
    procedure CollectDots;
    procedure DrawScore;
    function RotateBitmap(Source: TGraphic; Angle: Single): TBitmap;
  public
    { Public declarations }
  end;

var
  FormPacman: TFormPacman;

implementation

{$R *.dfm}

procedure TFormPacman.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  KeyPreview := True;
  FScale := 26;
  Width := Round(FScale * 27.5);
  Height := Round(FScale * 35);
  imgGame.Width := Width;
  imgGame.Height := Height;
  FPacmanPos := PointF(13.1 * FScale, 22.6 * FScale);
  FPacmanDir := PointF(FScale / 16, 0);
  FScore := 0;
  FLives := 5;
  FPacmanFrameIndex := 0;
  FRotationAngle := 0;
  LoadMap;
  LoadPacmanSprites;
end;

procedure TFormPacman.FormDestroy(Sender: TObject);
begin
  FreePacmanSprites;
end;

procedure TFormPacman.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    vk_Left:
      begin
        FPacmanDir := PointF(-FScale / 16, 0);
        FRotationAngle := 180;
      end;
    vk_Right:
      begin
        FPacmanDir := PointF(FScale / 16, 0);
        FRotationAngle := 0;
      end;
    vk_Up:
      begin
        FPacmanDir := PointF(0, -FScale / 16);
        FRotationAngle := 270;
      end;
    vk_Down:
      begin
        FPacmanDir := PointF(0, FScale / 16);
        FRotationAngle := 90;
      end;
  end;
end;

procedure TFormPacman.FreePacmanSprites;
var
  i: Integer;
begin
  for i := 0 to 5 do
    FPacmanSprites[i].Free;
end;

procedure TFormPacman.LoadMap;
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

procedure TFormPacman.LoadPacmanSprites;
var
  i: Integer;
  FileName: string;
begin
  for i := 0 to 5 do
  begin
    FPacmanSprites[i] := TPngImage.Create;
    FileName := Format('.\img\Pac_Man_%d.png', [i + 1]);
    if FileExists(FileName) then
      FPacmanSprites[i].LoadFromFile(FileName);
  end;
end;

procedure TFormPacman.DrawBoard;
var
  bmp: TBitmap;
  x, y: Integer;
  c: Char;
begin
  bmp := TBitmap.Create;
  try
    bmp.SetSize(imgGame.Width, imgGame.Height);
    bmp.Canvas.Brush.Color := clBlack;
    bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));

    for y := 0 to High(FMap) do
      for x := 0 to High(FMap[y]) do
      begin
        c := FMap[y][x];
        case c of
          '#':
            begin
              bmp.Canvas.Brush.Color := clBlue;
              bmp.Canvas.FillRect(Rect(x * FScale, y * FScale, (x + 1) * FScale, (y + 1) * FScale));
            end;
          '.':
            begin
              bmp.Canvas.Pen.Color := clWhite;
              bmp.Canvas.Brush.Color := clWhite;
              bmp.Canvas.Ellipse(x * FScale + FScale div 2 - 2, y * FScale + FScale div 2 - 2,
                                 x * FScale + FScale div 2 + 2, y * FScale + FScale div 2 + 2);
            end;
        end;
      end;

    imgGame.Canvas.Draw(0, 0, bmp);
  finally
    bmp.Free;
  end;
end;

procedure TFormPacman.DrawPacman;
var
  bmp: TBitmap;
begin
  if Assigned(FPacmanSprites[FPacmanFrameIndex]) then
    imgGame.Canvas.Draw(Round(FPacmanPos.X), Round(FPacmanPos.Y), FPacmanSprites[FPacmanFrameIndex]);
end;

procedure TFormPacman.MovePacman;
begin
  FPacmanPos.X := FPacmanPos.X + FPacmanDir.X;
  FPacmanPos.Y := FPacmanPos.Y + FPacmanDir.Y;
end;

procedure TFormPacman.tmrGameLoopTimer(Sender: TObject);
begin
  FPacmanFrameIndex := (FPacmanFrameIndex + 1) mod 6;
  MovePacman;
  CollectDots;
  DrawBoard;
  DrawPacman;
  DrawScore;
end;

procedure TFormPacman.CollectDots;
var
  px, py: Integer;
begin
  px := Round(FPacmanPos.X + FScale div 2) div FScale;
  py := Round(FPacmanPos.Y + FScale div 2) div FScale;
  if (py >= 0) and (py <= High(FMap)) and
     (px >= 0) and (px <= High(FMap[py])) and
     (FMap[py][px] = '.') then
  begin
    FMap[py][px] := ' ';
    Inc(FScore);
  end;
end;

procedure TFormPacman.DrawScore;
begin
  imgGame.Canvas.Font.Color := clWhite;
  imgGame.Canvas.Font.Size := 12;
  imgGame.Canvas.TextOut(10, imgGame.Height - 30, Format('Score: %d  Lives: %d', [FScore, FLives]));
end;

function TFormPacman.RotateBitmap(Source: TGraphic; Angle: Single): TBitmap;
var
  radians: Single;
  sinAngle, cosAngle: Single;
  cx, cy: Integer;
  srcBmp, destBmp: TBitmap;
  x, y, newX, newY: Integer;
  color: TColor;
begin
  srcBmp := TBitmap.Create;
  srcBmp.SetSize(Source.Width, Source.Height);
  srcBmp.Canvas.Draw(0, 0, Source);
  destBmp := TBitmap.Create;
  destBmp.SetSize(Source.Width, Source.Height);
  destBmp.Canvas.Brush.Color := clBlack;
  destBmp.Canvas.FillRect(Rect(0, 0, destBmp.Width, destBmp.Height));

  radians := Angle * PI / 180;
  sinAngle := Sin(radians);
  cosAngle := Cos(radians);
  cx := srcBmp.Width div 2;
  cy := srcBmp.Height div 2;

  for y := 0 to srcBmp.Height - 1 do
    for x := 0 to srcBmp.Width - 1 do
    begin
      newX := Round(cosAngle * (x - cx) - sinAngle * (y - cy) + cx);
      newY := Round(sinAngle * (x - cx) + cosAngle * (y - cy) + cy);
      if (newX >= 0) and (newX < srcBmp.Width) and (newY >= 0) and (newY < srcBmp.Height) then
      begin
        color := srcBmp.Canvas.Pixels[x, y];
        destBmp.Canvas.Pixels[newX, newY] := color;
      end;
    end;

  srcBmp.Free;
  Result := destBmp;
end;

end.
