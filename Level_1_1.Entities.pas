unit Level_1_1.Entities;

interface

type
  TEntity = record
    Active: Boolean;
    Input: Boolean;
    Live: Integer;
    Sprite: Integer;
    X: Single;
    Y: Single;
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
      Input: True;
      Live: 1;
      Sprite: 0;
      X: 16;
      Y: 16;
      Gravity: 1;
    ),

    (
      Live: 1;
      Sprite: 1;
      X: 128;
      Y: 128;
    )
  );

implementation

end.
