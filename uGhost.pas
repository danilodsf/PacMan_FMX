unit uGhost;

interface

uses
  System.Types, FMX.Graphics, uUtils, System.IOUtils, System.SysUtils,
  uSettings;

type
  TGhost = class
  private
    Fharmless_mode: boolean;
    FPosition: TPointF;
    FDirection: TPointF;
    FNextDirection: TPointF;
    FDistanceToPacMan: Single;
    FImages: TArray<TBitmap>;
    FColor: string;
    FSettings: TSettings;
    procedure LoadImages;
  public
    property harmlessMode: boolean read Fharmless_mode write Fharmless_mode;
    property Position: TPointF read FPosition write FPosition;
    property Direction: TPointF read FDirection write FDirection;
    property NextDirection: TPointF read FNextDirection write FNextDirection;
    property DistanceToPacMan: Single read FDistanceToPacMan write FDistanceToPacMan;
    property Images: TArray<TBitmap> read FImages write FImages;
    property Color: string read FColor;
    constructor Create(ASettings: TSettings; AColor: string; APosX, APosY: Single);
  end;

implementation

{ TGhost }

constructor TGhost.Create(ASettings: TSettings; AColor: string; APosX, APosY: Single);
begin
  FSettings := ASettings;
  FColor := AColor;
  Fharmless_mode := False;
  Fposition := PointF(APosX * FSettings.Scale, APosY * FSettings.Scale);
  Fdirection := PointF(0, 0);
  FnextDirection := PointF(0, 0);
  FdistanceToPacMan := 0;

  LoadImages;
end;

procedure TGhost.LoadImages;
var
  idxImage: integer;
begin
  SetLength(FImages, 2);

  if FColor = 'Harmless' then
  begin
    for idxImage := 0 to 1 do
      CreateSprite(Images[idxImage], TPath.Combine(GetCurrentDir,
        Format('img\'+Color+'_Ghost_%d.png', [idxImage])));
    Exit;
  end;

  for idxImage := 0 to 1 do
    CreateSprite(Images[idxImage], TPath.Combine(GetCurrentDir,
      Format('img\'+Color+'_Ghost_Down_Right_%d.png', [idxImage])));
end;

end.
