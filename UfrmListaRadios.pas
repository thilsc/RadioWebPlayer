unit UfrmListaRadios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TfrmListaRadios = class(TForm)
    sg: TStringGrid;
    btnOk: TButton;
    btnCancelar: TButton;
  private
    FListaRadios: TStringList;
    procedure SetListaRadios(const Value: TStringList);
    procedure PreencheGridRadios;
    { Private declarations }
  public
    { Public declarations }
    property ListaRadios: TStringList read FListaRadios write SetListaRadios;
  end;

var
  frmListaRadios: TfrmListaRadios;

implementation

{$R *.dfm}

{ TfrmListaRadios }

procedure TfrmListaRadios.SetListaRadios(const Value: TStringList);
begin
  if (FListaRadios <> Value) then
  begin
    FListaRadios := Value;
    PreencheGridRadios;
  end;
end;

procedure TfrmListaRadios.PreencheGridRadios;
var
  iCol, iRow: Cardinal;
begin
  sg.ColCount   := 2;
  sg.FixedCols  := 1;
  sg.RowCount   := FListaRadios.Count + 1;
  sg.Cells[0,0] := 'Estações';
  sg.Cells[1,0] := 'URL';
  for iRow := 1 to Pred(sg.RowCount) do
    for iCol := 0 to Pred(sg.ColCount) do
      case iCol of
        0: sg.Cells[iCol,iRow] := FListaRadios.Names[iRow-1];
        1: sg.Cells[iCol,iRow] := FListaRadios.ValueFromIndex[iRow-1];
      end;
end;

end.
