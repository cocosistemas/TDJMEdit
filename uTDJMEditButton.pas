unit uTDJMEditButton;
{
Ha dado mucha lata con el redraw, hay que redibujar el boton en el change,
ajustar el margen del edit... incluso hacia efectos raros al seleccionar
el texto hacia la izquierda... por eso hay unos cuantos fbutton.refresh
}
interface

uses
  SysUtils, WinTypes, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, uTDJMEdit;
  {$R uTDJMEditbutton.res}

type
  TButtonGlyphKind = (gkSearch,gkSave,gkFile,gkAdd,gkRemove,gkHome,gkOpen,gkCheck,
   gkEllipsis,gkMail,gkTime,gkDate,gkCustom,gkHelp,gkSilly,gkCancel);
  TButtonLayout = (boGlyphLeft, boGlyphRight);
  TButtonCursor = (cuHandPoint,cuArrow);
  TNumGlyphs = 1..4;
  TDJMEditButton = class(TDJMEdit)
   private
    FButtonGlyphKind:TButtonGlyphKind;
    FButton:TSpeedButton;
    FButtonCursor: TButtonCursor;
    FButtonLayout:TButtonLayout;
    FButtonWidth:integer;
    procedure SetButtonGlyphKind(value:TButtonGlyphKind);
    procedure SetButtonLayout(value:TButtonLayout);
    procedure SetButtonCursor(value:TButtonCursor);
    procedure SetFlat(Value: boolean);
    function  GetFlat:boolean;
    function  GetBTransparent:boolean;
    procedure SetBTransparent(Value: boolean);
    function  GetBEnabled:boolean;
    procedure SetBEnabled(Value: boolean);
    procedure SetCaption(const Value: String);
    function  GetCaption:String;
    procedure SetButtonHint(const Value: String);
    function  GetButtonHint:String;
    procedure SetGlyph(const Value: TBitmap);
    function  GetGlyph:TBitmap;
    procedure SetButtonWidth(ASirina:integer);
    function GetNumGlyphs: TNumGlyphs;
    procedure SetNumGlyphs(Value: TNumGlyphs);
    procedure CmEnabledChanged(var Message: TWmNoParams); message CM_ENABLEDCHANGED;
    procedure CmParentColorChanged(var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure CmVisibleChanged(var Message: TWmNoParams); message CM_VISIBLECHANGED;
    procedure CmParentFontChanged(var Message: TWMNoParams); message CM_FONTCHANGED;
    function GetOnButtonClick: TNotifyEvent;
    procedure SetOnButtonClick(Value: TNotifyEvent);
  protected
    { Protected declarations }
    procedure UpdateFormatRect;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure CreateHandle; override;
    procedure Change;override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
   property ButtonGlyphKind:TButtonGlyphKind read FButtonGlyphKind write SetButtonGlyphKind default gkCustom;
   property ButtonLayout:TButtonLayout read FButtonLayout write SetButtonLayout default boGlyphLeft;
   property ButtonFlat:boolean read GetFlat write SetFlat default False;
   property ButtonHint:String read GetButtonHint write SetButtonHint;
   property ButtonCursor:TButtonCursor read FButtonCursor write SetButtonCursor default cuHandPoint;
   property OnClickButton: TNotifyEvent read GetOnButtonClick write SetOnButtonClick;
   property ButtonGlyph:TBitmap read GetGlyph write SetGlyph;
   property ButtonWidth:integer read FButtonWidth write SetButtonWidth default 20;
   property ButtonNumGlyphs: TNumGlyphs read GetNumGlyphs write SetNumGlyphs default 1;
   property ButtonCaption:String read GetCaption write SetCaption;
   property ButtonTransparent:boolean read GetBTransparent write SetBTransparent;
   property ButtonEnabled:boolean read GetBEnabled write SetBEnabled;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DJM', [TDJMEditButton]);
end;  { Register }

constructor TDJMEditButton.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
  FButtonWidth:=20;
  FButtonCursor:= cuArrow;
  FButton := TSpeedButton.Create(Self); //el owner (self) se va a encargar de destruirlo
  FButton.Parent:=self;
  FButton.width:=FButtonWidth;
  FButton.top:=top;
  Fbutton.Height :=Height-1;
  Fbutton.Left := Width-FButton.width-1;
  FButton.cursor:=crArrow;
  FButton.ShowHint:=true;
  FButton.Flat:=False;
  FButtonLayout:=boGlyphLeft;
  FButtonGlyphKind:=gkCustom;
  //updateformatrect;  //DJM 11.03.2001
end;

procedure TDJMEditButton.CreateHandle;
begin
  inherited CreateHandle;
  //cuando windows cree el control, tenemos que decirle que las coordenadas son otras
  UpdateFormatRect;
end;


procedure TDJMEditButton.UpdateFormatRect;
var
  Rect: TRect;
begin
  Rect := ClientRect;
  Dec(Rect.Right, FButton.Width);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Rect));
end;

procedure TDJMEditButton.WMSize(var Msg: TWMSize);
begin
  inherited;
  FButton.Width := FButton.Height;
  Fbutton.Left := Width-FButton.width-1;
  UpdateFormatRect;
end;

procedure TDJMEditButton.WMSetCursor(var Msg: TWMSetCursor);
var
  P: TPoint;
begin
//muy importante, el refresh del boton
fbutton.refresh;
Perform(EM_SETMARGINS,EC_RIGHTMARGIN,(FButton.Width+4)*$10000);
  GetCursorPos(P);
  P := ScreenToClient(P);
  if (P.X >= ClientWidth - FButton.Width) then
    SetCursor(Screen.Cursors[crDefault])
  else
    inherited;
end;

procedure TDJMEditButton.change;
begin
//los margenes, si no,podemos escribir debajo del boton
Perform(EM_SETMARGINS,EC_RIGHTMARGIN,(FButton.Width+4)*$10000);
inherited change;
end;

procedure TDJMEditButton.CMEnabledChanged;
begin
  inherited;
  FButton.Enabled := Enabled;
end;

procedure TDJMEditButton.SetButtonGlyphKind(value:TButtonGlyphKind);
begin
  if value <> FButtonGlyphKind then
  begin
    FButtonGlyphKind := value;
    Fbutton.NumGlyphs:=1;

    case FButtonGlyphKind of
    gkSearch:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'lupace');
    gkSave:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'disketace');
    gkFile:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'filece');
    gkAdd:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'plusce');
    gkRemove:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'minusce');
    gkHome:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'homece');
    gkOpen:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'opence');
    gkCheck:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'checkce');
    gkEllipsis:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'elace');
    gkMail:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'mailce');
    gkTime:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'satce');
    gkDate:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'datece');
    gkHelp:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'helpce');
    gkSilly:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'glupce');
    gkCancel:
Fbutton.Glyph.Handle := LoadBitmap(hInstance, 'delce');
end;
end;
end;

procedure TDJMEditButton.SetButtonLayout(Value:TButtonLayout);
begin
  if value <> FButtonLayout then
  begin
    FButtonLayout := value;
    case FButtonLayout of
    boGlyphLeft:
    FButton.Layout:=blGlyphLeft;
    boGlyphRight:
    FButton.Layout:=blGlyphRight;
    end;
  end;
end;

procedure TDJMEditButton.SetButtonCursor(Value:TButtonCursor);
begin
  if value <> FButtonCursor then
  begin
    FButtonCursor := value;
    case FButtonCursor of
    cuHandPoint:
    FButton.cursor:=crHandPoint;
    cuArrow:
    FButton.cursor:=crArrow;
    end;
  end;
end;

procedure TDJMEditButton.SetFlat(Value: boolean);
begin
    FButton.Flat := Value;
end;

function TDJMEditButton.GetFlat: boolean;
begin
  Result := FButton.Flat;
end;

function TDJMEditButton.GetBTransparent:boolean;
begin
Result:=FButton.Transparent;
end;

procedure TDJMEditButton.SetBTransparent(Value: boolean);
begin
FButton.Transparent:=value;
end;

function  TDJMEditButton.GetBEnabled:boolean;
begin
Result:=FButton.Enabled;
end;

procedure TDJMEditButton.SetBEnabled(Value: boolean);
begin
FButton.Enabled:=value;
end;

procedure TDJMEditButton.SetCaption(const Value: String);
begin
FButton.caption:=Value;
end;

function  TDJMEditButton.GetCaption:String;
begin
result:=Fbutton.caption;
end;

procedure TDJMEditButton.SetButtonHint(const Value: String);
begin
FButton.Hint:=Value;
end;

function  TDJMEditButton.GetButtonHint:String;
begin
result:=Fbutton.Hint;
end;

procedure TDJMEditButton.SetGlyph(const Value: TBitmap);
begin
 FButton.Glyph.assign(Value);
 if not FButton.Glyph.Empty then
 begin
 if  FButton.Glyph.Width < FButton.Glyph.Height then FButton.NumGlyphs :=1;
  if FButton.Glyph.Width mod FButton.Glyph.Height = 0 then
      begin
        FButton.NumGlyphs := FButton.Glyph.Width div FButton.Glyph.Height;
end;
end;
 if FButton.Glyph.Empty then FButton.NumGlyphs :=1;
 FButtonGlyphKind:=gkCustom;
end;

function TDJMEditButton.GetGlyph: TBitmap;
begin
  result:=FButton.Glyph;
end;

procedure TDJMEditButton.SetButtonWidth(ASirina:integer);
begin
FButtonWidth:=ASirina;
FButton.Width:=FButtonWidth;
end;

function TDJMEditButton.GetNumGlyphs: TNumGlyphs;
begin
  Result := FButton.NumGlyphs;
end;

procedure TDJMEditButton.SetNumGlyphs(Value: TNumGlyphs);
begin
  if Value < 0 then Value := 1
  else if Value > 4 then Value := 4;
  if Value <> FButton.NumGlyphs then
  begin
    FButton.NumGlyphs := Value;
    Invalidate;
  end;
end;

procedure TDJMEditButton.CmParentColorChanged(var Message: TWMNoParams);
begin
  inherited;
end;

procedure TDJMEditButton.CmVisibleChanged(var Message: TWmNoParams);
begin
  inherited;
end;

procedure TDJMEditButton.CmParentFontChanged(var Message: TWMNoParams);
begin
  inherited;
end;

function TDJMEditButton.GetOnButtonClick: TNotifyEvent;
begin
  Result := FButton.OnClick;
end;

procedure TDJMEditButton.SetOnButtonClick(Value: TNotifyEvent);
begin
  FButton.onClick := Value;
end;

destructor  TDJMEditButton.Destroy;
begin
  //FButton.Free; //lo va a destruir su owner
  inherited Destroy;
end;

end.
