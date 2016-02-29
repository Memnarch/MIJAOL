unit Level_1_1.Entities;

interface

type
  TSpawnFlag = (sfCopyPosition);
  TSpawnFlags = set of TSpawnFlag;
  TBehaviorFlag = (bfIgnoreCollision);
  TBehaviorFlags = set of TBehaviorFlag;

  TEntity = record
    Active: Integer;
    X: Single;
    Y: Single;
    Input: Boolean;
    Live: Integer;
    LiveTime: Integer;
    Sprite: Integer;
    Vel_X: Single;
    Vel_Y: Single;
    Gravity: Single;
    LeftBlocked: Integer;
    RightBlocked: Integer;
    UpBlocked: Integer;
    DownBlocked: Integer;
    InAirTimer: Integer;
    bbWidth: Integer;
    bbHeight: Integer;
    DamageLeft: Integer;
    DamageRight: Integer;
    DamageTop: Integer;
    DamageBottom: Integer;
    ReplaceOnDead: Integer;
    SpawnFlags: TSpawnFlags;
    BehaviorFlags: TBehaviorFlags;
  end;

var
  GEntity: array[0..3] of TEntity =
  (
    (
      Active: 1;
      X: 8;
      Y: 192;
      {$i Mario.ent}
    ),

    (
      Active: 1;
      X: 240;
      Y: 190;
      {$i Gumba.ent}
    )
  );

implementation

end.
