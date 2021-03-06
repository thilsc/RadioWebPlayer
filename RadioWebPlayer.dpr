program RadioWebPlayer;

uses
  Forms,
  UfrmRadioWebPlayer in 'UfrmRadioWebPlayer.pas' {frmRadioWebPlayer},
  UfrmConfig in 'UfrmConfig.pas' {frmConfig},
  URadioWebPlayerUtils in 'URadioWebPlayerUtils.pas',
  UVolumeControl in 'UVolumeControl.pas',
  UfrmListaRadios in 'UfrmListaRadios.pas' {frmListaRadios};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Radio Web Player';
  Application.CreateForm(TfrmRadioWebPlayer, frmRadioWebPlayer);
  Application.Run;
end.

