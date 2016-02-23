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
    //first dimension is for different characters
    //second dimension represents the states:
    //0 = stand, 1 = walk, 2 =  jump/InAir
    FSprites: array[0..1] of array[0..2] of TBitmap;
    FFlippedSprites: array[0..1] of array[0..2] of TBitmap;
    FCamera_X: Integer;
    FCamera_Y: Integer;
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    FFrameCounter: Integer;
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
  LoadSprites();
  FScreenWidth := FBackBuffer.Width;
  FScreenHeight := FBackBuffer.Height;
end;

procedure TScreenForm.DisplayPaint(Sender: TObject);
begin
  Display.Canvas.StretchDraw(Display.ClientRect, FBackBuffer);
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
  LoadSprite(1, '..\..\Brick.png', '..\..\Brick.png', '..\..\Brick.png');
end;

const
  CCameraDeadZone = 80;
  CStand = 0;
  CWalk = 1;
  CJump = 2;
  CGravity = 0.3;

procedure TScreenForm.RenderTimerTimer(Sender: TObject);
var
  i: Integer;
  LDummy: Boolean;
  LTopEdgeLeft, LTopEdgeRight, LLeftEdgeTop, LLeftEdgeBottom, LRightEdgeTop, LRightEdgeBottom, LBottomEdgeLeft, LBottomEdgeRight: Integer;
  LX, LY: Integer;
  LRect: TRect;
  LSprite: TBitmap;
  LSpriteState, LSpriteFrame: Integer;
begin
  //Draw Level
  FBackBuffer.Canvas.Draw(-FCamera_X,0, FLevel);
  for i := Low(GEntity) to High(GEntity) do
  begin
      //execute only if active
    if GEntity[i].Active and Boolean(Trunc(
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
          //collision checks
          //static collision
          //get collision values of edges of BoundingBox(Extended by 1 Pixel)
          //TopEdge
          + TInterlocked.Exchange(LTopEdgeLeft, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth + 3, LY - CHalfSpriteHeight - 1])  * 0
          + TInterlocked.Exchange(LTopEdgeRight, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth - 3, LY - CHalfSpriteHeight - 1])  * 0
          //LeftEdge
          + TInterlocked.Exchange(LLeftEdgeTop, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth + 2, LY - CHalfSpriteHeight + 1])  * 0
          + TInterlocked.Exchange(LLeftEdgeBottom, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth + 2, LY + CHalfSpriteHeight - 2])  * 0
          //RightEdge
          + TInterlocked.Exchange(LRightEdgeTop, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth - 3, LY - CHalfSpriteHeight + 1])  * 0
          + TInterlocked.Exchange(LRightEdgeBottom, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth - 3, LY + CHalfSpriteHeight - 2])  * 0
          //BottomEdge
          + TInterlocked.Exchange(LBottomEdgeLeft, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth + 3, LY + CHalfSpriteHeight - 1])  * 0
          + TInterlocked.Exchange(LBottomEdgeRight, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth - 4, LY + CHalfSpriteHeight - 1])  * 0
          //combine 2 corners each edge to determine if walking into the given direction is possible
          + TInterlocked.Exchange(GEntity[i].LeftBlocked,  LLeftEdgeTop + LLeftEdgeBottom) * 0
          + TInterlocked.Exchange(GEntity[i].RightBlocked,  LRightEdgeTop + LRightEdgeBottom) * 0
          + TInterlocked.Exchange(GEntity[i].UpBlocked,  LTopEdgeLeft + LTopEdgeRight) * 0
          + TInterlocked.Exchange(GEntity[i].DownBlocked,  LBottomEdgeLeft + LBottomEdgeRight) * 0
        //end of collisioncode!!!

        //positional correction in case we are inside an obstacle
        + Integer( (GEntity[i].LeftBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].X, GEntity[i].X + 1)))) * 0
        + Integer( (GEntity[i].RightBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].X, GEntity[i].X - 1)))) * 0
        + Integer( (GEntity[i].UpBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Y, GEntity[i].Y + 1)))) * 0
        + Integer( (GEntity[i].DownBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Y, LY - 1)))) * 0
        //reset velocity when colliding do avoid reentering/overlapping the obstacle
        + Integer( (((GEntity[i].LeftBlocked <> 0) and (GEntity[i].Vel_X < 0)) or ((GEntity[i].RightBlocked <> 0) and (GEntity[i].Vel_X > 0))) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Vel_X, 0))))
        + Integer( (((GEntity[i].UpBlocked <> 0) and (GEntity[i].Vel_Y > 0)) or ((GEntity[i].DownBlocked <> 0) and (GEntity[i].Vel_Y < 0)))
            and Boolean(Trunc(
              TInterlocked.Exchange(GEntity[i].Vel_Y, 0))
            + TInterlocked.Exchange(GEntity[i].InAirTimer, 0)
            )
          )
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
      )*0-1)
    then
    //Draw Entity
      DrawRect(FBackBUffer.Canvas, LSPrite.Canvas, Trunc(GEntity[i].X - CSpriteWidth div 2 - FCamera_X), Trunc(GEntity[i].Y - CSpriteWidth div 2 - FCamera_Y),
        Rect(LSpriteFrame*CSpriteWidth, 0, LSpriteFrame*CSpriteWidth + CSpriteWidth, LSPrite.Height));
  end;
  Display.Repaint();
  Inc(FFrameCounter);
end;

end.
