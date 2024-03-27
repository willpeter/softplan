object ViewMain: TViewMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Softplan - Busca e Cadastro de CEP'
  ClientHeight = 350
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 553
    Height = 313
    TabOrder = 0
    object Label1: TLabel
      Left = 213
      Top = 256
      Width = 13
      Height = 13
      Caption = 'UF'
    end
    object edtCep: TLabeledEdit
      Left = 18
      Top = 79
      Width = 90
      Height = 21
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = 'CEP'
      TabOrder = 0
      Text = ''
      OnKeyPress = edtCepKeyPress
    end
    object edtLogradouro: TLabeledEdit
      Left = 18
      Top = 127
      Width = 241
      Height = 21
      EditLabel.Width = 55
      EditLabel.Height = 13
      EditLabel.Caption = 'Logradouro'
      TabOrder = 1
      Text = ''
    end
    object edtComplemento: TLabeledEdit
      Left = 18
      Top = 175
      Width = 241
      Height = 21
      EditLabel.Width = 65
      EditLabel.Height = 13
      EditLabel.Caption = 'Complemento'
      TabOrder = 2
      Text = ''
    end
    object edtBairro: TLabeledEdit
      Left = 18
      Top = 223
      Width = 241
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'Bairro'
      TabOrder = 3
      Text = ''
    end
    object edtLocalidade: TLabeledEdit
      Left = 18
      Top = 271
      Width = 183
      Height = 21
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'Localidade'
      TabOrder = 4
      Text = ''
    end
    object btPesquisar: TButton
      Left = 112
      Top = 70
      Width = 72
      Height = 30
      Caption = 'Pesquisar'
      TabOrder = 5
      OnClick = btPesquisarClick
    end
    object memRet: TMemo
      Left = 274
      Top = 35
      Width = 265
      Height = 257
      ReadOnly = True
      TabOrder = 6
    end
    object rbJSON: TRadioButton
      Left = 278
      Top = 11
      Width = 113
      Height = 17
      Caption = 'Retornar JSON'
      Checked = True
      TabOrder = 7
      TabStop = True
      OnClick = rbJSONClick
    end
    object rbXML: TRadioButton
      Left = 397
      Top = 11
      Width = 113
      Height = 17
      Caption = 'Retornar XML'
      TabOrder = 8
      OnClick = rbXMLClick
    end
    object cboxUF: TComboBox
      Left = 210
      Top = 271
      Width = 49
      Height = 21
      Style = csDropDownList
      TabOrder = 9
      Items.Strings = (
        'AC'
        'AL'
        'AP'
        'AM'
        'BA'
        'CE'
        'DF'
        'ES'
        'GO'
        'MA'
        'MT'
        'MS'
        'MG'
        'PA'
        'PB'
        'PR'
        'PE'
        'PI'
        'RJ'
        'RN'
        'RS'
        'RO'
        'RR'
        'SC'
        'SP'
        'SE'
        'TO')
    end
    object btLimpar: TButton
      Left = 187
      Top = 70
      Width = 72
      Height = 30
      Caption = 'Limpar'
      TabOrder = 10
      OnClick = btLimparClick
    end
    object GroupBox2: TGroupBox
      Left = 10
      Top = 8
      Width = 252
      Height = 48
      Caption = 'Pesquisar por:'
      TabOrder = 11
      object rbCEP: TRadioButton
        Left = 39
        Top = 21
        Width = 82
        Height = 17
        Caption = 'CEP'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbCEPClick
      end
      object rbEndereco: TRadioButton
        Left = 134
        Top = 21
        Width = 85
        Height = 17
        Caption = 'Endere'#231'o'
        TabOrder = 1
        OnClick = rbEnderecoClick
      end
    end
  end
  object sbInfo: TStatusBar
    Left = 0
    Top = 331
    Width = 570
    Height = 19
    Panels = <
      item
        Text = 'Softplan Planejamento e Sistemas'
        Width = 200
      end
      item
        Width = 50
      end>
    ExplicitTop = 330
    ExplicitWidth = 566
  end
  object ViaCEP: TViaCEP
    TipoBusca = tbCEP
    TipoRetorno = trJSON
    Left = 408
    Top = 104
  end
end
