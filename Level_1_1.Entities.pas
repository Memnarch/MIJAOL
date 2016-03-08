unit Level_1_1.Entities;

interface

type
  TSpawnFlag = (sfCopyPosition);
  TSpawnFlags = set of TSpawnFlag;
  TBehaviorFlag = (bfIgnoreCollision, bfCameraFollows, bfCameraCenters, bfAlwaysUpdate);
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
    Frames: Integer;
    Vel_X: Single;
    Vel_Y: Single;
    BounceX: Single;
    BounceY: Single;
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
  CFirstEntity = 0;
  CLastEntity = 112;
  CGameOverScreen = CLastEntity;

var
  GEntity: array[CFirstEntity..CLastEntity] of TEntity =
  (
    //Dummy enemie the StartScreen collides with and kills it
    (
      Active: 1;
      X: 3256;
      Y: 400;
      Live: 1;
      Sprite: 0;
      bbWidth: 64;
      bbHeight: 8;
      DamageBottom: 1;
      VulnerableBottom: 1;
    ),
    //StartScreen which is replaced by Mario on death
    (
      Active: 1;
      X: 3256;
      Y: 420;
      Input: True;
      Team: 1;
      Live: 1;
      Sprite: 11;
      Frames: 1;
      Gravity: 1;
      bbWidth: 8;
      bbHeight: 8;
      DamageTop: 1;
      VulnerableTop: 1;
      ReplaceOnDead: 1;
      BehaviorFlags: [bfCameraCenters];
    ),
    (
      X: 40;
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
      Y: 204;
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
    ),
    //FinishBlock
    //Invisible and put on the ground so it triggers when Mario walks over
    (
      Active: 1;
      X: 3272;
      Y: 217;
      Live: 1;
      Sprite: 13;
      bbWidth: 4;
      bbHeight: 4;
      VulnerableLeft: 1;
      VulnerableRight: 1;
      VulnerableTop: 1;
      VulnerableBottom: 1;
      ReplaceOnDead: 1;
      BehaviorFlags: [bfIgnoreCollision];
    ),
    //FinishScreen
    (
      Live: 1;
      Sprite: 12;
      Frames: 1;
      SpawnFlags: [sfCopyPosition];
      BehaviorFlags: [bfIgnoreCollision, bfCameraCenters];
    ),
    //GameOverScreen
    (
      Live: 1;
      Sprite: 10;
      Frames: 1;
      BehaviorFlags: [bfIgnoreCollision, bfCameraCenters, bfAlwaysUpdate];
    )
  );

implementation

end.
