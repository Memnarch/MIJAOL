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

procedure TScreenForm.RenderTimerTimer(Sender: TObject);
var
  i: Integer;
  LDummy: Single;
  LLeftBlocked, LRightBlocked, LUpBlocked, LDownBlocked: Integer;
  LTopEdgeLeft, LTopEdgeRight, LLeftEdgeTop, LLeftEdgeBottom, LRightEdgeTop, LRightEdgeBottom, LBottomEdgeLeft, LBottomEdgeRight: Integer;
  LX, LY: Integer;
begin
  FBackBuffer.Canvas.Draw(0,0, FLevel);
  for i := Low(GEntity) to High(GEntity) do
  begin
    LDummy :=
      //round current position to pixels
        TInterlocked.Exchange(LX, Round(GEntity[i].X)) * 0
      + TInterlocked.Exchange(LY, Round(GEntity[i].Y)) * 0
      //collision checks
      //static collision
      //get collision values of edges of BoundingBox(Extended by 1 Pixel)
      //TopEdge
      + TInterlocked.Exchange(LTopEdgeLeft, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth, LY - CHalfSpriteHeight - 1])  * 0
      + TInterlocked.Exchange(LTopEdgeRight, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth, LY - CHalfSpriteHeight - 1])  * 0
      //LeftEdge
      + TInterlocked.Exchange(LLeftEdgeTop, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth - 1, LY - CHalfSpriteHeight])  * 0
      + TInterlocked.Exchange(LLeftEdgeBottom, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth - 1, LY + CHalfSpriteHeight - 1])  * 0
      //RightEdge
      + TInterlocked.Exchange(LRightEdgeTop, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth + 1, LY - CHalfSpriteHeight])  * 0
      + TInterlocked.Exchange(LRightEdgeBottom, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth + 1, LY + CHalfSpriteHeight - 1])  * 0
      //BottomEdge
      + TInterlocked.Exchange(LBottomEdgeLeft, FStaticCollision.Canvas.Pixels[LX - CHalfSpriteWidth, LY + CHalfSpriteHeight + 1])  * 0
      + TInterlocked.Exchange(LBottomEdgeRight, FStaticCollision.Canvas.Pixels[LX + CHalfSpriteWidth, LY + CHalfSpriteHeight + 1])  * 0
      //combine 2 corners each edge to determine if walking into the given direction is possible
      + TInterlocked.Exchange(LLeftBlocked,  LLeftEdgeTop + LLeftEdgeBottom) * 0
      + TInterlocked.Exchange(LRightBlocked,  LRightEdgeTop + LRightEdgeBottom) * 0
      + TInterlocked.Exchange(LUpBlocked,  LTopEdgeLeft + LTopEdgeRight) * 0
      + TInterlocked.Exchange(LDownBlocked,  LBottomEdgeLeft + LBottomEdgeRight) * 0
      //get input
      + TInterlocked.Exchange(GEntity[i].Vel_X, (GetAsyncKeyState(VK_RIGHT) shr 31 and 1) - (GetAsyncKeyState(VK_LEFT) shr 31 and 1)) * 0
//      + TInterlocked.Exchange(GEntity[i].Vel_Y, -10 * (GetAsyncKeyState(VK_SPACE) shr 31 and 1)) * 0
      + Integer((LDownBlocked <> 0) and Boolean(Round(TInterlocked.Exchange(GEntity[i].Vel_Y, 8 * (GetAsyncKeyState(VK_SPACE) shr 31 and 1))))) * 0
      //apply velocity
      + Integer( (((LLeftBlocked = 0) and (GEntity[i].Vel_X < 0)) or ((LRightBlocked = 0) and (GEntity[i].Vel_X > 0))) and (TInterlocked.Exchange(GEntity[i].X, GEntity[i].X + GEntity[i].Vel_X) * 0 = 0))
      //apply gravity
      + TInterlocked.Exchange(GEntity[i].Vel_Y, Max(-6, GEntity[i].Vel_Y - 0.3)) * 0
      + Integer( (((LDownBlocked = 0) and (GEntity[i].Vel_Y < 0)) or ((LUpBlocked = 0) and (GEntity[i].Vel_Y > 0))) and Boolean(Round(TInterlocked.Exchange(GEntity[i].Y, GEntity[i].Y - GEntity[i].Vel_Y)))) * 0;
    //Draw Entity
    FBackBuffer.Canvas.Draw(Round(GEntity[i].X - CSpriteWidth div 2), Round(GEntity[i].Y - CSpriteWidth div 2), FSprites[GEntity[i].Sprite][0], 255);
  end;
  Display.Repaint();
end;

end.
