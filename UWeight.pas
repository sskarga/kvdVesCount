unit UWeight;

//------------------------------------------------------------------------------
                               interface
//------------------------------------------------------------------------------

uses Windows, USWMRGuard, Math;

type
  TEventWeightChange = procedure(weight: Double);

type
  TCountWeight = class(TObject)
  private
    wrLock: TSingleWriterMultipleReaderGuard;
    callBackEventChange: TEventWeightChange;
    _period : Cardinal;
    _weight : Double;

    lastUpdate: Cardinal;

    function GetWeight(): Double;
  public
    constructor Create(periodUpdate: Single; eventChange: TEventWeightChange; weight: Double = 0);
    destructor Destroy overload;
    property  Weight: Double read GetWeight;
    procedure PeriodSetWeight(weight: Double);
    procedure Reset();
  end;

//------------------------------------------------------------------------------
                             implementation
//------------------------------------------------------------------------------

constructor TCountWeight.Create(periodUpdate: Single; eventChange: TEventWeightChange; weight: Double = 0);
begin
  Self.wrLock := TSingleWriterMultipleReaderGuard.Create;
  Self.callBackEventChange := eventChange;
  Self._period := Round(periodUpdate * 1000);
  Self._weight := weight;
  lastUpdate:= GetTickCount;
end;

destructor TCountWeight.Destroy;
begin
  Self.wrLock.Free;
  inherited Destroy;
end;

function TCountWeight.GetWeight(): Double;
begin
  wrLock.WaitToRead;
   Result := Self._weight;
  wrLock.Done;
end;

procedure  TCountWeight.PeriodSetWeight(weight: Double);
var
  duration: Cardinal;
  duration_err: Cardinal;
  cor_weight: Double;
  weightCount : Double;
begin
  duration := GetTickCount - lastUpdate;
  if duration >= Self._period then
  begin
    if (weight > 0) then
    begin
      duration_err := duration - Round(Self._period);
      cor_weight:=RoundTo( weight/(duration/duration_err), -2);

      wrLock.WaitToWrite;
      Self._weight := RoundTo(_weight + weight + cor_weight, -2);
      weightCount := Self._weight;
      wrLock.Done;
    end;

    lastUpdate:= GetTickCount;
    Self.callBackEventChange(weightCount);
  end;
end;

procedure TCountWeight.Reset();
begin
  wrLock.WaitToWrite;
  Self._weight := 0;
  wrLock.Done;
  lastUpdate:= GetTickCount;
end;




end.

