unit fTestDJMEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uTDJMEdit,
  Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrTestDJMEdit = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    iDecimales: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    lblFecha: TLabel;
    btnSetValueFloat: TButton;
    Button6: TButton;
    Button7: TButton;
    spGetValue: TSpeedButton;
    Bevel1: TBevel;
    btnSymbolDollar: TButton;
    btnSymbolEuro: TButton;
    btnNoSymbol: TButton;
    Label6: TLabel;
    Button11: TButton;
    lblTime: TLabel;
    Button4: TButton;
    lblString: TLabel;
    Button12: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure iDecimalesChange(Sender: TObject);
    procedure btnSetValueFloatClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure spGetValueClick(Sender: TObject);
    procedure btnSymbolDollarClick(Sender: TObject);
    procedure btnSymbolEuroClick(Sender: TObject);
    procedure btnNoSymbolClick(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    { Private declarations }
    myEditFloat:TDJMEdit;
    myEditFloatRoundedEx:TDJMEdit;
    myEditFloatRounded:TDJMEdit;
    myEditDate:TDJMEdit;
    myEditInteger:TDJMEdit;
    myEditTime:TDJMEdit;
    myEditString:TDJMEdit;
  public
    { Public declarations }
  end;

var
  frTestDJMEdit: TfrTestDJMEdit;

implementation

{$R *.dfm}

procedure TfrTestDJMEdit.btnNoSymbolClick(Sender: TObject);
begin
myEditFloat.CurrencySymbol:=' ';
myEditFloatRounded.CurrencySymbol:=' ';
myEditFloatRoundedEx.CurrencySymbol:=' ';
end;

procedure TfrTestDJMEdit.Button11Click(Sender: TObject);
begin
ShowMessage(IntToStr(myEditInteger.ValueInteger));
end;

procedure TfrTestDJMEdit.Button12Click(Sender: TObject);
begin
myEditFloat.Clear;
myEditFloatRounded.Clear;
myEditFloatRoundedEx.Clear;
myEditInteger.Clear;
myEditDate.Clear;
myEditTime.Clear;
end;

procedure TfrTestDJMEdit.Button1Click(Sender: TObject);
begin
ShowMessage(format('%0.10n',[myEditFloat.ValueFloat]));
end;

procedure TfrTestDJMEdit.Button2Click(Sender: TObject);
begin
ShowMessage(format('%0.10n',[myEditFloatRoundedEx.ValueFloat]));
end;

procedure TfrTestDJMEdit.Button3Click(Sender: TObject);
begin
ShowMessage(format('%0.10n',[myEditFloatRounded.ValueFloat]));
end;

procedure TfrTestDJMEdit.Button4Click(Sender: TObject);
begin
if myEditTime.isEmpty then begin
   ShowMessage('tiempo no definido/vacio/nulo');
end
else begin
     ShowMessage(TimeToStr(myEditTime.ValueTime));
end;
end;

procedure TfrTestDJMEdit.btnSetValueFloatClick(Sender: TObject);
begin
myEditFloat.ValueFloat:=12345.12345678;
myEditFloatRoundedEx.ValueFloat:=12345.12345678;
myEditFloatRounded.ValueFloat:=12345.12345678;
end;

procedure TfrTestDJMEdit.Button6Click(Sender: TObject);
begin
myEditDate.ValueDate:=Date;
end;

procedure TfrTestDJMEdit.Button7Click(Sender: TObject);
begin
if myEditDate.isEmpty then begin
   ShowMessage('fecha en blanco');
end
else begin
     ShowMessage(DateToStr(myEditDate.ValueDate));
end;
end;

procedure TfrTestDJMEdit.btnSymbolDollarClick(Sender: TObject);
begin
myEditFloat.CurrencySymbol:='$';
myEditFloatRounded.CurrencySymbol:='$';
myEditFloatRoundedEx.CurrencySymbol:='$';
end;

procedure TfrTestDJMEdit.btnSymbolEuroClick(Sender: TObject);
begin
myEditFloat.CurrencySymbol:='€';
myEditFloatRounded.CurrencySymbol:='€';
myEditFloatRoundedEx.CurrencySymbol:='€';
end;

procedure TfrTestDJMEdit.FormCreate(Sender: TObject);
begin
myEditFloat:=TDJMEdit.Create(self);
myEditFloat.Top:=40;
myEditFloat.left:=176;
myEditFloat.EditType:=etFloat;
myEditFloat.Alignment:=taRightJustify;
myEditFloat.Width:=178;
myEditFloat.Parent:=Self;

myEditFloatRoundedEx:=TDJMEdit.Create(self);
myEditFloatRoundedEx.Top:=80;
myEditFloatRoundedEx.left:=176;
myEditFloatRoundedEx.EditType:=TDJMEditTypes.etFloatRoundedEx;
myEditFloatRoundedEx.Decimals:=iDecimales.Value;
myEditFloatRoundedEx.Width:=178;
myEditFloatRoundedEx.Parent:=Self;

myEditFloatRounded:=TDJMEdit.Create(self);
myEditFloatRounded.Top:=123;
myEditFloatRounded.left:=176;
myEditFloatRounded.EditType:=TDJMEditTypes.etFloatRounded;
myEditFloatRounded.Decimals:=iDecimales.Value;
myEditFloatRounded.Width:=178;
myEditFloatRounded.Parent:=Self;

myEditDate:=TDJMEdit.Create(self);
myEditDate.Top:=lblFecha.top;
myEditDate.left:=438;
myEditDate.EditType:=etDate;
myEditDate.Width:=80;
myEditDate.Parent:=Self;

myEditInteger:=TDJMEdit.Create(self);
myEditInteger.Top:=159;
myEditInteger.left:=176;
myEditInteger.EditType:=etInteger;
myEditInteger.Width:=178;
myEditInteger.Parent:=Self;

myEditTime:=TDJMEdit.Create(self);
myEditTime.Top:=lblTime.top;
myEditTime.left:=176;
myEditTime.EditType:=etTime;
myEditTime.Width:=178;
myEditTime.Parent:=Self;

myEditString:=TDJMEdit.Create(self);
myEditString.Top:=lblString.top;
myEditString.left:=176;
myEditString.EditType:=etString;
myEditString.Width:=178;
myEditString.Parent:=Self;

end;

procedure TfrTestDJMEdit.iDecimalesChange(Sender: TObject);
begin
  myEditFloat.Decimals:=iDecimales.Value;
  myEditFloatRoundedEx.decimals:=iDecimales.Value;
  myEditFloatRounded.Decimals:=iDecimales.value;
end;

procedure TfrTestDJMEdit.spGetValueClick(Sender: TObject);
begin
//prueba para ver q el edit tiene el valor correcto sin perder el foco
//los speedbuttons no ganan foco
ShowMessage(format('%0.10n',[myEditFloat.ValueFloat]));
end;

end.
