unit PacMan.Interfaces.Movements;

interface

uses
  System.Types;

type
  iMovements = interface
    ['{676B72BF-7C11-41D5-A9DB-FF3F28D4C8D3}']
    procedure TurningCorner(position: TPointF; var direction: TPointF; next_direction: TPointF);
    procedure Collider(var position: TPointF; direction: TPointF);
    procedure Tunnel(var position: TPointF);
    procedure MoveDown;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveUp;
  end;

implementation

end.
