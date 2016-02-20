unit Level_1_1.Entities;

interface

type
  TEntity = record
    Active: Boolean;
    Live: Integer;
    Sprite: Integer;
    X: Single;
    Y: Single;
    Vel_X: Single;
    Vel_Y: Single;
    LeftBlocked: Integer;
    RightBlocked: Integer;
    UpBlocked: Integer;
    DownBlocked: Integer;
  end;

var
  GEntity: array[0..0] of TEntity =
  (
    (
      Active: True;
      Live: 1;
      Sprite: 0;
      X: 16;
      Y: 16;
      Vel_X: 0;
      Vel_Y: 0;
      LeftBlocked: 0;
      RightBlocked: 0;
      UpBlocked: 0;
      DownBlocked: 0;
    )
  );

implementation

end.
