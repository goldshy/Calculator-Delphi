unit kalkulacka2_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Math;

type
  TOperation = (opNone, opPlus, opMinus, opDivide, opMultiply);
  TResultmod = (resNone, resEqual);
  Tform_Kalkulacka = class(TForm)
    pnl_BckSpc: TPanel;
    pnl_n7: TPanel;
    pnl_n4: TPanel;
    pnl_n1: TPanel;
    pnl_n0: TPanel;
    pnl_n8: TPanel;
    pnl_n5: TPanel;
    pnl_n2: TPanel;
    pnl_Dot: TPanel;
    pnl_Clear: TPanel;
    pnl_n9: TPanel;
    pnl_n6: TPanel;
    pnl_n3: TPanel;
    pnl_Equal: TPanel;
    pnl_PlusMinus: TPanel;
    pnl_Plus: TPanel;
    pnl_Minus: TPanel;
    pnl_Multiplication: TPanel;
    pnl_Divide: TPanel;
    pnl_Backround: TPanel;
    pnlOperations: TPanel;
    pnl_ClearEntry: TPanel;
    pnl_Bottom: TPanel;
    lbl_variables: TLabel;
    lbl_Output: TLabel;
    pnl_Numbers: TPanel;


    procedure ClickForNumber(Sender: TObject);
    procedure pnl_BckSpcClick(Sender: TObject);
    procedure pnl_ClearClick(Sender: TObject);
    procedure pnl_PlusMinusClick(Sender: TObject);
    procedure pnl_DotClick(Sender: TObject);
    procedure pnl_EqualClick(Sender: TObject);
    procedure pnl_ButtonLikeDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnl_ButtonLikeUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OperatorsFunctionClick(Sender: TObject);
    procedure CommaSeparatorScan(Sender: TObject);
  private
    { Private declarations }
    num1, num2 : Real; // Numbers entered by the user
    op : TOperation; {Type of operation for calculation     opNone = nothing
                                                            opPlus = addition
                                                            opMinus = subtraction
                                                            opMultiply = multiplication
                                                            opDivide = division }
    resusltMod : TResultmod; {Separate modes for calculator   resNone = nothing mode
                                                              resEqual = equals mode }

    procedure NumToVis; //Inputs value of num1 into lbl_Output and also inputs used variables in second labels
    procedure Calculate; //Calculates variables num1 and num2
    procedure FocusFunctionColor(Sender: TObject); //Changes the color of operators, depending on which one is currently in use
    procedure VisToNum; //Enters values from lbl_output to num1 and num2
    procedure ClearDisplayAndInput; //Clears label and empties the variables
    procedure MaxNumber; //Limits user to use numbers only visible in lbl_Output
  public
    { Public declarations }
  end;

var
  form_Kalkulacka: Tform_Kalkulacka;

implementation

{$R *.dfm}


procedure Tform_Kalkulacka.CommaSeparatorScan(Sender: TObject);
begin
  //Makes the system use "." as a default decimal separator
  FormatSettings.DecimalSeparator := '.';
end;

procedure Tform_Kalkulacka.FocusFunctionColor(Sender: TObject);
var i : integer;
begin
  //Changes the color of operators, depending on which one is currently in use
  for i := 0 to pnlOperations.ControlCount - 1 do begin
    var p := pnlOperations.Controls[i];
    if not (p is TPanel) then Continue;
    if p = Sender then TPanel(p).Color := $00CD3691
    else TPanel(p).Color := $00D8712C;
  end;
end;

procedure Tform_Kalkulacka.MaxNumber;
var intMaxValueNum : integer;
var strOutput, strHistory : string;
begin
  //Limits user to use numbers only visible in lbl_Output
  strOutput := lbl_Output.Caption;
  intMaxValueNum := Length(strOutput);
  if intMaxValueNum >= 10 then begin
    case intMaxValueNum of
      10 : lbl_Output.Font.Size := 21;
      11 : lbl_Output.Font.Size := 20;
      12 : lbl_Output.Font.Size := 19;
      13 : lbl_Output.Font.Size := 18;
      14 : lbl_Output.Font.Size := 17;
      15 : lbl_Output.Font.Size := 16;
    end;
    if intMaxValueNum >= 16 then lbl_Output.Font.Size := 15;
  end else lbl_Output.Font.Size := 22;
  if intMaxValueNum = 16 then pnl_Numbers.Enabled := False
  else pnl_Numbers.Enabled := True;
  //Makes numbers smaller so they can fit into lbl_variables
  strHistory := lbl_variables.Caption;
  intMaxValueNum := Length(strHistory);
  if intMaxValueNum >= 10 then begin
    case intMaxValueNum of
      10 : lbl_variables.Font.Size := 15;
      11 : lbl_variables.Font.Size := 14;
      12 : lbl_variables.Font.Size := 13;
      13 : lbl_variables.Font.Size := 12;
      14 : lbl_variables.Font.Size := 11;
      15 : lbl_variables.Font.Size := 10;
    end;
    if intMaxValueNum >= 16 then lbl_variables.Font.Size := 9;
  end else lbl_variables.Font.Size := 16;
end;

procedure Tform_Kalkulacka.NumToVis;
var operatives : string;
begin
  //Inputs value of num1 into lbl_Output and also inputs used variables in second labels
  case op of
    opNone : operatives := '';
    opPlus : operatives := '+';
    opMinus : operatives := '-';
    opDivide : operatives := '÷';
    opMultiply : operatives := '×';
  end;
  if resusltMod = resEqual then lbl_Output.Caption := FloatToStr(num1);
  if (num1 = 0) and (num2=0) then lbl_variables.Caption := '' else
  lbl_variables.Caption := FloatToStr(num1) + ' ' + operatives + ' ' + FloatToStr(num2);
  if (num1 <> 0) and (op = opNone) then lbl_variables.Caption := '';
end;

procedure Tform_Kalkulacka.Calculate;
var a : Double;
var t : TPanel;
begin
  //Calculates variables num1 and num2
  if (op = opDivide) and (num2 = 0) then begin
    ShowMessage('Nelze dìlit 0');
    ClearDisplayAndInput;
    FocusFunctionColor(t);
    exit
  end;
  case op of
    opNone : ;
    opPlus : num1 := num1 + num2;
    opMinus : num1 := num1 - num2;
    opDivide : num1 := num1 / num2;
    opMultiply : num1 := num1 * num2;
  end;
end;

procedure Tform_Kalkulacka.ClearDisplayAndInput;
begin
  //Clears label and empties the variables
  lbl_Output.Caption := '0';
  lbl_variables.Caption := '';
  op := opNone;
  num1 := 0;
  num2 := 0;
end;

procedure Tform_Kalkulacka.ClickForNumber(Sender: TObject);
var b : Tpanel;
begin
  b := Sender as TPanel ;
  //After calculation is done and the user presses a number key, resets the calculator so he can calculate more.
  if resusltMod = resEqual then begin
    ClearDisplayAndInput;
    resusltMod := resNone;
    FocusFunctionColor(b);
  end;
  //Inputs Number into lbl_Output
  if lbl_Output.Caption = '0' then lbl_Output.Caption := b.Caption
  else lbl_Output.Caption := lbl_Output.Caption + b.Caption;
  VisToNum;
  NumToVis;
  MaxNumber;
end;

procedure Tform_Kalkulacka.OperatorsFunctionClick(Sender: TObject);
var T : TPanel;
    i: Integer;
begin
  if not (Sender is TPanel) then exit;
  T := Sender as TPanel;
  //Enters the type of operator, which will be used to do the calculation.
  //operatives := T.Caption[1];
  case T.Caption[1] of
    '+' : op := opPlus;
    '-' : op := opMinus;
    '÷' : op := opDivide;
    '×' : op := opMultiply;
  end;
  lbl_Output.Caption := '' ;
  FocusFunctionColor(T);
  pnl_Numbers.Enabled := True;
  resusltMod := resNone;
  NumToVis;
end;

procedure Tform_Kalkulacka.pnl_ButtonLikeDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p : Tpanel;
begin
  //Estetically changes the panel so it looks more like a button, downwards.
  p := Sender as TPanel;
  p.BevelOuter := bvLowered;
end;

procedure Tform_Kalkulacka.pnl_ButtonLikeUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p : TPanel;
begin
  //Estetically changes the panel so it looks more like a button, upwards.
  p := Sender as TPanel;
  p.BevelOuter := bvRaised;
end;

procedure Tform_Kalkulacka.pnl_BckSpcClick(Sender: TObject);
var strOutput : string ;
begin
  //Deletes one number from lbl_Output
  lbl_Output.Caption := Copy(lbl_Output.Caption, 1, Length(lbl_Output.Caption)-1);
  if lbl_Output.Caption = '' then lbl_Output.Caption := '0';
  VisToNum;
  MaxNumber;
  pnl_Numbers.Enabled := True;
end;

procedure Tform_Kalkulacka.pnl_ClearClick(Sender: TObject);
var i : integer;
var T : TPanel;
begin
  //Clears numbers from  variables num1 and num2 and changes it back to mode "0"
  ClearDisplayAndInput;
  FocusFunctionColor(T);
  MaxNumber;
  pnl_Numbers.Enabled := True;
end;

procedure Tform_Kalkulacka.pnl_PlusMinusClick(Sender: TObject);
var q: real;
begin
  q := StrToFloat(lbl_Output.Caption);
  // Multiplies the value in lbl_output by a -1
  lbl_Output.Caption := FloatToStr(-1 * q);
end;

procedure Tform_Kalkulacka.VisToNum;
begin
  //Enters values from lbl_output to num1 and num2
  case op of
    opPlus : num2 := StrToFloat(lbl_Output.Caption);
    opMinus : num2 := StrToFloat(lbl_Output.Caption);
    opDivide : num2 := StrToFloat(lbl_Output.Caption);
    opMultiply : num2 := StrToFloat(lbl_Output.Caption);
    else num1 := StrToFloat(lbl_Output.Caption);
  end;
end;

procedure Tform_Kalkulacka.pnl_DotClick(Sender: TObject);
var strOutput : string;
begin
  strOutput := lbl_Output.Caption;
  //Enters a decimal separator begind number
  if  strOutput = '' then strOutput := '0.';
  lbl_Output.Caption := strOutput;
  if POS ('.', strOutput) <> 0 then exit
  else begin
    strOutput := strOutput + pnl_Dot.Caption;
    lbl_Output.Caption := strOutput;
  end;
end;

procedure Tform_Kalkulacka.pnl_EqualClick(Sender: TObject);
begin
  //Creates a result
  resusltMod := resEqual;
  Calculate;
  NumToVis;
  MaxNumber;
end;
end.
