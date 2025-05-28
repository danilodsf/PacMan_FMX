unit uUtils;

interface

uses
  System.SysUtils,
  System.IOUtils,
  FMX.Graphics;

  procedure CreateSprite(var ABitMap: TBitMap; APath: string);

implementation

procedure CreateSprite(var ABitMap: TBitMap; APath: string);
begin
  if FileExists(TPath.Combine(GetCurrentDir, APath)) then
  begin
    ABitMap := TBitmap.Create;
    ABitMap.LoadFromFile(TPath.Combine(GetCurrentDir, APath));
  end
  else
    raise Exception.Create('Não existe o arquivo: '+APath);
end;

end.
