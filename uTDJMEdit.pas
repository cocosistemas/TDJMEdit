unit uTDJMEdit;

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  extctrls, Vcl.ComCtrls, buttons;

type
  TDJMEditTypes = (etString, etInteger,

     //respeta todos los decimales que tenga el n�mero. "no le hace nada"
     //n� = 1234,123713279123 -> 1234,123713279123
     //n� = 1234,1237         -> 1234,1237
                etFloat,

     //los redondea a "decimals" decimales. Si el n�mero tiene menos, a�ade los necesarios
     //n� = 1234,123713279123, decimals = 3 -> 1234,124
     //n� = 1234,12,           decimals = 3 -> 1234,120
                etFloatRounded,

     //como etFloatRounded pero si el n� tiene m�s decimales, no lo corta
     //�til para mostrar posibles valores mal grabados en la BD, por ejemplo
	 //n� = 1234,123713279123, decimals = 3 -> 1234,123713279123
     //n� = 1234,12,           decimals = 3 -> 1234,120
                etFloatRoundedEx,

                etDate, etTime);

  TDJMEdit = class(TEdit)
  private
    { Private declarations }
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FOnChange: TNotifyEvent;

    FColorOnFocus: TColor;
    FColorOnNotFocus: TColor;
    FFontColorOnFocus: TColor;
    FFontColorOnNotFocus: TColor;     

    FEditType: TDJMEditTypes;
    /// <summary>
    /// N� de decimales para etFloatRounded y etFloatRoundedEx
    /// </summary>
    FDecimals : Integer;

    /// <summary>
    /// la techa que nos sirve para salir del edit. P.Ej. tab, intro...
    /// </summary>
    FKeyTab: Char;

    /// <summary>
    /// indica si queremos segundos editando tiempo
    /// </summary>
    FShowSecondsInTime: Boolean;

    FValueDate: TDateTime;
    FValueTime: TDateTime;
    FValueInteger: Integer;
    FValueFloat: double;

    /// <summary>
    /// n�meros alineados a la derecha automaticamente
    /// </summary>
    FNumbersAlignRight : Boolean;

    FCurrencySymbol : Char;

    //texto al hacer focus, para poder deshacer con ESC
    sTextAtEnter: string;

    //separadores. No los publicamos, pero lo dejamos preparado
    FThousandSeparator: Char;
    FDecimalSeparator: Char;
    FDateSeparator: Char;
    FTimeSeparator: Char;

    //las cosas de la ventana de selecci�n del calendario
    oCalendarForm:TForm;
    calendario: TMonthCalendar;
    Panel1: TPanel;
    BTAceptar: TButton;
    btCancelar: TButton;

    FiAssociatedValue : Integer;
    FsTableName : string;
    FsFieldName : string;

    FInsideHelpActive: Boolean;
    FInsideHelpText  : String;
    FInsideHelpFont  : TFont;

    procedure EMSetReadOnly(var msg: TMessage); message EM_SETREADONLY;

    procedure SetInsideHelpActive(const Value: Boolean);
    procedure SetInsideHelpText(const Value: String);
    procedure SetInsideHelpFont(const Value: TFont);
    procedure InsideHelpFontChange(Sender: TObject);

    procedure setDecimals(const Value: integer);

    procedure FormCalendarFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCalendarFormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCalendarBTAceptarClick(Sender: TObject);
    procedure FormCalendarbtCancelarClick(Sender: TObject);
    procedure SetCurrencySymbol(const Value: char);
    procedure SetDecimalSeparator(const Value: char);
    procedure SetThousandSeparator(const Value: char);
    function ValidateNumbers(var sError:string):boolean;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

  protected
    {Protected declarations}
    procedure FormatDate(lCambiatexto: boolean; lConAviso: boolean);
    procedure FormatTime;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetEditType(value: TDJMEditTypes);
    /// <summary>
    /// Realiza el formato de n�meros (aplica separadores de cientos, miles, etc)
    /// </summary>
    procedure FormatNumber;
    /// <summary>
    /// quita el formato de puntuaci�n de un string
    /// </summary>
    function DeleteFormat(s:string):string;
    procedure CreateCalendarWindow;
    procedure SetInteger(VInteger: Integer);
    procedure SetFloat(VFloat: double);
    procedure SetDate(dFecha: TDatetime);
  public
    destructor Destroy; override;
    procedure KeyPress(var Key: Char); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Change; override;
    procedure Loaded; override;
    constructor Create(AOwner: TComponent); override;
    function uDat_DateToStr(dFecha: TDateTime): string;
    function uDat_StrToDate(sFecha: string): TDateTime;
    /// <summary>
    /// para etInteger, un helper para devolver el valor como string
    /// </summary>
    function valueIntegerAsStr: string;
    /// <summary>
    /// para etString, dice si est� vacio
    /// para etDate, dice si es una fecha nula, vacia
    /// </summary>
    function isEmpty: Boolean;
    function MyFormatFloat(sValue: string; iMinimoDecimales: Integer = 0): string;
    procedure Clear; override;
  published
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property ColorOnFocus: TColor read FColorOnFocus write FColorOnFocus;
    property ColorOnNotFocus: TColor read FColorOnNotFocus write FColorOnNotFocus;
    property FontColorOnFocus: TColor read FFontColorOnFocus write FFontColorOnFocus;
    property FontColorOnNotFocus: TColor read FFontColorOnNotFocus write FFontColorOnNotFocus;
    property EditType: TDJMEditTypes read FEditType write SetEditType;
    property EditKeyByTab: Char read FKeyTab write FKeyTab;
    property ValueFloat: double read FValueFloat write SetFloat;
    property ValueInteger: Integer read FValueInteger write SetInteger;
    property ValueDate: TDateTime read FValueDate write SetDate;
    property ValueTime: TDateTime read FValueTime write FValueTime;
    property TimeSeconds: Boolean read FShowSecondsInTime write FShowSecondsInTime;
    property NumbersAlignedRight : boolean read FNumbersAlignRight write FNumbersAlignRight;
    property DecimalSeparator : char read FDecimalSeparator write SetDecimalSeparator;
    property ThousandSeparator : char read FThousandSeparator write SetThousandSeparator;
    property CurrencySymbol : char read FCurrencySymbol write SetCurrencySymbol;
    property Decimals : integer read FDecimals write setDecimals;
    /// <summary>
    /// por si necesitamos asociar un n� entero a este edit (ejemplo, nombre, n� agenda)
    /// </summary>
    property iAssociatedValue:integer read FiAssociatedValue write FiAssociatedValue;
    /// <summary>
    /// posible tabla asociada al edit
    /// </summary>
    property TableName:string read FsTableName write FsTableName;
    /// <summary>
    /// posible campo asociado al edit
    /// </summary>
    property FieldName:string read FsFieldName write FsFieldName;

    /// <summary>
    /// Permite definir el texto de ayuda.
    /// </summary>
    property InsideHelpText:String read FInsideHelpText write SetInsideHelpText;
    /// <summary>
    /// Permite activar la caracter�stica de ayuda interior.
    /// </summary>
    property InsideHelpActive:Boolean read FInsideHelpActive write SetInsideHelpActive;
    /// <summary>
    /// Permite definir la letra de la ayuda interior
    /// </summary>
    property InsideHelpFont : TFont read FInsideHelpFont write SetInsideHelpFont;
  end;

const
DJMEditTypeFloats : set of TDJMEditTypes = [etFloat,etFloatRounded, etFloatRoundedEx];
DJMEditTypeNumbers : set of TDJMEditTypes = [etInteger,etFloat,etFloatRounded, etFloatRoundedEx];

procedure Register;

implementation

procedure TDJMEdit.SetCurrencySymbol(const Value: char);
begin
  FCurrencySymbol := Value;
  if (edittype in DJMEditTypeFloats) then begin
     FormatNumber;
  end;
end;

procedure TDJMEdit.SetDecimalSeparator(const Value: char);
begin
  FDecimalSeparator := Value;
  if (edittype in DJMEditTypeFloats) then begin
     FormatNumber;
  end;
end;

procedure TDJMEdit.SetThousandSeparator(const Value: char);
begin
  FThousandSeparator := Value;
  if (edittype in DJMEditTypeNumbers) then begin
     FormatNumber;
  end;
end;

procedure TDJMEdit.setDate;
begin
  text := uDat_Datetostr(dFecha);
  FvalueDate := dFecha;
end;

procedure TDJMEdit.setDecimals(const Value: integer);
begin
  if FDecimals>15 then Exit; //maxima precision del tipo double
  
  FDecimals := Value;
  if (edittype in DJMEditTypeNumbers) then begin
     FormatNumber;
  end;
end;

procedure TDJMEdit.loaded;
begin
  inherited;
end;

procedure TDJMEdit.EmSetreadonly;
begin
  inherited;
{ TODO : limpiar este EMSetReadOnly. Dejarlo en comentarios, q es util }
//si es readonly no queremos que al pulsar f2 salga el calendario
//esta aqui, en el mensaje pq podemos cambiar readonly sin cambiar el tipoedit
//y podemos cambiar el tipoedit sin cambiar el readonly
  if FEditType = etDate then
    hint := '';
end;

procedure TDJMEdit.Clear;
begin
  inherited;
  if (edittype in DJMEditTypeNumbers) then begin
     ValueFloat:=0;
     ValueInteger:=0;
     FormatNumber;
  end;
  if (EditType = etDate) then begin
     ValueDate:=0;
  end;
  if (EditType = etTime) then begin
     ValueTime:=0;
  end;
  FiAssociatedValue:=0;
end;

constructor TDJMEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ColorOnFocus := clSkyBlue; //$00FF8000;
  ColorOnNotFocus := clWhite;
  Color := clWhite;
  FontColorOnFocus := clBlack; //clWhite;
  FontColorOnNotFocus := clBlack;

  FEditType := etString;
  FNumbersAlignRight := True;
  FDecimals:=3;
  Text:='';

  FCurrencySymbol:='�';

  FKeyTab := #13;        //#9
  FValueInteger := 0;
  FValueFloat := 0;
  sTextAtEnter := '';

  FDecimalSeparator := FormatSettings.DecimalSeparator;
  FThousandSeparator := FormatSettings.ThousandSeparator;
  FDateSeparator := FormatSettings.DateSeparator;
  FTimeSeparator := FormatSettings.TimeSeparator;

  FShowSecondsInTime := False;
  FValueDate := 0;
  FValueTime := Time;

  Self.FInsideHelpActive := False;
  Self.FInsideHelpText   := Self.FInsideHelpText;

  FiAssociatedValue   := 0;
  FsTableName:='';
  FsFieldName:='';

  FInsideHelpFont        := TFont.Create;
  FInsideHelpFont.Name   := 'Arial';
  FInsideHelpFont.Color  := clGray;

  FInsideHelpFont.OnChange := InsideHelpFontChange;
end;

procedure TDJMEdit.CreateCalendarWindow;
begin
oCalendarForm:=TForm.Create(nil);
calendario := TMonthCalendar.Create(oCalendarForm);
calendario.Date := Date;
Panel1 := TPanel.Create(oCalendarForm);
BTAceptar := TButton.Create(oCalendarForm);
btCancelar := TButton.Create(oCalendarForm);

    oCalendarForm.Name := 'frDJMCalendar';
    oCalendarForm.Left := 36;
    oCalendarForm.Top := 34;
    oCalendarForm.Position:=poScreenCenter;
    oCalendarForm.BorderStyle := bsSingle;
    oCalendarForm.Caption := 'Seleccion de fecha';
    oCalendarForm.ClientHeight := 522;
    oCalendarForm.ClientWidth := 745;
    oCalendarForm.Color := clBtnFace;
    oCalendarForm.KeyPreview := True;
    //oCalendarForm.OldCreateOrder := False;
    oCalendarForm.OnClose := FormCalendarFormClose;
    oCalendarForm.OnKeyDown := FormCalendarFormKeyDown;
    oCalendarForm.PixelsPerInch := 96;

  with calendario do
  begin
    Name := 'calendario';
    Parent := oCalendarForm;
    Left := 6;
    Top := 0;
    Width := 733;
    Height := 461;
    Date := date;
    MaxSelectRange := 0;
    ParentFont := False;
    TabOrder := 0;
    WeekNumbers := True;
  end;
  with Panel1 do
  begin
    Name := 'Panel1';
    Caption:='';
    Parent := oCalendarForm;
    Left := 0;
    Top := 472;
    Width := 745;
    Height := 50;
    Align := alBottom;
    BevelInner := bvLowered;
    TabOrder := 1;
  end;
  with BTAceptar do
  begin
    Name := 'BTAceptar';
    Parent := Panel1;
    Left := 560;
    Top := 4;
    Width := 79;
    Height := 39;
    Hint := 'F5 Aceptar';
    Caption := 'Aceptar';
    ParentShowHint := False;
    ShowHint := True;
    OnClick := FormCalendarBTAceptarClick;
  end;
  with btCancelar do
  begin
    Name := 'btCancelar';
    Parent := Panel1;
    Cancel := True;
    Left := 664;
    Top := 4;
    Width := 73;
    Height := 39;
    Hint := 'F8 cancelar';
    Caption := 'Cancelar';
    ParentShowHint := False;
    ShowHint := True;
    OnClick := FormCalendarbtCancelarClick;
  end;
end;

procedure TDJMEdit.SetEditType(value: TDJMEditTypes);
begin
  FEditType := value;
  if (FEditType = etDate) and (not readonly) then begin
  { TODO : revisar el hint para fechas }
    hint := 'F2-Calendario, F3-Hoy';
    showhint := true;
  end
  else begin
    { TODO : hacer un auto-hint moneda o algo as� }
    {
    if (FEditType = etFloat) then begin
      //hint := 'Euros';
      //showhint := true;
    end
    else begin
      //hint := FHintTipo;
      //showhint := true;
    end;
    }
  end;
  if (edittype in DJMEditTypeNumbers) then begin
     if (FNumbersAlignRight) then begin
        self.Alignment := taRightJustify;
     end
     else begin
          self.Alignment := taRightJustify;
     end;
     self.ValueFloat:=0;
     self.ValueInteger:=0;
  end;
end;

function TDJMEdit.uDat_DateToStr(dFecha: TDateTime): string;
begin
  //consideramos 0 como nuestra fecha nula, TDateTime es un double y no tiene valor nulo
  if dFecha = 0 then
    result := ''
  else
    result := datetostr(dFecha);
end;

function TDJMEdit.uDat_StrToDate(sFecha: string): TDateTime;
begin
  if trim(sFecha) = '' then
    result := 0
  else
    result := strtodate(sFecha);
end;

procedure TDJMEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (edittype = etDate) and (not readonly) then begin
    if Key = VK_F2 then begin
      CreateCalendarWindow;
      oCalendarForm.showmodal;
    end;
    if Key = VK_F3 then
      text := datetostr(date);
  end
end;

procedure TDJMEdit.KeyPress(var Key: Char);
var
  FEditTemp: TCustomForm;
  lProcesado:Boolean;
begin
  lProcesado:=False;  //flag para evitar utilizar exit
  if Key = EditKeyByTab then begin
    FEditTemp := GetParentForm(Self);
    SendMessage(FEditTemp.Handle, WM_NEXTDLGCTL, 0, 0);
    Key := #0;
    lProcesado:=True;
  end;

  if not lProcesado then begin
      // Si se ha pulsado escape, se anulan los cambios
      if Key = #27 then begin
        Text := sTextAtEnter;
        Key := #15; //caracter 'nulo', NAK
        lProcesado:=True;
      end;
  end;

  if not lProcesado then begin
     if Ord(key) = 1 then begin //ctrl-a, seleccionar todo
        lProcesado:=True;
     end;
  end;

  if not lProcesado then begin
      if Ord(key) = 22 then begin //ctrl-v
         if (edittype in DJMEditTypeNumbers) then begin
            self.Clear;  //al pegar un n�, borramos autom�ticamente el n� existente asi el usuario no tiene q borrarlo con el raton
         end;
         lProcesado:=True;
      end;
  end;

  if not lProcesado then begin
      // Caracteres permitidos en funci�n del tipo
      case EditType of
        //etString: todos
        etInteger:  begin
            if (not (CharInSet(Key,['0'..'9', '-', #8, #13]))) or
               (Key = #32) or ((Key = '-') and (Pos('-', Text) > 0)) then begin
               Key := #15;
            end;
          end;

        etFloat, etFloatRounded, etFloatRoundedEx: begin
            if (not (CharInSet(Key,['0'..'9', FThousandSeparator, FDecimalSeparator, '-', #8, #13]))) or
               (Key = #32) or ((Key = '-') and (Pos('-', Text) > 0)) then begin
               Key := #15;
            end;

            //pasamos el , o el . a decimal separator
            if (Key = FDecimalSeparator) or (Key = FThousandSeparator) then begin
              if (Pos(FDecimalSeparator, Text) > 0) or (Pos(FDecimalSeparator, Text) > 0) then
                Key := #15
              else
                Key := FDecimalSeparator;
            end;
          end;

        etDate, etTime:
          if not CharInSet(Key,['0'..'9', #8, #13]) then begin
             Key := #15;
          end;
      end;
  end;

  if Key <> #0 then
    inherited KeyPress(Key);
end;

function TDJMEdit.DeleteFormat(s: string): string;
var
i : Integer;
sAux:string;
begin
   if EditType=etString then begin
      Result:=s;
   end
   else begin
        sAux:='';
        //quitamos todo lo q no sea digitos, -, etc
        for i := 1 to Length(s) do begin
            if CharInSet(Text[i],['0'..'9', FDecimalSeparator, '-']) then begin
               sAux := sAux + Text[i];
            end;
        end;
        result := sAux;
   end;
end;

destructor TDJMEdit.Destroy;
begin
  FInsideHelpFont.Free;
  inherited;
end;

procedure TDJMEdit.DoEnter;
begin

  sTextAtEnter := Text;

  //quitamos formato
  Text:=DeleteFormat(text);

  //al hacer focus si tenemos el 0 molesta, siempre habria q borrarlo para teclear el n�
  if (EditType = etFloat ) and (trim(Text)='0') then
  begin
     text:='';
  end;


  Color := ColorOnFocus;
  Font.Color := FontColorOnFocus;

  if EditType = etDate then
    MaxLength := 10;
  if EditType = etTime then
    if TimeSeconds then
      MaxLength := 8
    else
      MaxLength := 5;

  if Assigned(FOnEnter) then
    FOnEnter(Self);
end;

procedure TDJMEdit.DoExit;
begin
  Color := ColorOnNotFocus;
  Font.Color := FontColorOnNotFocus;

 //si teclean el signo negativo, lo ponemos al principio
  if (edittype in DJMEditTypeNumbers) and (Pos('-', Text) > 1) then begin
    if Length(Text) = Pos('-', Text) then
      Text := '-' + Copy(Text, 1, Pos('-', Text) - 1)
    else
      Text := '-' + Copy(Text, 1, Pos('-', Text) - 1) + Copy(Text, Pos('-', Text) + 1, Length(Text) - Pos('-', Text));
  end;

//n�mero, si nulo -> 0
  if (edittype in DJMEditTypeFloats) then begin
    if trim(text) = '' then begin
      setFloat(0);
    end;
  end;

if (editType = etInteger) then begin
    if trim(text) = '' then begin
      SetInteger(0);
    end;
  end;

//fechas
  if EditType = etDate then begin
    FormatDate(true, true);
  end;

//tiempo
  if EditType = etTime then begin
    FormatTime;
  end;

//formato de floats
if (edittype in DJMEditTypeNumbers) then begin
   FormatNumber;
end;

  if Assigned(FOnExit) then
    FOnExit(Self);
end;

procedure TDJMEdit.FormatNumber;
var
myFormatSettings:TFormatSettings;
begin
  if (edittype in DJMEditTypeFloats) then begin
    if trim(text) <> '' then begin
        try
          Text:=DeleteFormat(Text);
          if (EditType = etFloat) then begin
             Text:=MyFormatFloat(text);
          end;
          if (EditType = etFloatRoundedEx) then begin
             Text:=MyFormatFloat(text, FDecimals);
          end;
          if (EditType = etFloatRounded) then begin
             myFormatSettings.DecimalSeparator:=FDecimalSeparator;
             myFormatSettings.ThousandSeparator:=FThousandSeparator;
             Text:=format('%0.'+trim(inttostr(FDecimals))+'n',[StrToFloat(text)], myFormatSettings);
          end;
        except
        end;
    end
    else begin
         text := '0';
    end;

    if (Trim(FCurrencySymbol)<>'') then begin
       //onChangeEvt := self.OnChange;
       //self.OnChange:=nil;
       Text:=text+' '+FCurrencySymbol;
       //self.OnChange:=OnChangeEvt;
    end;
  end;

//formato de integers
  if (edittype = etInteger) then begin
    if trim(text) <> '' then begin
      try
        text := MyFormatFloat(text);
      except
      end;
    end
    else
      text := '0';
  end;

end;

procedure TDJMEdit.Change;
var
sError:string;
begin
  if not ValidateNumbers(sError) then begin
     Beep;
     SetFocus;
  end;

 //MODIF 18/01/1999:para que al salirse a un speedbutton por ejemplo, ya tenga la fecha correcta
  if (edittype = etDate) then begin
    if trim(text) = '' then
      Fvaluedate := 0
    else
      formatdate(false, false);
  end;

  if Assigned(FOnChange) then begin
    FOnChange(Self);
  end;
end;

procedure TDJMEdit.SetInteger(VInteger: Integer);
begin
  if EditType = etInteger then begin
    FValueInteger:=VInteger;
    Text:=IntToStr(FValueInteger);
    FormatNumber;
  end;
end;

procedure TDJMEdit.SetFloat(VFloat: double);
var
myFormatSettings:TFormatSettings;
begin
  if (edittype in DJMEditTypeFloats) then begin
    Fvaluefloat := VFloat;
    //OJO! el floattostr corta a 15 caracteres, q es la m�xima precisi�n del tipo double
    //0.1234567890123456789 lo deja como 0.123456789012346
    myFormatSettings.DecimalSeparator:=FDecimalSeparator;
    myFormatSettings.ThousandSeparator:=FThousandSeparator;
    Text:=FloatToStr(FValueFloat, myFormatSettings) ;
    //Text:=Format('%0.15n',[VFloat]); //esto hace que 12,123 lo deje como 12,129999999
    FormatNumber;
  end;
end;

procedure TDJMEdit.FormatDate;
var
  Temp, vDate, vMonth, vYear: string;
  dDate: TDateTime;
  ilength: Integer;
  myFormatSettings:TFormatSettings;
begin
  Temp := '';
  vDate := FormatDateTime('dd' + FDateSeparator+ 'mm' + FDateSeparator+ 'yyyy', Date);
  vMonth := Copy(vDate, 4, 2);
  vYear := Copy(vDate, 7, 4);
 // Quitar separador de fecha si existe
  if Length(Text) > 0 then
    for ilength := 1 to Length(Text) do
      if CharInSet(Text[ilength],['0'..'9']) then begin
         Temp := Temp + Text[ilength];
      end;
 // Completar la fecha con separadores
 { TODO : permitir formato ddmmyyyy y mmddyyyy }
  ilength := Length(Temp);
  case ilength of
    0:
      Temp := '';
    1:
      Temp := '0' + Temp[1] + FDateSeparator+ vMonth + FDateSeparator+ vYear;
    2:
      Temp := Temp + FDateSeparator+ vMonth + FDateSeparator+ vYear;
    3:
      Temp := Copy(Temp, 1, 2) + FDateSeparator+ '0' + Temp[3] + FDateSeparator+ vYear;
    4:
      Temp := Copy(Temp, 1, 2) + FDateSeparator+ Copy(Temp, 3, 2) + FDateSeparator+ vYear;
    5:
      Temp := Copy(Temp, 1, 2) + FDateSeparator+ Copy(Temp, 3, 2) + FDateSeparator+ Copy(vYear, 1, 3) + Temp[5];
    6:
      Temp := Copy(Temp, 1, 2) + FDateSeparator+ Copy(Temp, 3, 2) + FDateSeparator+ Copy(vYear, 1, 2) + Copy(Temp, 5, 2);
    7:
      Temp := Copy(Temp, 1, 2) + FDateSeparator+ Copy(Temp, 3, 2) + FDateSeparator+ vYear[1] + Copy(Temp, 5, 3);
    8, 9, 10:
      Temp := Copy(Temp, 1, 2) + FDateSeparator+ Copy(Temp, 3, 2) + FDateSeparator+ Copy(Temp, 5, 4);
  end;

  //validamos la fecha
  if Trim(text)<>'' then begin
      myFormatSettings.ShortDateFormat:='dd'+FDateSeparator+'mm'+FDateSeparator+'yyyy';
      myFormatSettings.DateSeparator:=FDateSeparator;
      if not TryStrToDate(Temp, dDate, myFormatSettings) then begin
        if lConAviso then begin //esto es porque las fechas son incorrectas hasta q terminamos de teclearlas
           beep;
           self.Undo;
        end;
        FValueDate := 0;
        FValueFloat := 0;
        FValueInteger := 0;
        setfocus;
        Exit;
      end;
  end;
  if lCambiaTexto then begin
     Text := Temp;
  end;
  FValueDate := udat_StrToDate(Temp);
  FValueFloat := FValueDate;
  FValueInteger := Trunc(FValueDate);
  Self.ClearUndo;
end;

function TDJMEdit.MyFormatFloat(sValue: string; iMinimoDecimales: Integer): string;
var
  sAux: string;
  i: integer;
  lDec: boolean;
  iCuantos: integer;
  sOut: string;
  iAux2: Integer;
begin
//a�ade signos de puntuaci�n al n�mero representado en sValue.
//si iMinimoDecimales<>0 -> a�ade los decimales necesarios hasta el m�nimo
//se supone que el signo - est� en su sitio
  sAux := Trim(sValue);
  sOut := '';
  if trim(sAux) = '' then begin
    sOut := '0';
  end
  else begin
    if sAux = '0' then begin
      sOut := '0';
    end
    else begin
      lDec := (pos(FDecimalSeparator, sAux) <> 0);
      iCuantos := 0;
      //DE DERECHA A IZQUIERDA, vamos a�adiendo los signos de puntuacion
      for i := length(sAux) downto 1 do begin
        if sAux[i] = FDecimalSeparator then begin
          //ya no hay decimales
          lDec := false;
          //Completamos decimales con cero hasta el minimo
          for iAux2 := Length(sOut) + 1 to iMinimoDecimales do begin
            sOut := sOut + '0';
          end;
        end
        else begin
             if not lDec then begin
                inc(iCuantos);
             end;
        end;
        sOut := sAux[i] + sOut;
        if (iCuantos = 3) and (i <> 1) then begin
          iCuantos := 0;
          sOut := FThousandSeparator + sOut;
        end;
      end;
    end;
  end;
//el caso especial -,123456
if trim(sOut) <> '' then begin
  if length(sOut) > 2 then begin
    if (sOut[1] = '-') and (sOut[2] = FDecimalSeparator) then
      delete(sOut, 2, 1);
  end;
end;

//el caso especial .123
if trim(sOut) <> '' then begin
  if length(sOut) > 1 then begin
    if (sOut[1] = FDecimalSeparator) then
      sOut:='0'+sOut;
  end;
end;

//no tiene decimales y nos los han pedido
if (Pos(FDecimalSeparator, sOut) = 0) and (iMinimoDecimales <> 0) then begin
  sOut := sOut + FDecimalSeparator;
  for iAux2 := 1 to iMinimoDecimales do begin
    sOut := sOut + '0';
  end;
end;
  result := sOut;
end;

function TDJMEdit.ValidateNumbers;
var
  TxtConvert: string;
  mDummy: Double;
  iDummy: Integer;
  myFormatSettings:TFormatSettings;
begin
  //OutputDebugString('OnChange');
  Result:=True;  sError:='';

  if (csLoading in ComponentState) then begin
     Exit;
  end;

  //comprobaci�n de que vamos teniendo un n� correcto. Las probabilidades son muy pocas
  //puesto que en el keypress lo tenemos todo muy limitado, pero pueden hacernos ctrl-v y
  //pegarnos cualquier cosa. Adem�s est�n los rangos m�ximos/m�nimos de enteros, etc

  //para deshacer el onchange utilizamos clearundo/undo :)

  if (EditType in DJMEditTypeNumbers) and (Length(Text) > 0) then
  begin
    // Si solo tenemos el signo negativo, dar�a error
    if (Pos('-', Text) = 1) and (Length(Text) = 1) then
    begin
       Exit;
    end;
    FValueFloat := 0;
    FValueInteger := 0;
    TxtConvert := DeleteFormat(Text);
    //signo negativo al principio, est� donde est�
    if (Pos('-', TxtConvert) > 1) then
    begin
      if Length(TxtConvert) = Pos('-', TxtConvert) then
        TxtConvert := '-' + Copy(TxtConvert, 1, Pos('-', TxtConvert) - 1)
      else
        TxtConvert := '-' + Copy(TxtConvert, 1, Pos('-', TxtConvert) - 1) + Copy(TxtConvert, Pos('-', TxtConvert) + 1, Length(TxtConvert) - Pos('-', TxtConvert));
    end;
    if EditType = etInteger then
    begin
      if not TryStrToInt(TxtConvert, iDummy) then
      begin
        Result:=False;
        sError:='N�mero entero incorrecto';
        self.Undo;  //deshacemos cambios desde el clearundo
      end
      else
      begin
        if Assigned(self.Parent) then begin
           self.ClearUndo; //desharemos cambios a partir de aqu�, �ltima vez q fue correcto
        end;
        FValueInteger := iDummy;
        FValueFloat := FValueInteger;
      end;
    end;
    if (edittype in DJMEditTypeFloats) then begin
      myFormatSettings.DecimalSeparator:=FDecimalSeparator;
      myFormatSettings.ThousandSeparator:=FThousandSeparator;
      if not TryStrToFloat(TxtConvert, mDummy, myFormatSettings) then
      begin
        Result:=False;
        sError:='N�mero incorrecto';
        self.Undo; //deshacemos cambios desde el clearundo
      end
      else
      begin
        if Assigned(self.Parent) then begin
           self.ClearUndo; //desharemos cambios a partir de aqu�
        end;
        FValueFloat := mDummy;
        FValueInteger := Trunc(mDummy);
      end;
    end;
  end;
end;

procedure TDJMEdit.FormatTime;
var
  Temp, vTime, vMin, vSec, MskTime: string;
  iLength: Integer;
begin
  Temp := '';
  MskTime := '00' + FTimeSeparator + '00' + FTimeSeparator + '00';
  vTime := FormatDateTime('hh'+FTimeSeparator+'mm'+FTimeSeparator+'ss', Time);
  vMin := Copy(vTime, 4, 2);
  vSec := Copy(vTime, 7, 2);

  // Quitar separadores si los hay
  if Length(Text) > 0 then begin
    for iLength := 1 to Length(Text) do
      if CharInSet(Text[iLength],['0'..'9']) then begin
        Temp := Temp + Text[iLength];
      end;
  end;

 // Formatear el tiempo
  iLength := Length(Temp);
  if TimeSeconds then begin // Con segundos
    case iLength of
      0:
        Temp := vTime;
      1:
        Temp := '0' + Temp[1] + Copy(MskTime, 3, 6);
      2:
        Temp := Temp + Copy(MskTime, 3, 6);
      3:
        Temp := Copy(Temp, 1, 2) + FTimeSeparator + '0' + Temp[3] + Copy(MskTime, 6, 3);
      4:
        Temp := Copy(Temp, 1, 2) + FTimeSeparator + Copy(Temp, 3, 2) + Copy(MskTime, 6, 3);
      5:
        Temp := Copy(Temp, 1, 2) + FTimeSeparator + Copy(Temp, 3, 2) + FTimeSeparator + '0' + Temp[5];
      6, 7, 8:
        Temp := Copy(Temp, 1, 2) + FTimeSeparator + Copy(Temp, 3, 2) + FTimeSeparator + Copy(Temp, 5, 2);
    end;
  end
  else begin // Sin segundos
    case iLength of
      0:
        Temp := vTime;
      1:
        Temp := '0' + Temp[1] + Copy(MskTime, 3, 3);
      2:
        Temp := Temp + Copy(MskTime, 3, 3);
      3:
        Temp := Copy(Temp, 1, 2) + FTimeSeparator + '0' + Temp[3];
      4, 5:
        Temp := Copy(Temp, 1, 2) + FTimeSeparator + Copy(Temp, 3, 2);
    end;
  end;
 //DJM 05/11/2003, si en blanco, no ponemos tiempo por defecto
  if trim(text) <> '' then begin
    try
      StrToTime(Temp);
    except
      ShowMessage('Hora/Tiempo incorrectos');
      if TimeSeconds then
        Text := vTime
      else
        Text := Copy(vTime, 1, 5);
      FValueTime := Time;
      FValueFloat := ValueTime;
      Exit;
    end;
    Text := Temp;
    FValueTime := StrToTime(Temp);
    FValueFloat := ValueTime;
  end
  else begin
    text := '';
     //valuetime:=strtotime('');
    FValuefloat := 0;
  end;
end;

procedure TDJMEdit.FormCalendarBTAceptarClick(Sender: TObject);
begin
self.text:=datetostr(calendario.date);
oCalendarForm.modalresult:=mrOk;
end;

procedure TDJMEdit.FormCalendarbtCancelarClick(Sender: TObject);
begin
oCalendarForm.modalResult:=mrCancel;
end;

procedure TDJMEdit.FormCalendarFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=caFree;
end;

procedure TDJMEdit.FormCalendarFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_F5
then FormCalendarbtAceptarclick(sender);
if key=VK_F8
then FormCalendarbtCancelarclick(sender);
end;

procedure TDJMEdit.InsideHelpFontChange(Sender: TObject);
begin

end;

function TDJMEdit.isEmpty: Boolean;
begin
  if (EditType = etDate) then begin
     Result:= (ValueDate = 0);
  end
  else begin
       //para floats, no consideramos que '0' sea empty.
       //para time, no tecleado
       Result := Trim(self.Text) = '';
  end;
end;

procedure Register;
begin
  RegisterComponents('DJM', [TDJMEdit]);
end;

function TDJMEdit.valueIntegerAsStr;
begin
  Result := IntToStr(self.ValueInteger);
end;

procedure TDJMEdit.SetInsideHelpActive(const Value: Boolean);
begin
Self.FInsideHelpActive := Value;
Self.Repaint;
end;

procedure TDJMEdit.SetInsideHelpFont(const Value: TFont);
begin
FInsideHelpFont.Assign(Value);
Repaint;
end;

procedure TDJMEdit.SetInsideHelpText(const Value: String);
begin
 Self.FInsideHelpText := Value;
 Repaint;
end;

procedure TDJMEdit.WMPaint(var Message: TWMPaint);
var
  MCanvas: TControlCanvas;
begin
  if (Self.Text <> '') or (not Self.FInsideHelpActive) then begin
    inherited;
    Exit;
  end;

  inherited;

  MCanvas := TControlCanvas.Create;

  try
    MCanvas.Control := Self;
    MCanvas.Brush.Color := Self.Color;
    MCanvas.Font := Self.FInsideHelpFont;
    MCanvas.TextOut(2,2, Self.FInsideHelpText);
  finally
    MCanvas.Free;
  end;
end;

begin
end.

