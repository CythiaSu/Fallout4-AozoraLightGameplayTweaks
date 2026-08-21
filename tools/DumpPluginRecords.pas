unit DumpPluginRecords;

var
  sl: TStringList;

function Initialize: integer;
begin
  sl := TStringList.Create;
  Result := 0;
end;

function Process(e: IInterface): integer;
var
  sig, line: string;
begin
  sig := Signature(e);
  if (sig = 'TES4') or (sig = 'GMST') or (sig = 'AVIF') or (sig = 'MGEF') or
     (sig = 'SPEL') or (sig = 'PERK') or (sig = 'QUST') or (sig = 'GLOB') then begin
    line := GetFileName(GetFile(e)) + #9 + sig + #9 +
      IntToHex(FixedFormID(e), 8) + #9 + EditorID(e) + #9 + Name(e);
    sl.Add(line);
  end;
  Result := 0;
end;

function Finalize: integer;
begin
  sl.SaveToFile(ProgramPath + 'Edit Scripts\DumpPluginRecords.out.txt');
  sl.Free;
  Result := 0;
end;

end.
