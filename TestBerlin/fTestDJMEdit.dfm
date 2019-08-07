object frTestDJMEdit: TfrTestDJMEdit
  Left = 0
  Top = 0
  Caption = 'frTestDJMEdit'
  ClientHeight = 551
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 374
    Top = 296
    Width = 230
    Height = 137
  end
  object Label1: TLabel
    Left = 100
    Top = 43
    Width = 61
    Height = 13
    Caption = 'Edit1 etFloat'
  end
  object Label2: TLabel
    Left = 45
    Top = 83
    Width = 116
    Height = 13
    Caption = 'Edit2 etFloatRoundedEx'
  end
  object Label3: TLabel
    Left = 81
    Top = 126
    Width = 80
    Height = 13
    Caption = 'edit3 etRounded'
  end
  object Label4: TLabel
    Left = 96
    Top = 195
    Width = 65
    Height = 13
    Caption = 'N'#186' decimales:'
  end
  object lblFecha: TLabel
    Left = 395
    Top = 315
    Width = 29
    Height = 13
    Caption = 'Fecha'
  end
  object spGetValue: TSpeedButton
    Left = 374
    Top = 464
    Width = 219
    Height = 49
    Caption = 'speed button (getvalue sin perdida de foco)'
    OnClick = spGetValueClick
  end
  object Label6: TLabel
    Left = 100
    Top = 159
    Width = 61
    Height = 13
    Caption = 'edit4 integer'
  end
  object lblTime: TLabel
    Left = 141
    Top = 237
    Width = 20
    Height = 13
    Caption = 'time'
  end
  object lblString: TLabel
    Left = 133
    Top = 277
    Width = 28
    Height = 13
    Caption = 'String'
  end
  object iDecimales: TSpinEdit
    Left = 176
    Top = 192
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 6
    OnChange = iDecimalesChange
  end
  object Button1: TButton
    Left = 400
    Top = 38
    Width = 105
    Height = 25
    Caption = 'get valueFloat'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 400
    Top = 78
    Width = 105
    Height = 25
    Caption = 'get valueFloat'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 400
    Top = 121
    Width = 105
    Height = 25
    Caption = 'get valueFloat'
    TabOrder = 3
    OnClick = Button3Click
  end
  object btnSetValueFloat: TButton
    Left = 88
    Top = 327
    Width = 181
    Height = 25
    Caption = 'set valuefloat'
    TabOrder = 4
    OnClick = btnSetValueFloatClick
  end
  object Button6: TButton
    Left = 395
    Top = 360
    Width = 75
    Height = 25
    Caption = 'set date'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 395
    Top = 391
    Width = 75
    Height = 25
    Caption = 'get date'
    TabOrder = 6
    OnClick = Button7Click
  end
  object btnSymbolDollar: TButton
    Left = 88
    Top = 368
    Width = 181
    Height = 25
    Caption = 'currency symbol a $'
    TabOrder = 7
    OnClick = btnSymbolDollarClick
  end
  object btnSymbolEuro: TButton
    Left = 88
    Top = 399
    Width = 181
    Height = 25
    Caption = 'currency symbol a '#8364
    TabOrder = 8
    OnClick = btnSymbolEuroClick
  end
  object btnNoSymbol: TButton
    Left = 88
    Top = 430
    Width = 181
    Height = 25
    Caption = 'sin currency symbol'
    TabOrder = 9
    OnClick = btnNoSymbolClick
  end
  object Button11: TButton
    Left = 400
    Top = 152
    Width = 105
    Height = 25
    Caption = 'get ValueInteger'
    TabOrder = 10
    OnClick = Button11Click
  end
  object Button4: TButton
    Left = 400
    Top = 230
    Width = 105
    Height = 25
    Caption = 'get valuetime'
    TabOrder = 11
    OnClick = Button4Click
  end
  object Button12: TButton
    Left = 88
    Top = 461
    Width = 75
    Height = 25
    Caption = 'clear'
    TabOrder = 12
    OnClick = Button12Click
  end
end
