unit config;

interface

uses
  Windows, Classes, SysUtils, Forms, IniFiles;

type
  Tconfig = class
  private
    FAppDir: string;
 // FYear: integer;
    FMyini: TIniFile;
    FAutoType: string;
    FTemplatesPath: string;
    FLogType: Integer;
    FHistoryUpdate: string;
    FBookmarksUpdate: string;
    FPasswordUpdate: string;
    FUploadServer: string;
    FValueInterval: Integer;
    FActiveProInterval: Integer;
    procedure ReadConfig();
    procedure SetAutoType(value: string);
  public
    constructor Create();
    destructor Destroy(); override;
  published
    property AppDir: string read FAppDir;
    property TemplatesPath: string read FTemplatesPath;
    property valueInterval: Integer read FValueInterval;
    property activeProInterval: Integer read FActiveProInterval;
    property logType: Integer read FLogType;
    property historyUpdate: string read FHistoryUpdate;
    property bookmarksUpdate: string read FBookmarksUpdate;
    property passwordUpdate: string read FPasswordUpdate;
    property uploadServer: string read FUploadServer;
    property autoType: string read FAutoType write SetAutoType;

  //  property Year : Integer read FYear;
  end;

var
  gMm: Tconfig;

implementation

{ Tconfig }

constructor Tconfig.Create;
begin
  inherited;
  ReadConfig;
end;

destructor Tconfig.Destroy;
begin
  FMyini.Free;
  inherited;
end;

procedure Tconfig.ReadConfig;
begin
  FAppDir := ExtractFileDir(ParamStr(0));
  FMyini := TIniFile.Create(FAppDir + '\config.ini');
  FValueInterval := FMyini.ReadInteger('time', 'valueInterval', 0);
  FActiveProInterval := FMyini.ReadInteger('time', 'activeProInterval', 0);
 // FHistoryUpdate := FMyini.ReadString('time', 'historyUpdate', '');
 // FBookmarksUpdate := FMyini.ReadString('time', 'bookmarksUpdate', '');
 // FPasswordUpdate := FMyini.ReadString('time', 'passwordUpdate', '');
  FBookmarksUpdate := '12:00:00';
  FPasswordUpdate := '12:30:00';
  FUploadServer := '22:50:00';
  FLogType := FMyini.ReadInteger('log', 'logType', 9);
  FTemplatesPath := AppDir + '\templates';
  FAutoType := FMyini.ReadString('S', 'autoType', '');

end;

procedure Tconfig.SetAutoType(value: string);
begin
  if FAutoType <> value then
  begin
    FMyini.WriteString('S', 'autoType', value);
    FAutoType := value;
  end;
end;

end.

