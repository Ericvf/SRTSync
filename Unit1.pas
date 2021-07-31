unit Unit1;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  ComCtrls,
  functions;

type
  TForm1 = class(TForm)
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    PBar: TProgressBar;
    GroupBox1: TGroupBox;
    Button1: TButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    CheckBox1: TCheckBox;

    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  end;

var Form1: TForm1;
    filePath: string;

implementation
{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  if OpenDialog.Execute then
  begin
    filePath   := OpenDialog.FileName;
    Edit1.Text := filePath;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  StringList: TStringList;
  i, c, linenum:integer;
  T1, T2, Offset: TSrt;
  T: TArrayOfString;
begin
  Offset := StrToSrt(Edit3.Text+':'+Edit4.Text+':'+Edit5.Text+','+Edit6.Text);
  if Offset = 0 then
  begin
    MessageDlg('Please specify a higher offset!'#13'No files were processed', mtError, [mbOk], 0);
    exit;
  end;

  StringList := TStringList.Create;
  SetLength(T, 0);

  c := 0;

  if FileExists(filePath) then
  begin
    StringList.LoadFromFile(filePath);
    linenum  := StringList.Count-1;
    PBar.Max := linenum;

    for i:=0 to linenum do
    begin
      if Pos('-->', StringList[i]) <> 0 then
      begin
        if Length(StringList[i]) <> 29 then continue;

        T  := Explode(StringList[i], ' --> ');
        T1 := StrToSrt(T[0]);
        T2 := StrToSrt(T[1]);

        if not RadioButton1.Checked then
        begin
          T1 := T1 - Offset;
          T2 := T2 - Offset;
        end else
        begin
          T1 := T1 + Offset;
          T2 := T2 + Offset;
        end;

        StringList[i] := SrtToStr(T1) +' --> '+ SrtToStr(T2);
        Inc(c);
      end;
      PBar.Position := i;
    end;

    PBar.Position := 0;
    MessageDlg('All done, did '+IntToStr(c)+' modifications...', mtInformation, [mbOk], 0);

    if CheckBox1.Checked then CopyFile(PChar(filePath), PChar(filePath+'.bak'), False);
    StringList.SaveToFile(filePath);
    StringList.Free;
  end else
  if filepath = '' then MessageDlg('Please specify a valid filename to scan!', mtError, [mbOk], 0);
end;

end.
