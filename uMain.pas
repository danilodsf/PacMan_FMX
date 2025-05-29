unit uMain;

interface

uses
  FMX.Forms,
  System.Classes,
  PacMan.Interfaces.Game;

type
  TPacManForm = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Game: IGame;
  public
    { Public declarations }
  end;

var
  PacManForm: TPacManForm;

implementation

uses
  PacMan.Classes.uGame;

{$R *.fmx}

procedure TPacManForm.FormCreate(Sender: TObject);
begin
  Game := TGame.New(Self);
  Game.StartGame;
end;

procedure TPacManForm.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  Game.MovePlayer(Key, KeyChar);
end;

end.

