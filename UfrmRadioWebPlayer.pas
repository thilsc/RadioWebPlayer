unit UfrmRadioWebPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, CoolTrayIcon, ActnList,
  Menus, Buttons,  ceflib, cefvcl, cefgui;

type
  TfrmRadioWebPlayer = class(TForm)
    pnlStatus: TPanel;
    tray: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    mnuMudo: TMenuItem;
    ActionList1: TActionList;
    ActAtualizar: TAction;
    ActFechar: TAction;
    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Fechar1: TMenuItem;
    N2: TMenuItem;
    Radios1: TMenuItem;
    ActMudo: TAction;
    Configurar1: TMenuItem;
    ActConfigurar: TAction;
    pnlEsquerda: TPanel;
    Splitter1: TSplitter;
    LstLinks: TListBox;
    PnlControles: TPanel;
    btnExecutar: TSpeedButton;
    btnParar: TSpeedButton;
    btnAtualizar: TSpeedButton;
    ActExecutar: TAction;
    ActParar: TAction;
    SpeedButton1: TSpeedButton;
    btnToggleView: TSpeedButton;
    pnlCompactView: TPanel;
    btnPopupEspecial: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ppmRadios: TPopupMenu;
    Radios2: TMenuItem;
    WebBrowser1: TWebBrowser;
    AbrirPlayer1: TMenuItem;
    ActExibirOcultar: TAction;
    procedure FormCreate(Sender: TObject);
    procedure ActAtualizarExecute(Sender: TObject);
    procedure ActFecharExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActMudoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure ActConfigurarExecute(Sender: TObject);
    procedure ActExecutarExecute(Sender: TObject);
    procedure ActPararExecute(Sender: TObject);
    procedure LstLinksDblClick(Sender: TObject);
    procedure btnToggleViewClick(Sender: TObject);
    procedure btnPopupEspecialClick(Sender: TObject);
    procedure ActExibirOcultarExecute(Sender: TObject);

  private
    { Private declarations }
    FIndexRadioAtual: Integer;
    FCompactView: Boolean;
    procedure RadioMenuClick(Sender: TObject);
    procedure TocarRadio(RadioIndex: Integer);
    procedure SetListaRadios(lst: TStrings; MenuRadios: TMenuItem);
    procedure AlteraVisualizacao;
    procedure IrParaURL(sURL: string);
  public
    { Public declarations }
  end;

var
  frmRadioWebPlayer: TfrmRadioWebPlayer;

implementation

uses URadioWebPlayerUtils, UfrmConfig, StrUtils;

var
  LastVolume: Cardinal;

{$R *.dfm}

procedure TfrmRadioWebPlayer.FormCreate(Sender: TObject);
begin
  LastVolume := 0;
  SetListaRadios(LstLinks.Items, Radios1);
  SetListaRadios(LstLinks.Items, Radios2);
  FIndexRadioAtual := -1;
  FCompactView := False;
  AlteraVisualizacao;
  //WebBrowser1.RegisterAsBrowser := True;
end;

procedure TfrmRadioWebPlayer.SetListaRadios(lst: TStrings; MenuRadios: TMenuItem);
var
  I: Integer;
  MenuItem: TMenuItem;
begin
  lst.Clear;
  MenuRadios.Clear;
  for I := 0 to Pred(GetArquivoRadios.Count) do
  begin
    lst.Add(GetArquivoRadios.Names[I]);
    MenuItem := TMenuItem.Create(MenuRadios);
    MenuItem.Caption := GetArquivoRadios.Names[I];
    MenuItem.OnClick := RadioMenuClick;
    MenuItem.Tag := I;
    MenuRadios.Add(MenuItem);
  end;
end;

procedure TfrmRadioWebPlayer.TocarRadio(RadioIndex: Integer);
begin
  if (RadioIndex >= 0) and (RadioIndex <> FIndexRadioAtual) then
  begin
    IrParaURL(GetArquivoRadios.ValueFromIndex[RadioIndex]);
    FIndexRadioAtual := RadioIndex;
    tray.Hint := 'Radio Web Player - '+LstLinks.Items[RadioIndex];
    pnlStatus.Caption := 'Executando r�dio: '+LstLinks.Items[RadioIndex];
  end;
end;

procedure TfrmRadioWebPlayer.ActMudoExecute(Sender: TObject);
begin
(*  if mnuMudo.Checked {habilitar som} then
  begin
    SetVolume(LastVolume)
  end
  else //deixar mudo
  begin
    LastVolume := GetVolume;*)
    SetMute;
//  end;
  mnuMudo.Checked := not mnuMudo.Checked;
end;

procedure TfrmRadioWebPlayer.ActAtualizarExecute(Sender: TObject);
begin
  WebBrowser1.Stop;
  WebBrowser1.Refresh;
end;

procedure TfrmRadioWebPlayer.ActFecharExecute(Sender: TObject);
begin
  WebBrowser1.Stop;
  Close;
end;

procedure TfrmRadioWebPlayer.RadioMenuClick(Sender: TObject);
begin
  LstLinks.ItemIndex := TMenuItem(Sender).Tag;
  TocarRadio(LstLinks.ItemIndex);
end;

procedure TfrmRadioWebPlayer.FormShow(Sender: TObject);
begin
  if (FIndexRadioAtual < 0) then
    ActParar.Execute;

  AplicaPosSizeForm(Self);
  ActExibirOcultar.Caption := IfThen(Self.Visible, 'Ocultar', 'Exibir')+' Player';  
  WebBrowser1.Silent := (GetArquivoConfig.Values['ExibirMsgErro'] <> 'S');
end;

procedure TfrmRadioWebPlayer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RecuperaPosSizeForm(Self);
end;

procedure TfrmRadioWebPlayer.FormHide(Sender: TObject);
begin
  RecuperaPosSizeForm(Self);
  ActExibirOcultar.Caption := IfThen(Self.Visible, 'Ocultar', 'Exibir')+' Player';
end;

procedure TfrmRadioWebPlayer.ActConfigurarExecute(Sender: TObject);
begin
  with TFrmConfig.Create(nil) do
    try
      if (ShowModal = mrOk) then
        ;
    finally
      Free;
    end;
end;

procedure TfrmRadioWebPlayer.ActExecutarExecute(Sender: TObject);
begin
  TocarRadio(LstLinks.ItemIndex);
end;

procedure TfrmRadioWebPlayer.ActPararExecute(Sender: TObject);
begin
  IrParaURL('about:blank');
  pnlStatus.Caption := 'Parado';
end;

procedure TfrmRadioWebPlayer.IrParaURL(sURL: string);
var
  Flags: OleVariant;
begin
  Flags := navNoHistory;
  WebBrowser1.Stop;
  WebBrowser1.Navigate(sURL); //(sURL, Flags);
end;

procedure TfrmRadioWebPlayer.LstLinksDblClick(Sender: TObject);
begin
  ActExecutar.Execute;
end;

procedure TfrmRadioWebPlayer.btnToggleViewClick(Sender: TObject);
begin
  FCompactView := not FCompactView;
  AlteraVisualizacao;
end;

procedure TfrmRadioWebPlayer.AlteraVisualizacao;
begin
  if FCompactView then
  begin
    BorderStyle  := bsNone;
    FormStyle    := fsStayOnTop;
    Top          := Screen.Height - 80;
    Left         := Screen.Width - 320;
    if (Top < 0) then Top := 0;
    ClientHeight := 40;
    ClientWidth  := 320;
    pnlCompactView.Visible := True;
    ActAtualizar.Execute;
  end
  else
  begin
    BorderStyle  := bsSizeable;
    FormStyle    := fsNormal;
    Position     := poDesktopCenter;
    ClientHeight := 207;
    ClientWidth  := 412;
    pnlCompactView.Visible := False;    
  end
end;

procedure TfrmRadioWebPlayer.btnPopupEspecialClick(Sender: TObject);
begin
  ppmRadios.Popup(Screen.Height+Height+Width, Top+20);
end;

procedure TfrmRadioWebPlayer.ActExibirOcultarExecute(Sender: TObject);
begin
  if Self.Visible then
    Hide
  else
    Show;
end;

end.
