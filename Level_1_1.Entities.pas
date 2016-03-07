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
    Team: Integer;
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
    ReplaceOnTimeOut: Integer;
    SpawnFlags: TSpawnFlags;
    BehaviorFlags: TBehaviorFlags;
    LastCollider: Integer;
    LastColliderTime: Integer;
  end;

const
  CBottom = 0;

var
  GEntity: array[0..107] of TEntity =
  (
    (
      Active: 1;
      X: 8;
      Y: 208;
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
    ),
    //end of fifth blockgroup
    //enemies of first blockgroup
    (
      Active: 1;
      X: 360;
      Y: 208;
      {$i Gumba.ent}
    ),
    //enemies in first pipe section
    (
      Active: 1;
      X: 680;
      Y: 208;
      {$i Gumba.ent}
    ),
    //enemies in second pipe section
    (
      Active: 1;
      X: 824;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 856;
      Y: 208;
      {$i Gumba.ent}
    ),
    //enemies of second blockgroup
    (
      Active: 1;
      X: 1288;
      Y: 80;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 1320;
      Y: 80;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 1560;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 1592;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 1752;
      Y: 208;
      {$i Koopa.ent}
    ),
    //enemies of fourth blockgroup
    (
      Active: 1;
      X: 1896;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 1928;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 2008;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 2040;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 2088;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 2120;
      Y: 208;
      {$i Gumba.ent}
    ),
    //enemies of fifth blockgroup
    (
      Active: 1;
      X: 2808;
      Y: 208;
      {$i Gumba.ent}
    ),
    (
      Active: 1;
      X: 2840;
      Y: 208;
      {$i Gumba.ent}
    )
  );

implementation

end.
