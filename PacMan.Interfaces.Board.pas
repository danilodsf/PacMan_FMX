unit PacMan.Interfaces.Board;

interface

uses
  FMX.Graphics;

type
  iBoard = interface
    ['{CAC90B31-E6A9-4DE6-9860-03C7A339E8FC}']
    function GetMap: TArray<TArray<Char>>;
    procedure SetMap(const AValue: TArray<TArray<Char>>);

    property Map: TArray<TArray<Char>> read GetMap write SetMap;
    procedure Draw(ACanvas: TCanvas);
    procedure LoadMap;
    procedure DrawScoreboard(Canvas: TCanvas);
  end;

implementation

end.
