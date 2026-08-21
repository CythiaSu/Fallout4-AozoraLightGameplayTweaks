unit DumpAozoraTemplatePaths;

var
  sl: TStringList;

procedure DumpElement(e: IInterface; depth: integer);
var
  i: integer;
  pad: string;
begin
  pad := StringOfChar(' ', depth * 2);
  sl.Add(pad + Name(e) + ' | sig=' + Signature(e) + ' | path=' + Path(e) + ' | value=' + GetEditValue(e));
  for i := 0 to ElementCount(e) - 1 do
    DumpElement(ElementByIndex(e, i), depth + 1);
end;

function Initialize: integer;
begin
  sl := TStringList.Create;
  Result := 0;
end;

function Process(e: IInterface): integer;
begin
  if (Signature(e) = 'QUST') or (Signature(e) = 'SPEL') or (Signature(e) = 'MGEF') or (Signature(e) = 'GLOB') then begin
    sl.Add('==== ' + Name(e) + ' ====');
    DumpElement(e, 0);
  end;
  Result := 0;
end;

function Finalize: integer;
begin
  sl.SaveToFile(ProgramPath + 'Edit Scripts\DumpAozoraTemplatePaths.out.txt');
  sl.Free;
  Result := 0;
end;

end.
