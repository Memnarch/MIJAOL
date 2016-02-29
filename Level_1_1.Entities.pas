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
    VulnerableLeft: Integer;
    VulnerableRight: Integer;
    VulnerableTop: Integer;
    VulnerableBottom: Integer;
    ReplaceOnDead: Integer;
    SpawnFlags: TSpawnFlags;
    BehaviorFlags: TBehaviorFlags;
  end;

const
  CBottom = 0;

var
  GEntity: array[0..16] of TEntity =
  (
    (
      Active: 1;
      X: 8;
      Y: 192;
      {$i Mario.ent}
    ),
    //First Blockgroup
    //       ?
    //
    //
    //
    // ?   #?#?#
    //
    //
    //
    ////////////////////
    (
      Active: 1;
      X: 264;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 264;
      Y: 160;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 328;
      Y: 160;
      {$i Block.ent}
    ),

    (
      Active: 1;
      X: 344;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 344;
      Y: 160;
      {$i CoinBlock.ent}
    ),

    (
      Active: 1;
      X: 360;
      Y: 160;
      {$i Block.ent}
    ),

    (
      Active: 1;
      X: 376;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 376;
      Y: 160;
      {$i CoinBlock.ent}
    ),

    (
      Active: 1;
      X: 392;
      Y: 160;
      {$i Block.ent}
    ),

    (
      Active: 1;
      X: 360;
      Y: 96;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 360;
      Y: 96;
      {$i CoinBlock.ent}
    )
    //Endof first Blockgroup
  );

implementation

end.
