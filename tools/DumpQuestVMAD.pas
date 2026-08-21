unit DumpQuestVMAD;

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
var
  f: IInterface;
  q: IInterface;
begin
  sl := TStringList.Create;
  f := FileByIndex(0);
  q := MainRecordByEditorID(GroupBySignature(f, 'QUST'), 'MQ04');
  if Assigned(q) then
    DumpElement(ElementByPath(q, 'VMAD'), 0)
  else
    sl.Add('MQ04 not found');
  Result := 0;
end;

function Finalize: integer;
begin
  sl.SaveToFile(ProgramPath + 'Edit Scripts\DumpQuestVMAD.out.txt');
  sl.Free;
  Result := 0;
end;

end.
