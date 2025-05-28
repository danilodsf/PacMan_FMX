unit uSettings;

interface

type
  TSettings = class
  private
    FScale: Single;
    FSpriteFrame: Integer;
    FSpriteSpeed: Integer;
    FScore: Integer;
    FLives: Integer;
    FEndGame: Boolean;
    FHarmlessMode: Boolean;
    FHarmlessModeTimer: Integer;
  public
    property Scale: Single read FScale;
    property SpriteFrame: Integer read FSpriteFrame write FSpriteFrame;
    property SpriteSpeed: Integer read FSpriteSpeed write FSpriteSpeed;
    property Score: Integer read FScore write FScore;
    property Lives: Integer read FLives write FLives;
    property EndGame: Boolean read FEndGame write FEndGame;
    property HarmlessMode: Boolean read FHarmlessMode write FHarmlessMode;
    property HarmlessModeTimer: Integer read FHarmlessModeTimer write FHarmlessModeTimer;

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

end.
