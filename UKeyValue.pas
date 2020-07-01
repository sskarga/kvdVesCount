unit UKeyValue;

//------------------------------------------------------------------------------
                                interface
//------------------------------------------------------------------------------

const
  DELIMITER_SYM = ';';

type
  TKVPair = record
    Key: string;
    Val: string;
  end;

function setKV(KV : TKVPair; Delimiter : string = DELIMITER_SYM): string;
function getKV(inStr: string; var KV : TKVPair; Delimiter : string = DELIMITER_SYM): boolean;

//------------------------------------------------------------------------------
                                implementation
//------------------------------------------------------------------------------

function getKV(inStr: string; var KV : TKVPair; Delimiter : string = DELIMITER_SYM): boolean;
var
  index: Integer;
begin
  index := Pos(Delimiter,inStr);
  if index > 0 then
  begin
    KV.Key := Copy(inStr, 0, index - 1);
    KV.Val := Copy(inStr, index + 1, Length(inStr) - index);
    Result:= True;
  end
  else
  begin
    KV.Key := '';
    KV.Val := '';
    Result:= False;
  end;
end;

function setKV(KV : TKVPair; Delimiter : string = DELIMITER_SYM): string;
begin
  Result:= KV.Key + Delimiter + KV.Val;
end;


end.
