unit uMain;

interface

uses
  FMX.Forms,
  System.Classes,
  uGame;

type
  TPacManForm = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Game: TGame;
  public
    { Public declarations }
  end;

var
  PacManForm: TPacManForm;

implementation

{$R *.fmx}

procedure TPacManForm.FormCreate(Sender: TObject);
begin
  Game := TGame.Create(Self);
  Game.StartGame;
end;

procedure TPacManForm.FormDestroy(Sender: TObject);
begin
  Game.Free;
end;

procedure TPacManForm.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  Game.MovePlayer(Key, KeyChar);
end;

end.

