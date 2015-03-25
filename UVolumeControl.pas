unit UVolumeControl;

interface

uses Classes, Windows, SysUtils, MMSystem;

type
   TVolumeRec = record
     case Integer of
       0: (LongVolume: Longint);
       1: (LeftVolume, RightVolume : Word);
     end;

   procedure SetVolume(DeviceIndex: Cardinal; aVolume:Byte);
   function GetVolume(DeviceIndex: Cardinal): Cardinal;

const
  DEVICE_WAVE       = 0;
  DEVICE_MIDI       = 1;
  DEVICE_CD         = 2;
  DEVICE_LINEIN     = 3;
  DEVICE_MICROPHONE = 4;
  DEVICE_MASTER     = 5;
  DEVICE_PCSPEAKER  = 6;

implementation

procedure SetVolume(DeviceIndex: Cardinal; aVolume:Byte);
var
  Vol: TVolumeRec;
begin
   Vol.LeftVolume := aVolume shl 8;
   Vol.RightVolume:= Vol.LeftVolume;
   auxSetVolume(UINT(DeviceIndex), Vol.LongVolume);
end;

function GetVolume(DeviceIndex: Cardinal): Cardinal;
var
  Vol: TVolumeRec;
begin
   AuxGetVolume(UINT(DeviceIndex), @Vol.LongVolume);
   Result := (Vol.LeftVolume + Vol.RightVolume) shr 9;
end;

end.

