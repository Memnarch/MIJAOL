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
    )
  );

implementation

end.
