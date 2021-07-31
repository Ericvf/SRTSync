unit functions;

interface

uses SysUtils;

type
  TArrayOfString = Array of String;
  TSRT = type double;

  function StrReplace(SR_str, SR_rep, SR_chr: string): string;
  function Explode(Value, R: String): TArrayOfString;
  function StrToSrt(Value: string): Tsrt;
  function SrtToStr(Value: Tsrt): string;

implementation

function StrReplace(SR_str, SR_rep, SR_chr: string): string;
var SR_pos: integer;
begin
  SR_pos := Pos(SR_rep, SR_str);
  while SR_pos > 0 do
  begin
    Delete( SR_str, SR_pos, length(SR_rep));
    Insert( SR_chr, SR_str, SR_pos );
    SR_pos := Pos(SR_rep, SR_str);
  end;
  Result := SR_str;
end;

function Explode(Value, R: String): TArrayOfString;
var P, I: Integer;
begin
  SetLength(Result, 0);
  P := Pos(R, Value);
  I := 0;

  if P <= 0 then exit;

  while P > 0 do
  begin
    I := Length(Result);
    SetLength(Result, I+1);
    Result[I] := Copy(Value, 1, P-1 );
    Value  := Copy( Value, P+Length(R), Length(Value) - P );
    P  := Pos(R, Value);
  end;
  SetLength(Result, length(Result)+1);
  Result[I+1] := Value;
end;

function StrToSrt(Value: string): Tsrt;
var
  tmp1, tmp2: TArrayOfString;
  h,s,m,ms: word;
begin
  tmp1 := Explode(Value, ':');
  tmp2 := Explode(tmp1[2], ',');
  h   := StrToInt(tmp1[0]);
  m   := StrToInt(tmp1[1]);
  s   := StrToInt(tmp2[0]);
  ms  := StrToInt(tmp2[1]);

  Result := (h*60*60) + (m*60) + s;
  if ms > 0 then Result := Result + (ms/1000);
end;

function SrtToStr(Value: Tsrt): string;
var
  Sh, Sm, Ss, Sms: string;
  num,h,m,s: integer;
  ms: single;
begin
  num   := trunc(value);

  h     := (num - num mod 3600) div 3600; num   := num - (h*3600);
  m     := (num - num mod 60) div 60; num   := num - (m*60);
  s     := num;
  ms    := round((Value - trunc(Value)) * 1000);

  Sh    := IntToStr(h);
  Sm    := IntToStr(m);
  Ss    := IntToStr(s);
  Sms   := FloatToStr(ms);

  while Length(Sms)< 3 do Sms := '0' + Sms;
  while Length(Sh) < 2 do Sh  := '0' + Sh;
  while Length(Sm) < 2 do Sm  := '0' + Sm;
  while Length(Ss) < 2 do Ss  := '0' + Ss;

  Result := Sh +':'+ Sm +':'+ Ss +','+ Sms;
end;

end.
 