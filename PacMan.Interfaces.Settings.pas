unit PacMan.Interfaces.Settings;

interface

type
  iSettings = interface
    ['{AEB17066-C71D-4D82-A811-8F26820D3AC7}']
    function GetScale: Single;
    function GetSpriteFrame: Integer;
    function GetSpriteSpeed: Integer;
    function GetScore: Integer;
    function GetLives: Integer;
    function GetEndGame: Boolean;
    function GetHarmlessMode: Boolean;

    procedure SetScale(const AValue: Single);
    procedure SetSpriteFrame(const AValue: Integer);
    procedure SetSpriteSpeed(const AValue: Integer);
    procedure SetScore(const AValue: Integer);
    procedure SetLives(const AValue: Integer);
    procedure SetEndGame(const AValue: Boolean);
    procedure SetHarmlessMode(const AValue: Boolean);

    property Scale: Single read GetScale;
    property SpriteFrame: Integer read GetSpriteFrame write SetSpriteFrame;
    property SpriteSpeed: Integer read GetSpriteSpeed write SetSpriteSpeed;
    property Score: Integer read GetScore write SetScore;
    property Lives: Integer read GetLives write SetLives;
    property EndGame: Boolean read GetEndGame write SetEndGame;
    property HarmlessMode: Boolean read GetHarmlessMode write SetHarmlessMode;
  end;

implementation

end.
