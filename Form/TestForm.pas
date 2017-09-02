unit TestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeeGDIPlus, TeEngine, Series, TeeProcs, Chart, ExtCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxSplitter;

type
  TForm1 = class(TForm)
    pnlPie: TPanel;
    recordChart: TChart;
    psrsRecord: TPieSeries;
    pnlManiViewPage: TPanel;
    pnlHistogram: TPanel;
    Chart2: TChart;
    PieSeries2: TPieSeries;
    cxspltr: TcxSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
