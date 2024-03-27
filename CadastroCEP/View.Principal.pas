unit View.Principal;

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
  ViaCEP;

type
  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    edtCep: TLabeledEdit;
    edtLogradouro: TLabeledEdit;
    edtComplemento: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtLocalidade: TLabeledEdit;
    edtUF: TLabeledEdit;
    btPesquisar: TButton;
    memRet: TMemo;
    ViaCEP: TViaCEP;
    rbJSON: TRadioButton;
    rbXML: TRadioButton;
    cboxUF: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    btLimpar: TButton;

    procedure btPesquisarClick(Sender: TObject);
    procedure rbJSONClick(Sender: TObject);
    procedure rbXMLClick(Sender: TObject);
    procedure edtCepKeyPress(Sender: TObject; var Key: Char);

  private
    procedure IniciarPesquisa;
    procedure LimparCampos;
    procedure PreencherCampos;
    function BuscaValorComboBox(oCbox: TComboBox; sValor: string): Integer;


  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btPesquisarClick(Sender: TObject);
begin
  IniciarPesquisa;
end;

procedure TMainForm.edtCepKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    IniciarPesquisa;
end;

procedure TMainForm.IniciarPesquisa;
begin
  LimparCampos;

  ViaCep.cep := edtCep.text;

  if ViaCep.PesquisarCEP then
  begin
    PreencherCampos;
  end;
end;

procedure TMainForm.LimparCampos;
begin
  edtLogradouro.Text  := '';
  edtComplemento.Text := '';
  edtBairro.Text      := '';
  edtLocalidade.Text  := '';
  edtUF.Text          := '';
  memRet.Text         := '';
end;

procedure TMainForm.PreencherCampos;
begin
  edtLogradouro.Text  := ViaCEP.Logradouro;
  edtComplemento.Text := ViaCEP.Complemento;
  edtBairro.Text      := ViaCEP.Bairro;
  edtLocalidade.Text  := ViaCEP.Localidade;
  memRet.Text         := ViaCEP.Retorno.Text;
  cboxUF.ItemIndex    := BuscaValorComboBox(cboxUF, ViaCEP.UF);
end;

procedure TMainForm.rbJSONClick(Sender: TObject);
begin
  ViaCEP.TipoRetorno := trJSON;
end;

procedure TMainForm.rbXMLClick(Sender: TObject);
begin
  ViaCEP.TipoRetorno := trXML;
end;

function TMainForm.BuscaValorComboBox(oCbox: TComboBox; sValor: string): Integer;
begin
  Result := oCbox.Items.IndexOf(sValor);
end;
end.
