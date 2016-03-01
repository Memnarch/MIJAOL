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
  GEntity: array[0..70] of TEntity =
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
    ),
    //Endof first Blockgroup
    //Second Blockgroup
    //   ########   ###?
    //
    //
    //
    //#?#              #
    //
    //
    //
    //////////////////////////
    (
      Active: 1;
      X: 1240;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1256;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 1256;
      Y: 160;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 1272;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1288;
      Y: 96;
      {$i Block.ent}
    ),
    //
    (
      Active: 1;
      X: 1304;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1320;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1336;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1352;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1368;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1384;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1400;
      Y: 96;
      {$i Block.ent}
    ),
    //
    (
      Active: 1;
      X: 1464;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1480;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1496;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1512;
      Y: 96;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 1512;
      Y: 96;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 1512;
      Y: 160;
      {$i Block.ent}
    ),
    //end of second BlockGroup
    //third Blockgroud
    //         ?
    //
    //
    //
    //##    ?  ?  ?
    //
    //
    //
    //////////////////////////
    (
      Active: 1;
      X: 1608;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1624;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1704;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 1704;
      Y: 160;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 1752;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 1752;
      Y: 160;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 1752;
      Y: 96;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 1752;
      Y: 96;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 1800;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 1800;
      Y: 160;
      {$i CoinBlock.ent}
    ),
    //end of third blockgroup
    //fourth blockgroup
    //   ###    #??#
    //
    //
    //
    //#          ##
    //
    //
    //
    //////////////////////////
    (
      Active: 1;
      X: 1896;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1944;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1960;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 1976;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 2056;
      Y: 96;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 2072;
      Y: 96;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 2072;
      Y: 96;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 2088;
      Y: 96;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 2088;
      Y: 96;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 2072;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 2088;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 2104;
      Y: 96;
      {$i Block.ent}
    ),
    //end of fourth blockgroup
    //fifth blockgroup
    //
    //
    //
    //
    //##?#
    //
    //
    //
    //////////////////////////
    (
      Active: 1;
      X: 2696;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 2712;
      Y: 160;
      {$i Block.ent}
    ),
    (
      Active: 1;
      X: 2728;
      Y: 160;
      {$i ItemBlockEmpty.ent}
    ),
    (
      Active: 1;
      X: 2728;
      Y: 160;
      {$i CoinBlock.ent}
    ),
    (
      Active: 1;
      X: 2744;
      Y: 160;
      {$i Block.ent}
    )
    //end of fifth blockgroup
  );

implementation

end.
