unit View.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Mask,
  ViaCEP,
  Controller.Endereco,
  Controller.Database,
  DTO.Endereco,
  Utils.Funcoes,
  Utils.Constantes, Vcl.ComCtrls;

type
  TViewMain = class(TForm)
    GroupBox1: TGroupBox;
    edtCep: TLabeledEdit;
    edtLogradouro: TLabeledEdit;
    edtComplemento: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtLocalidade: TLabeledEdit;
    btPesquisar: TButton;
    memRet: TMemo;
    rbJSON: TRadioButton;
    rbXML: TRadioButton;
    cboxUF: TComboBox;
    Label1: TLabel;
    btLimpar: TButton;
    GroupBox2: TGroupBox;
    rbCEP: TRadioButton;
    rbEndereco: TRadioButton;
    sbInfo: TStatusBar;
    ViaCEP: TViaCEP;

    procedure btPesquisarClick(Sender: TObject);
    procedure rbJSONClick(Sender: TObject);
    procedure rbXMLClick(Sender: TObject);
    procedure edtCepKeyPress(Sender: TObject; var Key: Char);
    procedure rbCEPClick(Sender: TObject);
    procedure rbEnderecoClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    ControllerDatabase: TControllerDatabase;
    ControllerEndereco: TControllerEndereco;

    procedure IniciarPesquisa;
    procedure LimparCampos;
    procedure PreencherCamposViaCEP;
    procedure PrencherCamposPorBD(const oDtoEndereco: TDTOEndereco);
    procedure PreencherDTOViaCEP(const oDtoEndereco: TDTOEndereco);
    function BuscaValorComboBox(const oCbox: TComboBox; const sValor: string): Integer;
    function ExisteRegistroNaBaseLocal: Boolean;
    procedure SetarDtoPorViaCEP(const oDtoEndereco: TDTOEndereco);
    procedure SetarDtoPorBD(const oDtoEndereco: TDTOEndereco);
    function PesquisarPorCEP(const oDtoEndereco: TDTOEndereco): TDTOEndereco;
    function PesquisarPorEndereco(const oDtoEndereco: TDTOEndereco): TDTOEndereco;
    function EnderecoValidoParaPesquisa(const oDtoEndereco: TDTOEndereco): Boolean;
    function ManterRegistroExistente(const oDtoEndereco: TDTOEndereco): Boolean;

  public
    constructor Create;
    destructor Destroy; override;

  public
    { Public declarations }
  end;

var
  ViewMain: TViewMain;
  bCepExistente: Boolean;
  bEnderecoValido: Boolean;

implementation

{$R *.dfm}

procedure TViewMain.btLimparClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TViewMain.btPesquisarClick(Sender: TObject);
begin
  IniciarPesquisa;
end;

procedure TViewMain.edtCepKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    IniciarPesquisa;
end;

function TViewMain.ExisteRegistroNaBaseLocal: Boolean;
begin
  Result := False;
end;

procedure TViewMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ViewMain.Destroy;
  Application.Terminate;
end;

procedure TViewMain.IniciarPesquisa;
var
  oDtoEndereco: TDTOEndereco;
begin
  bCepExistente   := False;
  bEnderecoValido := False;
  oDtoEndereco    := TDTOEndereco.Create;
  LimparCampos;

  try
    case ViaCEP.TipoBusca of
      tbCEP:
      begin
        oDtoEndereco := PesquisarPorCEP(oDtoEndereco);
        ViaCep.Cep := edtCep.text;
      end;

      tbEndereco:
      begin
        oDtoEndereco := PesquisarPorEndereco(oDtoEndereco);

        if (not bEnderecoValido) then
          Exit;

        ViaCEP.UF := cboxUF.Text;
        ViaCEP.Localidade := edtLocalidade.Text;
        ViaCEP.Logradouro := edtLogradouro.Text;
      end;
    end;

    if ManterRegistroExistente(oDtoEndereco) then
      Exit;

    if not ViaCep.ExecutarPesquisa then
      Exit;

    PreencherCamposViaCEP;
    PreencherDTOViaCEP(oDtoEndereco);

    if bCepExistente then
    begin
      if ControllerEndereco.UpdateRegistro(oDtoEndereco) then
        sbInfo.Panels[1].Text := oDtoEndereco.CEP + MSG_OK_EDIT_ENDERECO;
    end
    else
    begin
      if ControllerEndereco.NovoRegistro(oDtoEndereco) then
        sbInfo.Panels[1].Text := oDtoEndereco.CEP + MSG_OK_ADD_ENDERECO;
    end;

  finally
    oDtoEndereco.Destroy;
  end;
end;

function TViewMain.PesquisarPorCEP(const oDtoEndereco: TDTOEndereco): TDTOEndereco;
begin
  oDtoEndereco.CEP := edtCep.Text;
  Result := ControllerEndereco.CepCadastrado(oDtoEndereco);
end;

function TViewMain.PesquisarPorEndereco(const oDtoEndereco: TDTOEndereco): TDTOEndereco;
begin
  oDtoEndereco.UF := cboxUF.Text;
  oDtoEndereco.Localidade := edtLocalidade.Text;
  oDtoEndereco.Logradouro := edtLogradouro.Text;

  if not EnderecoValidoParaPesquisa(oDtoEndereco) then
  begin
    TUtils.MsgErro(MSG_ERRO_CAMPOS_ENDERECO);
    Result := oDtoEndereco;
    Exit;
  end;

  bEnderecoValido := True;
  Result := ControllerEndereco.EnderecoCadastrado(oDtoEndereco);
end;

function TViewMain.ManterRegistroExistente(const oDtoEndereco: TDTOEndereco): Boolean;
begin
  Result := False;

  if oDtoEndereco.Codigo > 0 then
  begin
    bCepExistente := True;
    sbInfo.Panels[1].Text := oDtoEndereco.CEP + MSG_INFO_CEP_EXISTENTE;

    if TUtils.MsgPergunta(MSG_PERGUNTA_CEP_EXISTE_BD) then
    begin
      PrencherCamposPorBD(oDtoEndereco);
      Result := True;
    end;
  end;
end;

function TViewMain.EnderecoValidoParaPesquisa(const oDtoEndereco: TDTOEndereco): Boolean;
begin
  Result := ((oDtoEndereco.UF <> '')
    and (oDtoEndereco.Localidade <> '')
    and (oDtoEndereco.Logradouro <> '')
    and (Length(oDtoEndereco.UF) = 2)
    and (Length(oDtoEndereco.Localidade) >= 3)
    and (Length(oDtoEndereco.Logradouro) >= 3));
end;

procedure TViewMain.LimparCampos;
begin
  if rbCEP.Checked then
  begin
    edtLogradouro.Text    := STRING_INDEFINIDO;
    edtComplemento.Text   := STRING_INDEFINIDO;
    edtBairro.Text        := STRING_INDEFINIDO;
    edtLocalidade.Text    := STRING_INDEFINIDO;
    cboxUF.Text           := STRING_INDEFINIDO;
    memRet.Text           := STRING_INDEFINIDO;
    sbInfo.Panels[1].Text := STRING_INDEFINIDO;
  end
  else
  begin
    edtCep.Text           := STRING_INDEFINIDO;
    edtComplemento.Text   := STRING_INDEFINIDO;
    edtBairro.Text        := STRING_INDEFINIDO;
    memRet.Text           := STRING_INDEFINIDO;
    sbInfo.Panels[1].Text := STRING_INDEFINIDO;
  end;
end;

procedure TViewMain.PreencherCamposViaCEP;
begin
  edtLogradouro.Text  := ViaCEP.Logradouro;
  edtComplemento.Text := ViaCEP.Complemento;
  edtBairro.Text      := ViaCEP.Bairro;
  edtLocalidade.Text  := ViaCEP.Localidade;
  memRet.Text         := ViaCEP.Retorno.Text;
  cboxUF.ItemIndex    := BuscaValorComboBox(cboxUF, ViaCEP.UF);
end;

procedure TViewMain.PreencherDTOViaCEP(const oDtoEndereco: TDTOEndereco);
begin
  oDtoEndereco.CEP         := ViaCEP.Cep;
  oDtoEndereco.Logradouro  := ViaCEP.Logradouro;
  oDtoEndereco.Complemento := ViaCEP.Complemento;
  oDtoEndereco.Bairro      := ViaCEP.Bairro;
  oDtoEndereco.Localidade  := ViaCEP.Localidade;
  oDtoEndereco.UF          := ViaCEP.UF;
end;

procedure TViewMain.PrencherCamposPorBD(const oDtoEndereco: TDTOEndereco);
begin
  edtCep.Text         := oDtoEndereco.CEP;
  edtLogradouro.Text  := oDtoEndereco.Logradouro;
  edtComplemento.Text := oDtoEndereco.Complemento;
  edtBairro.Text      := oDtoEndereco.Bairro;
  edtLocalidade.Text  := oDtoEndereco.Localidade;
  cboxUF.ItemIndex    := BuscaValorComboBox(cboxUF, oDtoEndereco.UF);
end;

procedure TViewMain.rbCEPClick(Sender: TObject);
begin
  ViaCEP.TipoBusca := tbCEP;
end;

procedure TViewMain.rbEnderecoClick(Sender: TObject);
begin
  ViaCEP.TipoBusca := tbEndereco;
end;

procedure TViewMain.rbJSONClick(Sender: TObject);
begin
  ViaCEP.TipoRetorno := trJSON;
end;

procedure TViewMain.rbXMLClick(Sender: TObject);
begin
  ViaCEP.TipoRetorno := trXML;
end;

procedure TViewMain.SetarDtoPorBD(const oDtoEndereco: TDTOEndereco);
begin
  oDtoEndereco.CEP         := edtCep.Text;
  oDtoEndereco.Logradouro  := edtLogradouro.Text;
  oDtoEndereco.Complemento := edtComplemento.Text;
  oDtoEndereco.Bairro      := edtBairro.Text;
  oDtoEndereco.Localidade  := edtLocalidade.Text;
  oDtoEndereco.UF          := cboxUF.Text;
end;

procedure TViewMain.SetarDtoPorViaCEP(const oDtoEndereco: TDTOEndereco);
begin
  oDtoEndereco.CEP         := ViaCEP.Cep;
  oDtoEndereco.Logradouro  := ViaCEP.Logradouro;
  oDtoEndereco.Complemento := ViaCEP.Complemento;
  oDtoEndereco.Bairro      := ViaCEP.Bairro;
  oDtoEndereco.Localidade  := ViaCEP.Localidade;
  oDtoEndereco.UF          := ViaCEP.UF;
end;

function TViewMain.BuscaValorComboBox(const oCbox: TComboBox; const sValor: string): Integer;
begin
  Result := oCbox.Items.IndexOf(sValor);
end;

constructor TViewMain.Create;
begin
  ControllerDatabase := Controller.Database.ControllerDatabase;
  ControllerEndereco := Controller.Endereco.ControllerEndereco
end;

destructor TViewMain.Destroy;
begin
  inherited;
end;

end.
