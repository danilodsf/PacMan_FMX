unit PacMan.Interfaces.Game;

interface

uses
  PacMan.Interfaces.Player,
  PacMan.Interfaces.Settings,
  PacMan.Interfaces.Board,
  PacMan.Interfaces.Movements,
  PacMan.Interfaces.GhostManager;

type
  IGame = interface
    ['{FE3D35D9-6A6A-4603-915D-2FACAC31990F}']
    procedure MovePlayer(key: Word; KeyChar: Char);
    procedure StartGame;

    function Player: IPlayer;
    function Settings: ISettings;
    function GhostManager: IGhostManager;
    function Board: IBoard;
    function Movements: IMovements;
  end;

implementation

end.
