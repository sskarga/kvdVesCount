object FormReport: TFormReport
  Left = 812
  Top = 351
  Width = 318
  Height = 238
  Caption = #1057#1086#1079#1076#1072#1090#1100' '#1086#1090#1095#1077#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DateTimePicker1: TDateTimePicker
    Left = 32
    Top = 40
    Width = 241
    Height = 31
    Date = 44005.672465590280000000
    Time = 44005.672465590280000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 80
    Top = 120
    Width = 139
    Height = 41
    Caption = #1054#1090#1095#1077#1090
    TabOrder = 1
    Kind = bkYes
  end
  object frxReport: TfrxReport
    Version = '4.9.32'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 44011.423376909720000000
    ReportOptions.LastChange = 44011.423376909720000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 24
    Top = 104
    Datasets = <>
    Variables = <>
    Style = <>
  end
end
