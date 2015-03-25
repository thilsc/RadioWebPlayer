object frmConfig: TfrmConfig
  Left = 707
  Top = 416
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es'
  ClientHeight = 149
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 116
    Height = 13
    Caption = 'Arquivo de configura'#231#227'o'
  end
  object SpeedButton1: TSpeedButton
    Left = 305
    Top = 22
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    OnClick = SpeedButton1Click
  end
  object edtArqConfig: TEdit
    Left = 16
    Top = 24
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object chkIniciar: TCheckBox
    Left = 16
    Top = 88
    Width = 145
    Height = 17
    Caption = 'Iniciar com o Windows'
    TabOrder = 1
  end
  object btnCarregar: TButton
    Left = 112
    Top = 52
    Width = 97
    Height = 25
    Caption = 'Carregar arquivo'
    TabOrder = 2
    OnClick = btnCarregarClick
  end
  object btnOK: TButton
    Left = 72
    Top = 116
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancelar: TButton
    Left = 192
    Top = 116
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 4
  end
  object opd: TOpenDialog
    DefaultExt = '.ini'
    FileName = 'C:\Thiago_Coutinho\radios.ini'
    Filter = 'Arquivo de configura'#231#227'o (*.ini)|*.ini'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Selecione o arquivo de configura'#231#227'o'
    Left = 276
    Top = 20
  end
end
