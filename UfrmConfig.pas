unit UfrmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmConfig = class(TForm)
    edtArqConfig: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    chkIniciar: TCheckBox;
    opd: TOpenDialog;
    btnCarregar: TButton;
    btnOK: TButton;
    btnCancelar: TButton;
    chkExibirMsg: TCheckBox;
    chkIniciarMinimizado: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

uses UfrmListaRadios, URadioWebPlayerUtils, StrUtils, Math;

{$R *.dfm}

procedure TfrmConfig.SpeedButton1Click(Sender: TObject);
begin
  if opd.Execute then
  begin
    edtArqConfig.Text := opd.FileName;
  end;
end;

procedure TfrmConfig.btnCarregarClick(Sender: TObject);
var
  lst: TStringList;
begin
  CarregarArquivoRadios(edtArqConfig.Text);
  lst := GetArquivoRadios;
  if (lst.Count > 0) then
    with TfrmListaRadios.Create(nil) do
      try
        ListaRadios := lst;
        if (ShowModal = mrOk) then
          GravarArquivoRadios(ListaRadios, edtArqConfig.Text);
      finally
        Free;
      end;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  with GetArquivoConfig do
  begin
    chkIniciar.Checked := (Values['IniciarWindows'] = 'S');
    edtArqConfig.Text  := Values['ArquivoRadios'];
    chkExibirMsg.Checked := (Values['ExibirMsgErro'] = 'S');
    chkIniciarMinimizado.Checked := (Values['IniciarMinimizado'] = 'S');
  end;
end;

procedure TfrmConfig.btnOKClick(Sender: TObject);
var
  Params: TArrayParams;
begin
  CarregarArquivoRadios(edtArqConfig.Text);

  SetLength(Params, 4);
  Params[0].Name := 'IniciarWindows';
  Params[0].Value:= IfThen(chkIniciar.Checked,'S','N');
  Params[1].Name := 'ArquivoRadios';
  Params[1].Value:= edtArqConfig.Text;
  Params[2].Name := 'ExibirMsgErro';
  Params[2].Value:= IfThen(chkExibirMsg.Checked, 'S', 'N');
  Params[3].Name := 'IniciarMinimizado';
  Params[3].Value:= IfThen(chkIniciarMinimizado.Checked, 'S', 'N');

  GravarConfiguracoes(Params);
end;

end.
