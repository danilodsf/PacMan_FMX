unit PacMan.Interfaces.GhostManager;

interface

uses
  PacMan.Interfaces.Ghost, FMX.Graphics;

type
  iGhostManager = interface
    ['{A7606506-7235-47C0-97F9-F9980376E793}']
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
  end;

implementation

end.
