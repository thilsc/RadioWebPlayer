unit UfrmRadioWebPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, CoolTrayIcon, ActnList,
  Menus;

type
  TfrmRadioWebPlayer = class(TForm)
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    cbLinks: TComboBox;
    Button1: TButton;
    Button2: TButton;
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
    chkExibirMsg: TCheckBox;
    btnConfig: TButton;
    ActMudo: TAction;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure trayClick(Sender: TObject);
    procedure ActAtualizarExecute(Sender: TObject);
    procedure ActFecharExecute(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure chkExibirMsgClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActMudoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    FIndexRadioAtual: Integer;
    procedure RadioMenuClick(Sender: TObject);
    procedure TocarRadio(RadioIndex: Integer);
    procedure SetListaRadios(lst: TStrings; MenuRadios: TMenuItem);
  public
    { Public declarations }
  end;

var
  frmRadioWebPlayer: TfrmRadioWebPlayer;

implementation

uses URadioWebPlayerUtils, UfrmConfig;

var
  LastVolume: Cardinal;

{$R *.dfm}
                  
procedure TfrmRadioWebPlayer.FormCreate(Sender: TObject);
begin
  LastVolume := 0;
  SetListaRadios(cbLinks.Items, Radios1);
  FIndexRadioAtual := -1;
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

procedure TfrmRadioWebPlayer.Button1Click(Sender: TObject);
begin
  TocarRadio(cbLinks.ItemIndex);
end;

procedure TfrmRadioWebPlayer.TocarRadio(RadioIndex: Integer);
begin
  WebBrowser1.Stop;
  if (RadioIndex >= 0) and (RadioIndex <> FIndexRadioAtual) then
  begin
    WebBrowser1.Navigate(GetArquivoRadios.ValueFromIndex[RadioIndex]);
    FIndexRadioAtual := RadioIndex;
    tray.Hint := 'Radio Web Player - '+cbLinks.Text;
  end;
end;

procedure TfrmRadioWebPlayer.Button2Click(Sender: TObject);
begin
  ActAtualizar.Execute;
end;

procedure TfrmRadioWebPlayer.trayClick(Sender: TObject);
begin
  Show;
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
  cbLinks.ItemIndex := TMenuItem(Sender).Tag;
  TocarRadio(cbLinks.ItemIndex);
end;

procedure TfrmRadioWebPlayer.btnConfigClick(Sender: TObject);
begin
  with TFrmConfig.Create(nil) do
    try
      if (ShowModal = mrOk) then
        ;
    finally
      Free;
    end;
end;

procedure TfrmRadioWebPlayer.chkExibirMsgClick(Sender: TObject);
begin
  WebBrowser1.Silent := not chkExibirMsg.Checked;
end;

procedure TfrmRadioWebPlayer.FormShow(Sender: TObject);
begin
  if (FIndexRadioAtual < 0) then
    WebBrowser1.Navigate('about:blank');

  AplicaPosSizeForm(Self);
end;

procedure TfrmRadioWebPlayer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RecuperaPosSizeForm(Self);
end;

procedure TfrmRadioWebPlayer.FormHide(Sender: TObject);
begin
  RecuperaPosSizeForm(Self);
end;

end.
