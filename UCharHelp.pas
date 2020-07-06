unit UCharHelp;

//------------------------------------------------------------------------------
                                interface
//------------------------------------------------------------------------------

uses
  TeEngine, Series, TeeProcs, Chart, DateUtils;

procedure LoadPointToChart(fileName: string; chr: TChartSeries);
function checkCurrentShiftFile(fileName: string; ShiftDate: TDateTime; ShiftId: Integer): Boolean;
function AddPointChartToFile(fileName: string; x: TDateTime; y: Double; ShiftDate: TDateTime; ShiftId: Integer): Boolean;

//------------------------------------------------------------------------------
                            implementation
//------------------------------------------------------------------------------

uses
  UKeyValue, SysUtils;

procedure LoadPointToChart(fileName: string; chr: TChartSeries);
var
  LFile: TextFile;
  pair : TKVPair;
  text : string;
begin
  if FileExists(fileName) then
  begin
    try
      AssignFile(LFile, fileName);
      Reset(LFile);
      ReadLn(LFile, text); // data_shift; id_shift

      while not Eof(LFile) do
      begin
        ReadLn(LFile, text);
        getKV(text, pair);
        chr.AddXY(StrToDateTime(pair.Key), StrToFloat(pair.Val));
      end;
    finally
      CloseFile(LFile);
    end;
  end;
end;

function checkCurrentShiftFile(fileName: string; ShiftDate: TDateTime; ShiftId: Integer): Boolean;
var
  LFile: TextFile;
  pair : TKVPair;
  text : string;
begin
  Result:= False;

  if FileExists(fileName) then
  begin
    try
      AssignFile(LFile, fileName);
      Reset(LFile);
      ReadLn(LFile, text);
      getKV(text, pair);
      if (DateToStr(ShiftDate) = pair.Key) and (IntToStr(ShiftId) = pair.Val) then
        Result:= True
      else
        Result:= False;
    finally
      CloseFile(LFile);
    end;
  end;

end;

function AddPointChartToFile(fileName: string; x: TDateTime; y: Double; ShiftDate: TDateTime; ShiftId: Integer): Boolean;
var
  LFile: TextFile;
  pair: TKVPair;
begin
  Result:= False;
  try
    AssignFile(LFile, fileName);

    if not FileExists(fileName) then
    begin
        Rewrite(LFile);
        pair.Key := DateToStr(ShiftDate);
        pair.Val := IntToStr(ShiftId);
        Writeln(LFile, setKV(pair) );
        CloseFile(LFile);
    end;

    pair.Key := DateTimeToStr(x);
    pair.Val := FloatToStr(y);
    Append(LFile);
    Writeln(LFile, setKV(pair));
    Result:= True;
  finally
    CloseFile(LFile);
  end;

end;

end.
