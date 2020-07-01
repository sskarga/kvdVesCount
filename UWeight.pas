unit UWeight;

//------------------------------------------------------------------------------
                               interface
//------------------------------------------------------------------------------

uses Windows, USWMRGuard;

type
  TEventWeightChange = procedure(weight: Double);

type
  TCountWeight = class(TObject)
  private
    wrLock: TSingleWriterMultipleReaderGuard;
    callBackEventChange: TEventWeightChange;
    _period : Cardinal;
    _weight : Double;

    lastUpdate: TDateTime;

    function GetWeight(): Double;
  public
    constructor Create(periodUpdate: Single; eventChange: TEventWeightChange);
    destructor Destroy overload;
    property  Weight: Double read GetWeight;
    procedure PeriodSetWeight(weight: Double; TimeStamp: TDateTime);
  end;

//------------------------------------------------------------------------------
                             implementation
//------------------------------------------------------------------------------

uses DateUtils, Math, SysUtils;

constructor TCountWeight.Create(periodUpdate: Single; eventChange: TEventWeightChange);
begin
  Self.wrLock := TSingleWriterMultipleReaderGuard.Create;
  Self.callBackEventChange := eventChange;
  Self._period := Round(periodUpdate * 1000);
  Self._weight := 0;
  lastUpdate:= Now;
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

procedure TCountWeight.PeriodSetWeight(weight: Double; TimeStamp: TDateTime);
var
  duration: Cardinal;
  duration_err: Cardinal;
  cor_weight: Double;
  weightCount : Double;
begin
  duration := MilliSecondsBetween(TimeStamp, lastUpdate);
  if duration >= Self._period then
  begin
    lastUpdate:= TimeStamp;

    if (weight > 0) and (duration < (Self._period * 1.5)) then
    begin
      try
        duration_err := duration - Round(Self._period);
        if duration_err > 0 then
          cor_weight := RoundTo( weight/(duration/duration_err), -2)
        else
          cor_weight := 0;

        wrLock.WaitToWrite;
        Self._weight := RoundTo(weight + cor_weight, -2);
        weightCount := Self._weight;
        wrLock.Done;
        Self.callBackEventChange(weightCount);
      except
        Self._weight := 0;
      end;

    end;

  end;
end;


end.

