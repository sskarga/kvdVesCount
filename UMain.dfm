object MainForm: TMainForm
  Left = 453
  Top = 226
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
    Top = 29
    Width = 1113
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object spl1: TSplitter
      Left = 848
      Top = 5
      Width = 10
      Height = 103
      Align = alRight
    end
    object spl2: TSplitter
      Left = 105
      Top = 5
      Width = 10
      Height = 103
    end
    object GroupBox1: TGroupBox
      Left = 858
      Top = 5
      Width = 250
      Height = 103
      Align = alRight
      Caption = #1042#1077#1089' '#1089#1084#1077#1089#1080' '#1079#1072' '#1089#1084#1077#1085#1091', '#1082#1075'.:'
      Constraints.MinWidth = 250
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lblWeightAll: TLabel
        Left = 2
        Top = 21
        Width = 246
        Height = 80
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
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
      Left = 115
      Top = 5
      Width = 733
      Height = 103
      Align = alClient
      Caption = #1042#1077#1089' '#1089#1084#1077#1089#1080', '#1082#1075'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblWeightResource: TLabel
        Left = 481
        Top = 21
        Width = 250
        Height = 80
        Align = alRight
        Alignment = taRightJustify
        Caption = '0 '
        Constraints.MaxWidth = 250
        Constraints.MinWidth = 250
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -40
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        OnDblClick = lblWeightResourceDblClick
      end
      object lblResourceName: TLabel
        Left = 2
        Top = 21
        Width = 479
        Height = 80
        Align = alClient
        Caption = ' --'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        OnDblClick = lblResourceNameDblClick
      end
    end
    object grp1: TGroupBox
      Left = 5
      Top = 5
      Width = 100
      Height = 103
      Align = alLeft
      Caption = #1057#1084#1077#1085#1072
      Constraints.MaxWidth = 100
      Constraints.MinWidth = 100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object lblShift: TLabel
        Left = 2
        Top = 21
        Width = 96
        Height = 80
        Align = alClient
        Alignment = taCenter
        Caption = '-'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 771
    Width = 1113
    Height = 19
    Panels = <>
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 712
    Width = 1113
    Height = 59
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 2
    object lblStatus: TLabel
      Left = 10
      Top = 10
      Width = 1093
      Height = 39
      Align = alClient
      Alignment = taCenter
      Caption = '---'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
  end
  object pnlChartShift: TPanel
    Left = 0
    Top = 512
    Width = 1113
    Height = 200
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 3
    object chtSheft: TChart
      Left = 5
      Top = 5
      Width = 1103
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
      BottomAxis.DateTimeFormat = 'hh:mm'
      BottomAxis.ExactDateTime = False
      BottomAxis.Increment = 0.006944444444444444
      BottomAxis.LabelsSeparation = 50
      BottomAxis.Maximum = 44028.000000000000000000
      BottomAxis.MaximumOffset = 5
      BottomAxis.MaximumRound = True
      BottomAxis.Minimum = 44004.000000000000000000
      BottomAxis.MinimumOffset = 5
      BottomAxis.MinimumRound = True
      LeftAxis.Automatic = False
      LeftAxis.AutomaticMaximum = False
      LeftAxis.AutomaticMinimum = False
      LeftAxis.AxisValuesFormat = '0'
      LeftAxis.Maximum = 200.000000000000000000
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
      object arsrsSeriesShift: TAreaSeries
        Gradient.Balance = 70
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = 16744448
        Gradient.StartColor = clRed
        Gradient.Visible = True
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Shadow.Color = 8816262
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
    Top = 142
    Width = 1113
    Height = 370
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 4
    object chtLive: TChart
      Left = 5
      Top = 5
      Width = 1103
      Height = 360
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
      LeftAxis.AutomaticMaximum = False
      LeftAxis.AutomaticMinimum = False
      LeftAxis.AxisValuesFormat = '0'
      LeftAxis.Maximum = 200.000000000000000000
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
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1113
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 5
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
      object N4: TMenuItem
        Caption = #1054#1090#1095#1077#1090
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N6: TMenuItem
        Action = FileExit1
      end
    end
    object N2: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
      object N7: TMenuItem
        Caption = #1058#1072#1088#1080#1088#1086#1074#1082#1072
      end
    end
    object N3: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnClick = N3Click
    end
  end
  object Timer1: TTimer
    Interval = 30000
    OnTimer = Timer1Timer
    Left = 397
    Top = 29
  end
  object OpcSimpleClient: TOpcSimpleClient
    Groups = <
      item
        LocaleID = 2048
        UpdateRate = 0
        Active = True
        OnDataChange = OpcSimpleClient1Groups0DataChange
      end>
    ProgID = 'arOPC.arOpcServer.1'
    SortedItemLists = False
    ConnectIOPCShutdown = True
    Left = 317
    Top = 29
  end
  object ActionList: TActionList
    Left = 547
    Top = 106
    object FileExit1: TFileExit
      Category = 'File'
      Caption = #1042#1099#1093#1086#1076
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
  end
end
