unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TScreenForm = class(TForm)
    RenderTimer: TTimer;
    Display: TPaintBox;
    procedure DisplayPaint(Sender: TObject);
    procedure RenderTimerTimer(Sender: TObject);
  private
    { Private declarations }
    FBackBuffer: TBitmap;
    FLevel: TBitmap;
    FStaticCollision: TBitmap;
    FDynamicCollision: array[Boolean] of TBitmap;
    //first dimension is for different characters
    //second dimension represents the states:
    //0 = stand, 1 = walk, 2 =  jump/InAir
    FSprites: array[0..4] of array[0..2] of TBitmap;
    FFlippedSprites: array[0..4] of array[0..2] of TBitmap;
    FCamera_X: Integer;
    FCamera_Y: Integer;
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    FFrameCounter: Integer;
    FCurrentDC: Boolean;
    procedure LoadSprites;
    procedure LoadSprite(AIndex: Integer; const AStand, AWalk, AJump: string);
    procedure DrawRect(ATarget, ASource: TCanvas; AX, AY: Integer; ASRect: TRect);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  ScreenForm: TScreenForm;

implementation

uses
  PNGImage,
  Level_1_1.Entities,
  SyncObjs,
  Math;

const
  CSpriteWidth = 16;
  CSpriteHeight = 16;
  CHalfSpriteWidth = 8;
  CHalfSpriteHeight = 8;
  CNoDynCollision = clWhite;

{$R *.dfm}

{ TScreenForm }

constructor TScreenForm.Create(AOwner: TComponent);
begin
  inherited;
  FBackBuffer := TBitmap.Create();
  FBackBuffer.SetSize(256, 240);
  FBackBuffer.PixelFormat := pf32bit;
  FLevel := TBitmap.Create();
  FLevel.LoadFromFile('..\..\Level-1-1.bmp');
  FLevel.PixelFormat := pf32bit;
  FStaticCollision := TBitmap.Create();
  FStaticCollision.LoadFromFile('..\..\Level-1-1-Collision.bmp');
  FStaticCollision.PixelFormat := pf32bit;
  FDynamicCollision[False] := TBitmap.Create();
  FDynamicCollision[False].SetSize(FStaticCollision.Width, FStaticCollision.Height);
  FDynamicCollision[False].PixelFormat := pf32bit;
  FDynamicCollision[False].Canvas.Brush.Color := CNoDynCollision;
  FDynamicCollision[False].Canvas.Pen.Color := CNoDynCollision;
  FDynamicCollision[False].Canvas.FillRect(FDynamicCollision[False].Canvas.ClipRect);

  FDynamicCollision[True] := TBitmap.Create();
  FDynamicCollision[True].SetSize(FStaticCollision.Width, FStaticCollision.Height);
  FDynamicCollision[True].PixelFormat := pf32bit;
  FDynamicCollision[True].Canvas.Brush.Color := CNoDynCollision;
  FDynamicCollision[True].Canvas.Pen.Color := CNoDynCollision;
  FDynamicCollision[True].Canvas.FillRect(FDynamicCollision[True].Canvas.ClipRect);
  ClientHeight := FBackBuffer.Height * 2;
  ClientWidth := FBackBuffer.Width;
  LoadSprites();
  FScreenWidth := FBackBuffer.Width;
  FScreenHeight := FBackBuffer.Height;
end;

procedure TScreenForm.DisplayPaint(Sender: TObject);
begin
  Display.Canvas.CopyMode := SRCCOPY;
  Display.Canvas.StretchDraw(Rect(0, 0, Display.ClientWidth, Display.ClientHeight div 2), FBackBuffer);

  Display.Canvas.CopyRect(Rect(0, Display.ClientHeight div 2, Display.ClientWidth, Display.ClientHeight div 2 * 2),
    FStaticCollision.Canvas, Rect(FCamera_X, FCamera_Y, FCamera_X + FBackBuffer.Width, FBackBuffer.Height));

  Display.Canvas.CopyMode := SRCINVERT;
   Display.Canvas.CopyRect(Rect(0, Display.ClientHeight div 2 * 1, Display.ClientWidth, Display.ClientHeight div 2 * 2),
    FDynamicCollision[not FCurrentDC].Canvas, Rect(FCamera_X, FCamera_Y, FCamera_X + FBackBuffer.Width, FBackBuffer.Height));
end;

procedure TScreenForm.DrawRect(ATarget, ASource: TCanvas; AX, AY: Integer;
  ASRect: TRect);
var
  LBlend: BLENDFUNCTION;
begin
  LBlend.BlendOp := AC_SRC_OVER;
  LBlend.BlendFlags := 0;
  LBlend.SourceConstantAlpha := 255;
  LBlend.AlphaFormat := AC_SRC_ALPHA;
  Winapi.Windows.AlphaBlend(ATarget.Handle, AX, AY, ASRect.Width, ASRect.Height,
    ASource.Handle, ASRect.Left, ASRect.Top, ASRect.Width, ASRect.Height, LBlend)
end;

procedure TScreenForm.LoadSprite(AIndex: Integer; const AStand, AWalk,
  AJump: string);
var
  LTemp: TPngImage;
begin
  LTemp := TPngImage.Create();
  try

    LTemp.LoadFromFile(AStand);
    FSprites[AIndex][0] := TBitmap.Create();
    FSprites[AIndex][0].Assign(LTemp);
    FFlippedSprites[AIndex][0] := TBitmap.Create();
    FFlippedSprites[AIndex][0].SetSize(LTemp.Width, LTemp.Height);
    FFlippedSprites[AIndex][0].PixelFormat := pf32bit;
    FFlippedSprites[AIndex][0].Canvas.CopyRect(Rect(FSprites[AIndex][0].Width, 0, -1, FSprites[AIndex][0].Height), FSprites[AIndex][0].Canvas, FSprites[AIndex][0].Canvas.ClipRect);

    LTemp.LoadFromFile(AWalk);
    FSprites[AIndex][1] := TBitmap.Create();
    FSprites[AIndex][1].Assign(LTemp);
    FFlippedSprites[AIndex][1] := TBitmap.Create();
    FFlippedSprites[AIndex][1].SetSize(LTemp.Width, LTemp.Height);
    FFlippedSprites[AIndex][1].PixelFormat := pf32bit;
    FFlippedSprites[AIndex][1].Canvas.CopyRect(Rect(FSprites[AIndex][1].Width, 0, -1, FSprites[AIndex][1].Height), FSprites[AIndex][1].Canvas, FSprites[AIndex][1].Canvas.ClipRect);

    LTemp.LoadFromFile(AJump);
    FSprites[AIndex][2] := TBitmap.Create();
    FSprites[AIndex][2].Assign(LTemp);
    FFlippedSprites[AIndex][2] := TBitmap.Create();
    FFlippedSprites[AIndex][2].SetSize(LTemp.Width, LTemp.Height);
    FFlippedSprites[AIndex][2].PixelFormat := pf32bit;
    FFlippedSprites[AIndex][2].Canvas.CopyRect(Rect(FSprites[AIndex][2].Width, 0, -1, FSprites[AIndex][2].Height), FSprites[AIndex][2].Canvas, FSprites[AIndex][2].Canvas.ClipRect);

  finally
    LTemp.Free;
  end;
end;

procedure TScreenForm.LoadSprites;
begin
  LoadSprite(0, '..\..\Mario_Stand.png', '..\..\Mario_Walk.png', '..\..\Mario_Jump.png');
  LoadSprite(1, '..\..\Mario_Dead.png', '..\..\Mario_Dead.png', '..\..\Mario_Dead.png');
  LoadSprite(2, '..\..\Brick.png', '..\..\Brick.png', '..\..\Brick.png');
  LoadSprite(3, '..\..\Gumba_Walk.png', '..\..\Gumba_Walk.png', '..\..\Gumba_Walk.png');
  LoadSprite(4, '..\..\Gumba_Dead.png', '..\..\Gumba_Dead.png', '..\..\Gumba_Dead.png');
end;

const
  CCameraDeadZone = 80;
  CActivityBorder = 40;
  CStand = 0;
  CWalk = 1;
  CJump = 2;
  CGravity = 0.3;
  CEdgeIdent = 2;
  CDeadZoneMin = 240;
  CDeadZoneMax = 260;

procedure TScreenForm.RenderTimerTimer(Sender: TObject);
var
  i: Integer;
  LDummy: Boolean;
  LTopEdgeLeft, LTopEdgeRight, LLeftEdgeTop, LLeftEdgeBottom, LRightEdgeTop, LRightEdgeBottom, LBottomEdgeLeft, LBottomEdgeRight: Integer;
  LX, LY: Integer;
  LRect: TRect;
  LSprite: TBitmap;
  LSpriteState, LSpriteFrame: Integer;
  LDynLeft, LDynRight, LDynTop, LDynDown, LTargetEnt, LNextEntity: Integer;
  LBBLeft, LBBRight, LBBTop, LBBBottom: Integer;
begin
  //reset dynamic collisionmask
  FDynamicCollision[not FCurrentDC].Canvas.Brush.Color := CNoDynCollision;
  FDynamicCollision[not FCurrentDC].Canvas.Pen.Color := CNoDynCollision;
  FDynamicCollision[not FCurrentDC].Canvas.FillRect(FDynamicCollision[not FCurrentDC].Canvas.ClipRect);
  //Draw Level
  FBackBuffer.Canvas.Draw(-FCamera_X,0, FLevel);
  for i := Low(GEntity) to High(GEntity) do
  begin
      //execute only if active and near to the camera
    if (GEntity[i].Active <> 0) and ((GEntity[i].X - FCamera_X) >= -CActivityBorder) and ((GEntity[i].X - FCamera_X) < FScreenWidth + CActivityBorder) and Boolean(Trunc(
        //reset some values
        TInterlocked.Exchange(LTargetEnt, CNoDynCollision)
        //get input
        + Integer(GEntity[i].Input and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Vel_X, 2*((GetAsyncKeyState(VK_RIGHT) shr 31 and 1) - (GetAsyncKeyState(VK_LEFT) shr 31 and 1))))))
        + Integer(GEntity[i].Input and (GEntity[i].DownBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Vel_Y, 7 * (GetAsyncKeyState(VK_SPACE) shr 31 and 1)))))
        //apply velocity
        + Integer( (((GEntity[i].LeftBlocked = 0) and (GEntity[i].Vel_X < 0)) or ((GEntity[i].RightBlocked = 0) and (GEntity[i].Vel_X > 0))) and (TInterlocked.Exchange(GEntity[i].X, GEntity[i].X + GEntity[i].Vel_X) * 0 = 0))
        //apply gravity
        + TInterlocked.Exchange(GEntity[i].Vel_Y, Max(-5, GEntity[i].Vel_Y - CGravity * GEntity[i].Gravity))
        + Integer((((GEntity[i].DownBlocked = 0) and (GEntity[i].Vel_Y < 0)) or ((GENtity[i].UpBlocked = 0) and (GEntity[i].Vel_Y > 0))) and
          Boolean(Trunc(
            TInterlocked.Exchange(GEntity[i].Y, GEntity[i].Y - GEntity[i].Vel_Y)
          + TInterlocked.Exchange(GEntity[i].InAirTimer, GEntity[i].InAirTimer + 1)
          ))
        )

        //////Collisiooncode...loooong!
          //Trunc current position to pixels
          + TInterlocked.Exchange(LX, Trunc(GEntity[i].X))
          + TInterlocked.Exchange(LY, Trunc(GEntity[i].Y))
          + TInterlocked.Exchange(LBBLeft, LX - GEntity[i].bbWidth div 2)
          + TInterlocked.Exchange(LBBRight, LX + GEntity[i].bbWidth div 2 - 1)
          + TInterlocked.Exchange(LBBTop, LY - GEntity[i].bbHeight div 2)
          + TInterlocked.Exchange(LBBBottom, LY + GEntity[i].bbHeight div 2 - 1)
          //do checks only if we are alive and do not ignore it!
          + Integer(not (bfIgnoreCollision in GEntity[i].BehaviorFlags) and (GEntity[i].Live > 0)
            and Boolean(Trunc(
              //collision checks
              //static collision
              //get collision values of edges of BoundingBox
              //TopEdge
              + TInterlocked.Exchange(LTopEdgeLeft, FStaticCollision.Canvas.Pixels[LBBLeft + CEdgeIdent, LBBTop])
              + TInterlocked.Exchange(LTopEdgeRight, FStaticCollision.Canvas.Pixels[LBBRight - CEdgeIdent, LBBTop])
              //LeftEdge
              + TInterlocked.Exchange(LLeftEdgeTop, FStaticCollision.Canvas.Pixels[LBBLeft, LBBTop + CEdgeIdent])
              + TInterlocked.Exchange(LLeftEdgeBottom, FStaticCollision.Canvas.Pixels[LBBLeft, LBBBottom - CEdgeIdent])
              //RightEdge
              + TInterlocked.Exchange(LRightEdgeTop, FStaticCollision.Canvas.Pixels[LBBRight, LBBTop + CEdgeIdent])
              + TInterlocked.Exchange(LRightEdgeBottom, FStaticCollision.Canvas.Pixels[LBBRight, LBBBottom - CEdgeIdent])
              //BottomEdge
              + TInterlocked.Exchange(LBottomEdgeLeft, FStaticCollision.Canvas.Pixels[LBBLeft + CEdgeIdent, LBBBottom])
              + TInterlocked.Exchange(LBottomEdgeRight, FStaticCollision.Canvas.Pixels[LBBRight - CEdgeIdent, LBBBottom])
              //combine 2 corners each edge to determine if walking into the given direction is possible
              + TInterlocked.Exchange(GEntity[i].LeftBlocked,  LLeftEdgeTop + LLeftEdgeBottom)
              + TInterlocked.Exchange(GEntity[i].RightBlocked,  LRightEdgeTop + LRightEdgeBottom)
              + TInterlocked.Exchange(GEntity[i].UpBlocked,  LTopEdgeLeft + LTopEdgeRight)
              + TInterlocked.Exchange(GEntity[i].DownBlocked,  LBottomEdgeLeft + LBottomEdgeRight)
            //Dynamic Collision
              //get collision values of edges of BoundingBox
              //TopEdge
              + TInterlocked.Exchange(LTopEdgeLeft, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBLeft + CEdgeIdent, LBBTop])
              + TInterlocked.Exchange(LTopEdgeRight, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBRight - CEdgeIdent, LBBTop])
              //LeftEdge
              + TInterlocked.Exchange(LLeftEdgeTop, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBLeft, LBBTop + CEdgeIdent])
              + TInterlocked.Exchange(LLeftEdgeBottom, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBLeft, LBBBottom - CEdgeIdent])
              //RightEdge
              + TInterlocked.Exchange(LRightEdgeTop, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBRight, LBBTop + CEdgeIdent])
              + TInterlocked.Exchange(LRightEdgeBottom, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBRight, LBBBottom - CEdgeIdent])
              //BottomEdge
              + TInterlocked.Exchange(LBottomEdgeLeft, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBLeft + CEdgeIdent, LBBBottom])
              + TInterlocked.Exchange(LBottomEdgeRight, FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBRight - CEdgeIdent, LBBBottom])
              //combine 2 corners each edge to determine if walking into the given direction is possible
              + TInterlocked.Exchange(LDynLeft, IfThen((LLeftEdgeTop <> CNoDynCollision) and (LLeftEdgeTop <> i), LLeftEdgeTop, LLeftEdgeBottom))
              + TInterlocked.Exchange(LDynRight, IfThen((LRightEdgeTop <> CNoDynCollision) and (LRightEdgeTop <> i), LRightEdgeTop, LRightEdgeBottom))
              + TInterlocked.Exchange(LDynTop,  IfThen((LTopEdgeLeft <> CNoDynCollision) and (LTopEdgeLeft <> i), LTopEdgeLeft, LTopEdgeRight))
              + TInterlocked.Exchange(LDynDown, IfThen((LBottomEdgeLeft <> CNoDynCollision) and (LBottomEdgeLeft <> i), LBottomEdgeLeft, LBottomEdgeRight))
  //            //if collided and not collided with self, add to entity collision state
              + TInterlocked.Exchange(GEntity[i].LeftBlocked, GEntity[i].LeftBlocked + IfThen((LDynLeft <> CNoDynCollision) and (LDynLeft <> i), LDynLeft, 0))
              + TInterlocked.Exchange(GEntity[i].RightBlocked, GEntity[i].RightBlocked + IfThen((LDynRight <> CNoDynCollision) and (LDynRight <> i), LDynRight, 0))
              + TInterlocked.Exchange(GEntity[i].UpBlocked, GEntity[i].UpBlocked + IfThen((LDynTop <> CNoDynCollision) and (LDynTop <> i), LDynTop, 0))
              + TInterlocked.Exchange(GEntity[i].DownBlocked, GEntity[i].DownBlocked + IfThen((LDynDown <> CNoDynCollision) and (LDynDown <> i), LDynDown, 0))
  //            //determine entity we collided with if exists
              + TInterlocked.Exchange(LTargetEnt, IfThen((LDynRight <> i) and (LDynRight <> CNoDynCollision), LDynRight, CNoDynCollision))
              + TInterlocked.Exchange(LTargetEnt, IfThen((LDynLeft <> i) and (LDynLeft <> CNoDynCollision), LDynLeft, LTargetEnt))
              + TInterlocked.Exchange(LTargetEnt, IfThen((LDynDown <> i) and (LDynDown <> CNoDynCollision), LDynDown, LTargetEnt))
              + TInterlocked.Exchange(LTargetEnt, IfThen((LDynTop <> i) and (LDynTop <> CNoDynCollision), LDynTop, LTargetEnt))
            )))
        //end of collisioncode!!!
        //positional correction in case we are inside an obstacle
        //do not correct Horizontal position if fallspeed was higher then walkspeed and we collided with floor to avoid being pushed of blocks we jumped on
        //wen just a few pixels on the blocks
        + Integer(((Abs(GEntity[i].Vel_X) >= Abs(GEntity[i].Vel_Y)) or (GEntity[i].DownBlocked = 0)) and Boolean(
            Integer( (GEntity[i].LeftBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].X, GEntity[i].X + 1))))
          + Integer( (GEntity[i].RightBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].X, GEntity[i].X - 1))))
          ))
        + Integer( (GEntity[i].UpBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Y, GEntity[i].Y + 1))))
        + Integer( (GEntity[i].DownBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Y, LY - 1))))
        //reset gravity velocity when colliding to reset falling momentum
        + Integer( (((GEntity[i].UpBlocked <> 0) and (GEntity[i].Vel_Y > 0)) or ((GEntity[i].DownBlocked <> 0) and (GEntity[i].Vel_Y < 0)))
            and Boolean(Trunc(
              TInterlocked.Exchange(GEntity[i].Vel_Y, 0))
            + TInterlocked.Exchange(GEntity[i].InAirTimer, 0)
            )
          )
        //if we collided with another entity, which is alive, attack and take damage!
        + Integer((LTargetEnt <> CNoDynCollision) and (GEntity[LTargetEnt].Active <> 0) and Boolean(Trunc(
          + Integer((LTargetEnt = LDynTop) and (GEntity[LTargetEnt].Live > 0) and Boolean(Trunc(
              TInterlocked.Add(GEntity[LTargetEnt].Live, -GEntity[i].DamageTop)
            + TInterlocked.Add(GEntity[i].Live, -GEntity[LTargetEnt].DamageBottom)
          )))

          + Integer((LTargetEnt = LDynDown) and (GEntity[LTargetEnt].Live > 0) and Boolean(Trunc(
              TInterlocked.Add(GEntity[LTargetEnt].Live, -GEntity[i].DamageBottom)
            + TInterlocked.Add(GEntity[i].Live, -GEntity[LTargetEnt].DamageTop)
          )))

          + Integer((LTargetEnt = LDynLeft) and (GEntity[LTargetEnt].Live > 0) and Boolean(Trunc(
              TInterlocked.Add(GEntity[LTargetEnt].Live, -GEntity[i].DamageLeft)
            + TInterlocked.Add(GEntity[i].Live, -GEntity[LTargetEnt].DamageRight)
          )))

          + Integer((LTargetEnt = LDynRight) and (GEntity[LTargetEnt].Live > 0) and Boolean(Trunc(
              TInterlocked.Add(GEntity[LTargetEnt].Live, -GEntity[i].DamageRight)
            + TInterlocked.Add(GEntity[i].Live, -GEntity[LTargetEnt].DamageLeft)
          )))
        )))
        //check DeadZone
        + Integer((GEntity[i].Y > CDeadZoneMin) and (GEntity[i].Y < CDeadZoneMax) and Boolean(
          + TInterlocked.Exchange(GEntity[i].Live, 0)
        ))

        //check if we died and take actions if this is true
        + Integer((GEntity[i].Live < 1) and Boolean(Trunc(
          //deactivate us so we are removed next frame
          + TInterlocked.Exchange(GEntity[i].Active, 0)
          //replace with entity if specified
          + Integer((GEntity[i].ReplaceOnDead > 0) and Boolean(Trunc(
            + TInterlocked.Exchange(LNextEntity, i + GEntity[i].ReplaceOnDead)
            + TInterlocked.Exchange(GEntity[LNextEntity].Active, 1)
            + Integer((sfCopyPosition in GEntity[LNextEntity].SpawnFlags) and Boolean(Trunc(
              + TInterlocked.Exchange(GEntity[LNextEntity].X, GEntity[i].X)
              + TInterlocked.Exchange(GEntity[LNextEntity].Y, GEntity[i].Y)
            )))
          )))
        )))
        //LiveTimeCheck
        + Integer((GEntity[i].Active <> 0) and Boolean(Trunc(
            TInterlocked.Add(GEntity[i].LiveTime, -1)
          + Integer((GEntity[i].LiveTime = 0) and Boolean(Trunc(
              TInterlocked.Exchange(GEntity[i].Active, 0)
          )))
        )))
        //camera movement
         + Integer(GEntity[i].Input and (GEntity[i].X - FCamera_X > FScreenWidth-CCameraDeadZone) and Boolean(TInterlocked.Exchange(FCamera_X, Min(FLevel.Width - FScreenWidth, Trunc(FCamera_X + (GEntity[i].X - FCamera_X - FScreenWidth + CCameraDeadZone))))))
         + Integer(GEntity[i].Input and (GEntity[i].X - FCamera_X < CCameraDeadZone) and Boolean(TInterlocked.Exchange(FCamera_X, Max(0, Trunc(FCamera_X + (GEntity[i].X - FCamera_X - CCameraDeadZone))))))
        //check our current state(standing, walking, Jumping/InAir)
         + TInterlocked.Exchange(LSpriteState, CStand)
         + Integer((GEntity[i].Vel_X <> 0) and Boolean(Trunc(TInterlocked.Exchange(LSpriteState, CWalk))))
         + Integer(((GEntity[i].DownBlocked = 0) and (GEntity[i].InAirTimer > 1)) and Boolean(Trunc(TInterlocked.Exchange(LSpriteState, CJump))))
        //check if we need to use a flipped version of our image or the normal one
        + Integer(((GEntity[i].Vel_X < 0) and
            Boolean(Trunc(
              Integer(TInterlocked.Exchange<TBitmap>(LSprite, FFlippedSprites[GEntity[i].Sprite][LSpriteState])) * 0 + 1
            ))) or
            Boolean(Trunc(
              Integer(TInterlocked.Exchange<TBitmap>(LSprite, FSprites[GEntity[i].Sprite][LSpriteState]))
            ))
          )
        //Calculate current Frame of sprite to display
        + TInterlocked.Exchange(LSpriteFrame, FFrameCounter div (50 div 16) mod (LSprite.Width div CSpriteWidth))
        //Translate EntityPosition
        + TInterlocked.Exchange(LX, Trunc(GEntity[i].X - CSpriteWidth div 2 - FCamera_X))
        + TInterlocked.Exchange(LY, Trunc(GEntity[i].Y - CSpriteWidth div 2 - FCamera_Y))
        //recalculate the BB area
        + TInterlocked.Exchange(LBBLeft, Trunc(GEntity[i].X) - GEntity[i].bbWidth div 2)
        + TInterlocked.Exchange(LBBRight, Trunc(GEntity[i].X) + GEntity[i].bbWidth div 2)
        + TInterlocked.Exchange(LBBTop, Trunc(GEntity[i].Y) - GEntity[i].bbHeight div 2 )
        + TInterlocked.Exchange(LBBBottom, Trunc(GEntity[i].Y) + GEntity[i].bbHeight div 2)
      )*0-1)
    then
    begin
    //Draw Entity
      FDynamicCollision[not FCurrentDC].Canvas.Brush.Color := TColor(i);
      FDynamicCollision[not FCurrentDC].Canvas.Pen.Color := TColor(i);
      FDynamicCollision[not FCurrentDC].Canvas.Rectangle(LBBLeft, LBBTop, LBBRight, LBBBottom);
//      //debugstuff
//          FDynamicCollision[not FCurrentDC].Canvas.Pixels[LBBLeft + CEdgeIdent, LBBTop] := clFuchsia;
//          FDynamicCollision[FCurrentDC].Canvas.Pixels[LBBRight - CEdgeIdent - 1, LBBTop] := clFuchsia;
//            //LeftEdge
//           FDynamicCollision[not FCurrentDC].Canvas.Pixels[LBBLeft, LBBTop + CEdgeIdent]:= clFuchsia;
//           FDynamicCollision[not FCurrentDC].Canvas.Pixels[LBBLeft, LBBBottom - 1 - CEdgeIdent]:= clFuchsia;
//            //RightEdge
//          FDynamicCollision[not FCurrentDC].Canvas.Pixels[LBBRight - 1, LBBTop + CEdgeIdent]:= clFuchsia;
//          FDynamicCollision[not FCurrentDC].Canvas.Pixels[LBBRight - 1, LBBBottom - CEdgeIdent - 1]:= clFuchsia;
//            //BottomEdge
//          FDynamicCollision[not FCurrentDC].Canvas.Pixels[LBBLeft + CEdgeIdent, LBBBottom - 1]:= clFuchsia;
//          FDynamicCollision[not FCurrentDC].Canvas.Pixels[LBBRight - 1 - CEdgeIdent, LBBBottom - 1]:= clFuchsia;
//      //debugstuff
      DrawRect(FBackBUffer.Canvas, LSPrite.Canvas, LX, LY,
        Rect(LSpriteFrame*CSpriteWidth, 0, LSpriteFrame*CSpriteWidth + CSpriteWidth, LSprite.Height));
    end;
  end;
  Display.Repaint();
  FCurrentDC := not FCurrentDC;
  Inc(FFrameCounter);
end;

end.
