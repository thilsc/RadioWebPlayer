unit URadioWebPlayerUtils;

interface

uses Classes, SysUtils, Windows, Forms, FileCtrl, Dialogs;

type
  TParamFile = record
                 Name,
                 Value: string;
               end;
  TArrayParams = array of TParamFile;
  TPositionApp = packed record
                   Left, Top, Height, Width: Cardinal;
                 end;

function GetArquivoConfig: TStringList;
function GetArquivoRadios: TStringList;
procedure CarregarArquivoConfiguracao;
//procedure GravarConfiguracoes(ArquivoRadios: string; IniciarWindows: Boolean); overload;
procedure GravarConfiguracoes(AParams: TArrayParams); //overload;
procedure CarregarArquivoRadios(FileName: string);
procedure GravarArquivoRadios(lst: TStringList; FileName: string);
procedure SetMute;
function GetVolume: Cardinal;
procedure SetVolume(aVolume: Byte);
procedure RecuperarUltimaPosicao;
procedure GravarUltimaPosicao;
procedure RecuperaPosSizeForm(AForm: TForm);
procedure AplicaPosSizeForm(AForm: TForm);

const
  DEFAULT_INI = 'RadioWebPlayer.ini';
  VK_VOLUME_MUTE = $AD;
  VK_VOLUME_DOWN = $AE;
  VK_VOLUME_UP   = $AF;

implementation

uses StrUtils, UVolumeControl;

var
  FArquivoConfig,
  FArquivoRadios: TStringList;
  FArquivoConfigFileName,
  FArquivoRadiosFileName: string;
  FLastPositionApp: TPositionApp;

function GetArquivoConfig: TStringList;
begin
  Result := FArquivoConfig;
end;

function GetArquivoRadios: TStringList;
begin
  Result := FArquivoRadios;
end;

procedure CarregarArquivoConfiguracao;
var
  sConfigFile: string;
begin
  sConfigFile := ExtractFilePath(Application.ExeName)+DEFAULT_INI;

  if (not Assigned(FArquivoConfig)) then
    FArquivoConfig := TStringList.Create;
  FArquivoConfig.Clear;

  if FileExists(sConfigFile) then
  begin
    FArquivoConfig.LoadFromFile(sConfigFile);
    FArquivoConfigFileName := sConfigFile;
  end
  else
    MessageDlg('Arquivo de configuração "'+sConfigFile+'" não encontrado.',
      mtError, [mbOK], 0);
end;

procedure CarregarArquivoRadios(FileName: string);
begin
  if (not Assigned(FArquivoRadios)) then
    FArquivoRadios := TStringList.Create;
  FArquivoRadios.Clear;

  if FileExists(FileName) then
  begin
    FArquivoRadios.LoadFromFile(FileName);
    FArquivoRadiosFileName := FileName;
  end
  else
    MessageDlg('Arquivo de configuração "'+FileName+'" não encontrado.',
      mtError, [mbOK], 0);
end;

procedure GravarArquivoRadios(lst: TStringList; FileName: string);
begin
  FArquivoRadios.Text := lst.Text;
  FArquivoRadios.SaveToFile(FileName);
end;

procedure GravarConfiguracoes(AParams: TArrayParams);
var
  I: Integer;
begin
  with GetArquivoConfig do
    for I := 0 to Pred(Length(AParams)) do
      if (AParams[I].Name <> '') then
        Values[AParams[I].Name] := AParams[I].Value;

  FArquivoConfig.SaveToFile(FArquivoConfigFileName);
end;

procedure SetMute;
begin
  keybd_event(VK_VOLUME_MUTE, MapVirtualKey(VK_VOLUME_MUTE,0), 0, 0);
  keybd_event(VK_VOLUME_MUTE, MapVirtualKey(VK_VOLUME_MUTE,0), KEYEVENTF_KEYUP, 0);
end;

function GetVolume: Cardinal;
begin
  Result := UVolumeControl.GetVolume(DEVICE_MASTER);
end;

procedure SetVolume(aVolume: Byte);
var
  I:Integer;
begin
  SetMute;
  for I := 0 to aVolume do
  begin
    keybd_event(VK_VOLUME_UP, MapVirtualKey(VK_VOLUME_UP,0), 0, 0);
    keybd_event(VK_VOLUME_UP, MapVirtualKey(VK_VOLUME_UP,0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure RecuperarUltimaPosicao;
var
  sLastPos, sSizeWindow: string;
begin
  sLastPos    := FArquivoConfig.Values['LastPos'];
  sSizeWindow := FArquivoConfig.Values['SizeWindow'];
  if (sLastPos <> '') then
  begin
    FLastPositionApp.Top  := StrToIntDef(Copy(sLastPos, 1, Pos(',', sLastPos)-1), 0);
    FLastPositionApp.Left := StrToIntDef(Copy(sLastPos, Pos(',', sLastPos)+1, Length(sLastPos)-Pos(',', sLastPos)), 0);
  end;

  if (sSizeWindow <> '') then
  begin
    FLastPositionApp.Height := StrToIntDef(Copy(sSizeWindow, 1, Pos(',', sSizeWindow)-1), 0);
    FLastPositionApp.Width  := StrToIntDef(Copy(sSizeWindow, Pos(',', sSizeWindow)+1, Length(sSizeWindow)-Pos(',', sSizeWindow)), 0);
  end;
end;

procedure GravarUltimaPosicao;
var
  Params: TArrayParams;
begin
  SetLength(Params, 2);
  Params[0].Name := 'LastPos';
  Params[0].Value:= IntToStr(FLastPositionApp.Top)+','+IntToStr(FLastPositionApp.Left);
  Params[1].Name := 'SizeWindow';
  Params[1].Value:= IntToStr(FLastPositionApp.Height)+','+IntToStr(FLastPositionApp.Width);
  GravarConfiguracoes(Params);
end;

procedure RecuperaPosSizeForm(AForm: TForm);
begin
  FLastPositionApp.Left  := AForm.Left;
  FLastPositionApp.Top   := AForm.Top;
  FLastPositionApp.Height:= AForm.Height;
  FLastPositionApp.Width := AForm.Width;
end;

procedure AplicaPosSizeForm(AForm: TForm);
begin
  if ((FLastPositionApp.Height > 0) and (FLastPositionApp.Width > 0)) then
  begin
    AForm.Left  := FLastPositionApp.Left;
    AForm.Top   := FLastPositionApp.Top;
    AForm.Height:= FLastPositionApp.Height;
    AForm.Width := FLastPositionApp.Width;
  end;
end;

initialization
  CarregarArquivoConfiguracao;
  CarregarArquivoRadios(FArquivoConfig.Values['ArquivoRadios']);
  RecuperarUltimaPosicao;  
finalization
  GravarUltimaPosicao;
end.
