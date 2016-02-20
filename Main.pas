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
    FSprites: array[0..0] of array[0..2] of TBitmap;
    FCamera_X: Integer;
    FCamera_Y: Integer;
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    procedure LoadSprites;
    procedure LoadSprite(AIndex: Integer; const AStand, AWalk, AJump: string);
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

procedure TScreenForm.LoadSprite(AIndex: Integer; const AStand, AWalk,
  AJump: string);
var
  LTemp: TPngImage;
begin
  LTemp := TPngImage.Create();
  try
    FSprites[AIndex][0] := TBitmap.Create();
    LTemp.LoadFromFile(AStand);
    FSprites[AIndex][0].Assign(LTemp);

    FSprites[AIndex][1] := TBitmap.Create();
    LTemp.LoadFromFile(AWalk);
    FSprites[AIndex][1].Assign(LTemp);

    FSprites[AIndex][2] := TBitmap.Create();
    LTemp.LoadFromFile(AJump);
    FSprites[AIndex][2].Assign(LTemp);
  finally
    LTemp.Free;
  end;
end;

procedure TScreenForm.LoadSprites;
begin
  LoadSprite(0, '..\..\Mario_Stand.png', '..\..\Mario_Stand.png', '..\..\Mario_Stand.png');
end;

const
  CCameraDeadZone = 80;

procedure TScreenForm.RenderTimerTimer(Sender: TObject);
var
  i: Integer;
  LDummy: Single;
  LTopEdgeLeft, LTopEdgeRight, LLeftEdgeTop, LLeftEdgeBottom, LRightEdgeTop, LRightEdgeBottom, LBottomEdgeLeft, LBottomEdgeRight: Integer;
  LX, LY: Integer;
begin
  for i := Low(GEntity) to High(GEntity) do
  begin
    LDummy :=
      //get input
      + TInterlocked.Exchange(GEntity[i].Vel_X, 2*((GetAsyncKeyState(VK_RIGHT) shr 31 and 1) - (GetAsyncKeyState(VK_LEFT) shr 31 and 1))) * 0
      + Integer((GENtity[i].DownBlocked <> 0) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Vel_Y, 7 * (GetAsyncKeyState(VK_SPACE) shr 31 and 1))))) * 0
      //apply velocity
      + Integer( (((GENtity[0].LeftBlocked = 0) and (GEntity[i].Vel_X < 0)) or ((GEntity[i].RightBlocked = 0) and (GEntity[i].Vel_X > 0))) and (TInterlocked.Exchange(GEntity[i].X, GEntity[i].X + GEntity[i].Vel_X) * 0 = 0))
      //apply gravity
      + TInterlocked.Exchange(GEntity[i].Vel_Y, Max(-5, GEntity[i].Vel_Y - 0.3)) * 0
      + Integer( (((GEntity[i].DownBlocked = 0) and (GEntity[i].Vel_Y < 0)) or ((GENtity[i].UpBlocked = 0) and (GEntity[i].Vel_Y > 0))) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Y, GEntity[i].Y - GEntity[i].Vel_Y)))) * 0

      //////Collisiooncode...loooong!
        //Trunc current position to pixels
        + TInterlocked.Exchange(LX, Trunc(GEntity[i].X)) * 0
        + TInterlocked.Exchange(LY, Trunc(GEntity[i].Y)) * 0
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
      + Integer( (((GEntity[i].UpBlocked <> 0) and (GEntity[i].Vel_Y > 0)) or ((GEntity[i].DownBlocked <> 0) and (GEntity[i].Vel_Y < 0))) and Boolean(Trunc(TInterlocked.Exchange(GEntity[i].Vel_Y, 0))))
      //camera movement
       + Integer((GEntity[i].X - FCamera_X > FScreenWidth-CCameraDeadZone) and Boolean(TInterlocked.Exchange(FCamera_X, Min(FLevel.Width - FScreenWidth, Trunc(FCamera_X + (GEntity[i].X - FCamera_X - FScreenWidth + CCameraDeadZone))))))
       + Integer((GEntity[i].X - FCamera_X < CCameraDeadZone) and Boolean(TInterlocked.Exchange(FCamera_X, Max(0, Trunc(FCamera_X + (GEntity[i].X - FCamera_X - CCameraDeadZone))))));
        ;

    //Draw Level
    FBackBuffer.Canvas.Draw(-FCamera_X,0, FLevel);
    //Draw Entity
    FBackBuffer.Canvas.Draw(Trunc(GEntity[i].X - CSpriteWidth div 2 - FCamera_X), Trunc(GEntity[i].Y - CSpriteWidth div 2), FSprites[GEntity[i].Sprite][0], 255);
  end;
  Display.Repaint();
end;

end.
