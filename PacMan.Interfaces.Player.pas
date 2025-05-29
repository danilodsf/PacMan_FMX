unit PacMan.Interfaces.Player;

interface

uses
  System.Types,
  System.Generics.Collections,
  FMX.Graphics;

type
  IPlayer = interface
    ['{19AC815D-21C3-402B-92D2-1C75E182C1AB}']
    function GetSpeedFactor: Single;
    function GetPosition: TPointF;
    function GetDirection: TPointF;
    function GetNextDirection: TPointF;
    function GetImages: TArray<TBitmap>;

    procedure SetPosition(const AValue: TPointF);
    procedure SetDirection(const AValue: TPointF);
    procedure SetNextDirection(const AValue: TPointF);
    procedure SetImages(const AValue: TArray<TBitmap>);

    property SpeedFactor: Single read GetSpeedFactor;
    property Position: TPointF read GetPosition write SetPosition;
    property Direction: TPointF read GetDirection write SetDirection;
    property NextDirection: TPointF read GetNextDirection write SetNextDirection;
    property Images: TArray<TBitmap> read GetImages write SetImages;
    procedure Draw(Canvas: TCanvas);
    procedure CollectDots;
  end;

implementation

end.
//    property OnPowerPelletCollected: THarmlessGhostsProc read FOnPowerPelletCollected write FOnPowerPelletCollected;
