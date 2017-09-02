unit DataView;

interface

uses
  Windows, Classes, SysUtils, GDIPOBJ, GDIPAPI;

type
  TMyDataView = class
  private
  public
    constructor Create();
    destructor Destroy(); override;
    function Draw2DCoordinates(drawRect: TRect; displayCanvasHandle: THandle; rowContent, columnContent: string): Integer;                                                                           //二维坐标系
    function DrawDataCircleView(totalNumber: Double; sonNumberArray: array of Double; displayCanvasHandle: THandle; drawRetc: TRect; fillColorArray: array of Cardinal): Integer;    //饼图
    function DrawDataHistogramView(totalNumber: Double; sonNumberArray: array of Double; displayCanvasHandle: THandle; fillColorArray: array of Cardinal): Integer;    //直方图
    function DisplayDataPercentage(totalNumber: Double; sonNumberArray: array of Double; DataNameArray: array of string; drawRetc: TRect; displayCanvasHandle: THandle; fillColorArray: array of Cardinal): Integer;     //百分比
  end;

implementation

{ TMyDataView }

constructor TMyDataView.Create;
begin

end;

destructor TMyDataView.Destroy;
begin

  inherited;
end;

function TMyDataView.DisplayDataPercentage(totalNumber: Double; sonNumberArray: array of Double; DataNameArray: array of string; drawRetc: TRect; displayCanvasHandle: THandle; fillColorArray: array of Cardinal): Integer;
var
  g: TGPGraphics;
  p: TGPPen;
  b: TGPBrush;
  sb: TGPSolidBrush;
  font: TGPFont;
  tempd: Double;
  temps: string;
  i, len: Integer;
  distance: Double;
  ProgressbarRect: TGPRectF;
begin
  g := TGPGraphics.Create(displayCanvasHandle);
  p := TGPPen.Create(MakeColor(0, 255, 0), 2);
  distance := 0;
  len := Length(DataNameArray);
  b := TGPSolidBrush.Create(aclBlack);
  sb := TGPSolidBrush.Create(aclBlack);
  font := TGPFont.Create('Arial Black', 10);
  g.SetTextRenderingHint(TextRenderingHintAntiAlias);
  ProgressbarRect.y := drawRetc.Top;
  ProgressbarRect.X := drawRetc.Left;
  temps := ' 合计为' + FloatToStr(totalNumber);
  g.DrawString(temps, -1, font, MakePoint(ProgressbarRect.X - 15, ProgressbarRect.Y), sb);

  for i := 0 to len - 1 do
  begin
    sb.SetColor(fillColorArray[i]);
    p.SetColor(fillColorArray[i]);
    tempD := (sonNumberArray[i] / totalNumber) * 100;
    temps := DataNameArray[i] + '百分比为：' + FloatToStr(tempd) + '%';
    g.DrawString(temps, -1, font, MakePoint(ProgressbarRect.X - 10, ProgressbarRect.Y + 30), sb);
    ProgressbarRect.y := ProgressbarRect.y + 60;

    ProgressbarRect.Width := Round((drawRetc.Right - drawRetc.Left) * tempd / 100) * 2;
    ProgressbarRect.Height := 10;
    g.DrawRectangle(p, ProgressbarRect);
    g.FillRectangle(sb, ProgressbarRect);
    temps := ' 百分比为' + FloatToStr(sonNumberArray[i]);
    g.DrawString(temps, -1, font, MakePoint(ProgressbarRect.X + 200.0, ProgressbarRect.Y - 10), sb);
    distance := distance + 40;
  end;
  font.Free;
  b.Free;
  g.Free;
end;

function TMyDataView.Draw2DCoordinates(drawRect: TRect; displayCanvasHandle: THandle; rowContent, columnContent: string): Integer;
var
  g: TGPGraphics;
  p: TGPPen;
  font: TGPFont;
  sb: TGPSolidBrush;
  starX, starY, stopX, stopY: Single;
begin
  g := TGPGraphics.Create(displayCanvasHandle);
  p := TGPPen.Create(MakeColor(0, 0, 0), 2);
  font := TGPFont.Create('Arial Black', 12);
  sb := TGPSolidBrush.Create(aclBlack);
  p.SetDashStyle(DashStyleDashDot);
  g.DrawRectangle(p, drawRect.Left, drawRect.Top, drawRect.Right, drawRect.Bottom);
  p.SetDashStyle(DashStyleSolid);
  p.SetColor(MakeColor(0, 0, 255));
  starX := drawRect.Left;
  starY := drawRect.Bottom + drawRect.Top;
  stopX := drawRect.Right + drawRect.Left;
  stopY := drawRect.Bottom + drawRect.Top;
  g.DrawLine(p, starX, starY, stopX, stopY);
  g.SetTextRenderingHint(TextRenderingHintAntiAlias);
  g.DrawString(rowContent, -1, font, MakePoint(stopX-50, stopY + 5), sb);
  p.SetColor(MakeColor(0, 255, 0));                    // -
  starX := drawRect.Left;
  starY := drawRect.Bottom + drawRect.Top;
  stopX := drawRect.Left;
  stopY := drawRect.top;                                    //|
  g.DrawLine(p, starX, starY, stopX, stopY);
  g.DrawString(columnContent, -1, font, MakePoint(stopX-50, stopY + 5), sb);
end;

function TMyDataView.DrawDataCircleView(totalNumber: Double; sonNumberArray: array of Double; displayCanvasHandle: THandle; drawRetc: TRect; fillColorArray: array of Cardinal): Integer;
var
  g: TGPGraphics;
  p: TGPPen;
  sb: TGPSolidBrush;
  rectPie: TGPRectF;
  i, len: Integer;
  tempD: Double;
  starAngle, r: Double;
  font: TGPFont;
  shapeX, shapeY, shapeX1, shapeY1: Double;
begin
  g := TGPGraphics.Create(displayCanvasHandle);
  font := TGPFont.Create('Arial Black', 10);
  len := Length(sonNumberArray);
  starAngle := 0;
  g.SetSmoothingMode(SmoothingModeAntiAlias);
  sb := TGPSolidBrush.Create(MakeColor(0, 0, 255));
  p := TGPPen.Create(MakeColor(0, 255, 0), 2);
  rectPie.X := drawRetc.Left;
  rectPie.Y := drawRetc.Top;
  rectPie.Width := drawRetc.Right - drawRetc.Left;
  rectPie.Height := drawRetc.Bottom - drawRetc.Top;
  r := rectPie.Width / 2;
  for i := 0 to len - 1 do
  begin
    sb.SetColor(fillColorArray[i]);
    tempD := (sonNumberArray[i] / totalNumber) * 360;
    g.DrawPie(p, rectPie, starAngle, tempD);
    g.FillPie(sb, rectPie, starAngle, tempD);
    starAngle := starAngle + tempD;
  end;
  rectPie.Width := rectPie.Width / 2;
  rectPie.Height := rectPie.Height / 2;
  rectPie.X := rectPie.X + r - rectPie.Width / 2;
  rectPie.y := rectPie.Y + r - rectPie.height / 2;
  g.DrawEllipse(p, rectPie);
  sb.SetColor(aclWhite);
  g.FillEllipse(sb, rectPie);
  p.Free;
  sb.Free;
  g.Free;
end;

function TMyDataView.DrawDataHistogramView(totalNumber: Double; sonNumberArray: array of Double; displayCanvasHandle: THandle; fillColorArray: array of Cardinal): Integer;
begin

end;

end.


