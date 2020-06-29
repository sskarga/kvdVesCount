object FormChangeResource: TFormChangeResource
  Left = 643
  Top = 438
  Width = 647
  Height = 165
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1088#1077#1089#1091#1088#1089
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
  object cbbResource: TComboBox
    Left = 8
    Top = 8
    Width = 617
    Height = 41
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 33
    ParentFont = False
    TabOrder = 0
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6')
  end
  object btn1: TBitBtn
    Left = 416
    Top = 64
    Width = 155
    Height = 41
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 1
    Kind = bkYes
  end
  object BitBtn1: TBitBtn
    Left = 40
    Top = 64
    Width = 155
    Height = 41
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    TabOrder = 2
    Kind = bkNo
  end
end
