object frmListaRadios: TfrmListaRadios
  Left = 269
  Top = 116
  Width = 533
  Height = 346
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Esta'#231#245'es'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    517
    308)
  PixelsPerInch = 96
  TextHeight = 13
  object sg: TStringGrid
    Left = 8
    Top = 8
    Width = 499
    Height = 257
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultColWidth = 144
    DefaultRowHeight = 16
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 0
    ColWidths = (
      144
      336)
  end
  object btnOk: TButton
    Left = 166
    Top = 276
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancelar: TButton
    Left = 270
    Top = 276
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
end
