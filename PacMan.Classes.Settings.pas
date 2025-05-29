unit PacMan.Classes.Settings;

interface

uses
  PacMan.Interfaces.Settings;

type
  TSettings = class(TInterfacedObject, ISettings)
  private
    FScale: Single;
    FSpriteFrame: Integer;
    FSpriteSpeed: Integer;
    FScore: Integer;
    FLives: Integer;
    FEndGame: Boolean;
    FHarmlessMode: Boolean;
    FHarmlessModeTimer: Integer;

    function GetScale: Single;
    function GetSpriteFrame: Integer;
    function GetSpriteSpeed: Integer;
    function GetScore: Integer;
    function GetLives: Integer;
    function GetEndGame: Boolean;
    function GetHarmlessMode: Boolean;
    function GetHarmlessModeTimer: Integer;

    procedure SetScale(const AValue: Single);
    procedure SetSpriteFrame(const AValue: Integer);
    procedure SetSpriteSpeed(const AValue: Integer);
    procedure SetScore(const AValue: Integer);
    procedure SetLives(const AValue: Integer);
    procedure SetEndGame(const AValue: Boolean);
    procedure SetHarmlessMode(const AValue: Boolean);
    procedure SetHarmlessModeTimer(const AValue: Integer);
  public
    property Scale: Single read GetScale;
    property SpriteFrame: Integer read GetSpriteFrame write SetSpriteFrame;
    property SpriteSpeed: Integer read GetSpriteSpeed write SetSpriteSpeed;
    property Score: Integer read GetScore write SetScore;
    property Lives: Integer read GetLives write SetLives;
    property EndGame: Boolean read GetEndGame write SetEndGame;
    property HarmlessMode: Boolean read GetHarmlessMode write SetHarmlessMode;
    property HarmlessModeTimer: Integer read GetHarmlessModeTimer write SetHarmlessModeTimer;

    constructor Create;
  end;

implementation

{ TSettings }

constructor TSettings.Create;
begin
  FScale := 26;
  FSpriteFrame := 0;
  FSpriteSpeed := 2;
  FScore := 0;
  FLives := 5;
  FEndGame := False;
  FHarmlessMode := False;
  FHarmlessModeTimer := 0;
end;

function TSettings.GetEndGame: Boolean;
begin
  Result := FEndGame;
end;

function TSettings.GetHarmlessMode: Boolean;
begin
  Result := FHarmlessMode;
end;

function TSettings.GetHarmlessModeTimer: Integer;
begin
  Result := FHarmlessModeTimer;
end;

function TSettings.GetLives: Integer;
begin
  Result := FLives;
end;

function TSettings.GetScale: Single;
begin
  Result := FScale;
end;

function TSettings.GetScore: Integer;
begin
  Result := FScore;
end;

function TSettings.GetSpriteFrame: Integer;
begin
  Result := FSpriteFrame;
end;

function TSettings.GetSpriteSpeed: Integer;
begin
  Result := FSpriteSpeed;
end;

procedure TSettings.SetEndGame(const AValue: Boolean);
begin
  FEndGame := AValue;
end;

procedure TSettings.SetHarmlessMode(const AValue: Boolean);
begin
  FHarmlessMode := AValue;
end;

procedure TSettings.SetHarmlessModeTimer(const AValue: Integer);
begin
  FHarmlessModeTimer := AValue;
end;

procedure TSettings.SetLives(const AValue: Integer);
begin
  FLives := AValue;
end;

procedure TSettings.SetScale(const AValue: Single);
begin
  FScale := AValue;
end;

procedure TSettings.SetScore(const AValue: Integer);
begin
  FScore := AValue;
end;

procedure TSettings.SetSpriteFrame(const AValue: Integer);
begin
  FSpriteFrame := AValue;
end;

procedure TSettings.SetSpriteSpeed(const AValue: Integer);
begin
  FSpriteSpeed := AValue;
end;

end.
