unit PacMan.Interfaces.Ghost;

interface

uses
  System.Types,
  System.Generics.Collections,
  FMX.Graphics;

type
  IGhost = interface
    ['{EA25BE93-2204-4BDD-9861-DC56784EAB70}']
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

    property HarmlessMode: boolean read GetHarmlessMode write SetHarmlessMode;
    property Position: TPointF read GetPosition write SetPosition;
    property Direction: TPointF read GetDirection write SetDirection;
    property NextDirection: TPointF read GetNextDirection write SetNextDirection;
    property DistanceToPacMan: Single read GetDistanceToPacMan write SetDistanceToPacMan;
    property Images: TArray<TBitmap> read GetImages write SetImages;
    property Color: string read GetColor;
  end;

implementation

end.
