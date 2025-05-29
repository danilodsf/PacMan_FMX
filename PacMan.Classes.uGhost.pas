unit PacMan.Classes.uGhost;

interface

uses
  System.Types,
  System.IOUtils,
  System.SysUtils,
  FMX.Graphics,
  PacMan.Utils,
  PacMan.Interfaces.Game,
  PacMan.Interfaces.Ghost;

type
  TGhost = class(TInterfacedObject, IGhost)
  private
    Fharmless_mode: boolean;
    FPosition: TPointF;
    FDirection: TPointF;
    FNextDirection: TPointF;
    FDistanceToPacMan: Single;
    FImages: TArray<TBitmap>;
    FColor: string;

    FGame: IGame;
    procedure LoadImages;
    function GetHarmlessMode: Boolean;
    function GetPosition: TPointF;
    function GetDirection: TPointF;
    function GetNextDirection: TPointF;
    function GetDistanceToPacMan: Single;
    function GetImages: TArray<TBitmap>;
    function GetColor: string;

    procedure SetHarmlessMode(const AValue: Boolean);
    procedure SetPosition(const AValue: TPointF);
    procedure SetDirection(const AValue: TPointF);
    procedure SetNextDirection(const AValue: TPointF);
    procedure SetDistanceToPacMan(const AValue: Single);
    procedure SetImages(const AValue: TArray<TBitmap>);
  public
    property HarmlessMode: boolean read GetHarmlessMode write SetHarmlessMode;
    property Position: TPointF read GetPosition write SetPosition;
    property Direction: TPointF read GetDirection write SetDirection;
    property NextDirection: TPointF read GetNextDirection write SetNextDirection;
    property DistanceToPacMan: Single read GetDistanceToPacMan write SetDistanceToPacMan;
    property Images: TArray<TBitmap> read GetImages write SetImages;
    property Color: string read GetColor;
    constructor Create(AGame: IGame; AColor: string; APosX, APosY: Single);
  end;

implementation

{ TGhost }

constructor TGhost.Create(AGame: IGame; AColor: string; APosX, APosY: Single);
begin
  FGame := AGame;
  FColor := AColor;
  Fharmless_mode := False;
  Fposition := PointF(APosX * FGame.Settings.Scale, APosY * FGame.Settings.Scale);
  Fdirection := PointF(0, 0);
  FnextDirection := PointF(0, 0);
  FdistanceToPacMan := 0;

  LoadImages;
end;

function TGhost.GetColor: string;
begin
  Result := FColor;
end;

function TGhost.GetDirection: TPointF;
begin
  Result := FDirection;
end;

function TGhost.GetDistanceToPacMan: Single;
begin
  Result := FDistanceToPacMan;
end;

function TGhost.GetHarmlessMode: Boolean;
begin
  Result := Fharmless_mode;
end;

function TGhost.GetImages: TArray<TBitmap>;
begin
  Result := FImages;
end;

function TGhost.GetNextDirection: TPointF;
begin
  Result := FNextDirection;
end;

function TGhost.GetPosition: TPointF;
begin
  Result := FPosition;
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

procedure TGhost.SetDirection(const AValue: TPointF);
begin
  FDirection := AValue;
end;

procedure TGhost.SetDistanceToPacMan(const AValue: Single);
begin
  FDistanceToPacMan := AValue;
end;

procedure TGhost.SetHarmlessMode(const AValue: Boolean);
begin
  Fharmless_mode := AValue;
end;

procedure TGhost.SetImages(const AValue: TArray<TBitmap>);
begin
  FImages := AValue;
end;

procedure TGhost.SetNextDirection(const AValue: TPointF);
begin
  FNextDirection := AValue;
end;

procedure TGhost.SetPosition(const AValue: TPointF);
begin
  FPosition := AValue;
end;

end.
