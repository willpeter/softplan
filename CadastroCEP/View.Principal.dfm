object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Softplan - Busca e Cadastro de CEP'
  ClientHeight = 329
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
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
      Top = 31
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
      Top = 79
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
      Top = 127
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
      Top = 175
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
      Top = 223
      Width = 241
      Height = 21
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'Localidade'
      TabOrder = 4
      Text = ''
    end
    object edtUF: TLabeledEdit
      Left = 18
      Top = 271
      Width = 177
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = 'LabeledEdit1'
      TabOrder = 5
      Text = ''
    end
    object btPesquisar: TButton
      Left = 112
      Top = 23
      Width = 72
      Height = 30
      Caption = 'Pesquisar'
      TabOrder = 6
      OnClick = btPesquisarClick
    end
    object memRet: TMemo
      Left = 274
      Top = 35
      Width = 265
      Height = 209
      ReadOnly = True
      TabOrder = 7
    end
    object rbJSON: TRadioButton
      Left = 278
      Top = 17
      Width = 113
      Height = 17
      Caption = 'Retornar JSON'
      Checked = True
      TabOrder = 8
      TabStop = True
      OnClick = rbJSONClick
    end
    object rbXML: TRadioButton
      Left = 397
      Top = 17
      Width = 113
      Height = 17
      Caption = 'Retornar XML'
      TabOrder = 9
      OnClick = rbXMLClick
    end
    object cboxUF: TComboBox
      Left = 210
      Top = 271
      Width = 49
      Height = 21
      Style = csDropDownList
      TabOrder = 10
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
    object Button2: TButton
      Left = 409
      Top = 263
      Width = 130
      Height = 30
      Caption = 'Excluir'
      TabOrder = 11
      OnClick = btPesquisarClick
    end
    object Button3: TButton
      Left = 273
      Top = 263
      Width = 130
      Height = 30
      Caption = 'Incluir'
      TabOrder = 12
      OnClick = btPesquisarClick
    end
    object btLimpar: TButton
      Left = 187
      Top = 23
      Width = 72
      Height = 30
      Caption = 'Limpar'
      TabOrder = 13
    end
  end
  object ViaCEP: TViaCEP
    TipoRetorno = trJSON
    Left = 380
    Top = 136
  end
end
