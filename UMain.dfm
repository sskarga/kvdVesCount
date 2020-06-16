object MainForm: TMainForm
  Left = 657
  Top = 94
  Width = 1121
  Height = 841
  Caption = #1059#1095#1077#1090' '#1089#1084#1077#1089#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1105
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object spl1: TSplitter
      Left = 846
      Top = 5
      Width = 10
      Height = 103
      Align = alRight
    end
    object GroupBox1: TGroupBox
      Left = 856
      Top = 5
      Width = 244
      Height = 103
      Align = alRight
      Caption = #1042#1077#1089' '#1089#1084#1077#1089#1080' '#1079#1072' '#1089#1084#1077#1085#1091', '#1090'.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lbAllWeight: TLabel
        Left = 2
        Top = 21
        Width = 240
        Height = 80
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = '38,000'
        Constraints.MaxWidth = 300
        Constraints.MinWidth = 240
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -40
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
    end
    object GroupBox2: TGroupBox
      Left = 5
      Top = 5
      Width = 841
      Height = 103
      Align = alClient
      Caption = #1042#1077#1089' '#1089#1084#1077#1089#1080', '#1090'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label2: TLabel
        Left = 589
        Top = 21
        Width = 250
        Height = 80
        Align = alRight
        Alignment = taCenter
        Caption = '38.000.12'
        Constraints.MaxWidth = 250
        Constraints.MinWidth = 250
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -40
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 2
        Top = 21
        Width = 587
        Height = 80
        Align = alClient
        Caption = ' '#1056#1072#1082#1091#1096#1082#1072' '#8470'1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 763
    Width = 1105
    Height = 19
    Panels = <>
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 728
    Width = 1105
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 2
  end
  object pnlChartShift: TPanel
    Left = 0
    Top = 528
    Width = 1105
    Height = 200
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 3
    object chtSheft: TChart
      Left = 5
      Top = 5
      Width = 1095
      Height = 190
      AllowPanning = pmNone
      Border.Color = clGray
      Border.Visible = True
      Legend.Visible = False
      MarginBottom = 2
      MarginLeft = 1
      MarginRight = 2
      MarginTop = 2
      Title.Font.Color = 4210688
      Title.Font.Height = -13
      Title.Font.Style = [fsBold]
      Title.Font.Shadow.Visible = False
      Title.Shadow.SmoothBlur = 14
      Title.Shadow.Visible = False
      Title.Text.Strings = (
        #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072' '#1089#1084#1077#1085#1091)
      Title.VertMargin = 2
      BottomAxis.Automatic = False
      BottomAxis.AutomaticMaximum = False
      BottomAxis.AutomaticMinimum = False
      BottomAxis.LabelsSeparation = 50
      BottomAxis.Maximum = 44008.000000000000000000
      BottomAxis.Minimum = 43984.000000000000000000
      LeftAxis.Automatic = False
      LeftAxis.AutomaticMinimum = False
      LeftAxis.AxisValuesFormat = '0'
      LeftAxis.MaximumOffset = 1
      LeftAxis.MaximumRound = True
      LeftAxis.Title.Caption = #1042#1077#1089', '#1082#1075
      LeftAxis.Title.Font.Height = -13
      LeftAxis.Title.Font.Style = [fsBold]
      RightAxis.Visible = False
      Shadow.Visible = False
      TopAxis.Automatic = False
      TopAxis.AutomaticMaximum = False
      TopAxis.AutomaticMinimum = False
      TopAxis.Visible = False
      View3D = False
      Zoom.Allow = False
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      PrintMargins = (
        15
        42
        15
        42)
      ColorPaletteIndex = 13
      object arsrsSeries1: TAreaSeries
        Gradient.Balance = 70
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = 16744448
        Gradient.StartColor = clRed
        Gradient.Visible = True
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Visible = False
        ShowInLegend = False
        Dark3D = False
        DrawArea = True
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        Pointer.Visible = False
        XValues.DateTime = True
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 113
    Width = 1105
    Height = 415
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 4
    object chtLive: TChart
      Left = 5
      Top = 5
      Width = 1095
      Height = 405
      AllowPanning = pmNone
      Border.Color = clGray
      Border.Visible = True
      Legend.Visible = False
      MarginBottom = 2
      MarginLeft = 2
      MarginRight = 2
      MarginTop = 2
      Title.Font.Color = 4210688
      Title.Font.Height = -13
      Title.Font.Style = [fsBold]
      Title.Font.Shadow.Visible = False
      Title.Shadow.SmoothBlur = 14
      Title.Shadow.Visible = False
      Title.Text.Strings = (
        #1058#1077#1082#1091#1097#1072#1103' '#1079#1072#1075#1088#1091#1079#1082#1072)
      Title.VertMargin = 2
      AxisBehind = False
      BottomAxis.LabelsMultiLine = True
      BottomAxis.LabelsSeparation = 100
      LeftAxis.Automatic = False
      LeftAxis.AutomaticMinimum = False
      LeftAxis.AxisValuesFormat = '0'
      LeftAxis.MaximumRound = True
      LeftAxis.Title.Caption = #1042#1077#1089', '#1082#1075
      LeftAxis.Title.Font.Height = -13
      LeftAxis.Title.Font.Style = [fsBold]
      LeftAxis.TitleSize = 1
      RightAxis.Visible = False
      Shadow.Visible = False
      TopAxis.Automatic = False
      TopAxis.AutomaticMaximum = False
      TopAxis.AutomaticMinimum = False
      TopAxis.Visible = False
      View3D = False
      Zoom.Allow = False
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      PrintMargins = (
        15
        31
        15
        31)
      ColorPaletteIndex = 13
      object Memo1: TMemo
        Left = 136
        Top = 152
        Width = 569
        Height = 193
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
      object arsrsMain: TFastLineSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.BackColor = clWhite
        Marks.Color = clWhite
        Marks.Transparency = 15
        Marks.Visible = False
        ShowInLegend = False
        ValueFormat = '0.0'
        LinePen.Color = 10708548
        LinePen.Width = 3
        TreatNulls = tnDontPaint
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
  object XPManifest: TXPManifest
    Left = 1064
    Top = 112
  end
  object mmMain: TMainMenu
    Left = 152
    Top = 152
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
    end
    object N2: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
    end
    object N3: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 7350
    OnTimer = Timer1Timer
    Left = 341
    Top = 69
  end
  object XMLConfig: TXMLDocument
    Left = 480
    Top = 48
    DOMVendorDesc = 'MSXML'
  end
  object OpcSimpleClient: TOpcSimpleClient
    Groups = <
      item
        LocaleID = 2048
        UpdateRate = 50
        Active = True
        OnDataChange = OpcSimpleClient1Groups0DataChange
      end>
    ProgID = 'arOPC.arOpcServer.1'
    SortedItemLists = False
    ConnectIOPCShutdown = True
    Left = 269
    Top = 77
  end
end
