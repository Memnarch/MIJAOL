unit Level_1_1.Entities;

interface

type
  TEntity = record
    Active: Boolean;
    X: Single;
    Y: Single;
    Input: Boolean;
    Live: Integer;
    Sprite: Integer;
    Vel_X: Single;
    Vel_Y: Single;
    Gravity: Single;
    LeftBlocked: Integer;
    RightBlocked: Integer;
    UpBlocked: Integer;
    DownBlocked: Integer;
    InAirTimer: Integer;
  end;

var
  GEntity: array[0..1] of TEntity =
  (
    (
      Active: True;
      X: 16;
      Y: 16;
      {$i Mario.ent}
    ),

    (
      Active: True;
      X: 128;
      Y: 128;
      {$i Block.ent}
    )
  );

implementation

end.
