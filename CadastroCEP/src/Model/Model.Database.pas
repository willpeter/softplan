unit Model.Database;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.PGDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.Phys.PG,
  Firedac.DApt,
  FireDAC.Comp.Client,
  Data.DB,
  IniFiles,
  Utils.Funcoes,
  Utils.Constantes;

type
  TModelDatabase = class(TDataModule)
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);

  private
    procedure CarregarConfiguracoesIni(const sCaminhoArquivoINI: string; const oConnection: TFDConnection);
    function ScriptCriacaoTabelaEnderecos: string;
    function ConectouBD(oConnection: TFDConnection): Boolean;
    function CriarTabelaEnderecos: Boolean;

  public
    FConsistiuBD: Boolean;
    function ExecutarSQL(sInstrucaoSQL: string): Boolean;
    function ConsisteBD: Boolean;
    procedure SetarConnection(const oConnection: TFDConnection);
  end;

var
  ModelDatabase: TModelDatabase;

implementation


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TModelDatabase }

function TModelDatabase.ConectouBD(oConnection: TFDConnection): Boolean;
begin
  try
    oConnection.Connected := True;

  except
    on E: Exception do
      TUtils.GravarLog('Erro ao conectar com o banco de dados: ' + E.Message);
  end;

  Result := oConnection.Connected;
end;

function TModelDatabase.ConsisteBD: Boolean;
var
  oConnection: TFDConnection;
begin
  Result := False;

  try
    oConnection := TFDConnection.Create(nil);

    TUtils.CriarArquivoIniPadrao;
    SetarConnection(oConnection);

    if not ConectouBD(oConnection) then
    begin
      TUtils.MsgAtencao(MSG_ERRO_CONEXAO_BD);
      Exit;
    end;

    if not CriarTabelaEnderecos then
    begin
      TUtils.MsgAtencao(MSG_ERRO_CRIAR_TABELA_ENDERECOS);
      Exit;
    end;

  finally
    oConnection.Destroy
  end;
end;

function TModelDatabase.CriarTabelaEnderecos: Boolean;
begin
  Result := ExecutarSQL(ScriptCriacaoTabelaEnderecos);
end;

procedure TModelDatabase.DataModuleCreate(Sender: TObject);
begin
  FConsistiuBD := ConsisteBD;
end;

function TModelDatabase.ScriptCriacaoTabelaEnderecos: string;
begin
  Result :=  'CREATE TABLE IF NOT EXISTS Enderecos (' +
             'Codigo SERIAL PRIMARY KEY, ' +
             'CEP VARCHAR(8), ' +
             'Logradouro VARCHAR(100), ' +
             'Complemento VARCHAR(100), ' +
             'Bairro VARCHAR(100), ' +
             'Localidade VARCHAR(100), ' +
             'UF VARCHAR(2)' +
             ')';
end;

procedure TModelDatabase.SetarConnection(const oConnection: TFDConnection);
begin
  CarregarConfiguracoesIni(TUtils.CaminhoArquivoINI, oConnection);
end;

function TModelDatabase.ExecutarSQL(sInstrucaoSQL: string): Boolean;
var
  oConnection: TFDConnection;
  oQuery: TFDQuery;
begin
  Result := True;

  try
    oQuery := TFDQuery.Create(nil);
    oConnection := TFDConnection.Create(nil);
    SetarConnection(oConnection);

    try
      oQuery.Connection := oConnection;
      oQuery.SQL.Text   := ScriptCriacaoTabelaEnderecos;
      oQuery.ExecSQL;

    finally
      oConnection.Free;
      oQuery.Free;
    end;

  except
    on E: Exception do
    begin
      TUtils.GravarLog('Erro ao verificar/ criar tabela : ' + E.Message);
      Result := False;
    end;
  end;
end;

procedure TModelDatabase.CarregarConfiguracoesIni(const sCaminhoArquivoINI: string; const oConnection: TFDConnection);
var
  oIniFile: TIniFile;
begin
  if not FileExists(sCaminhoArquivoINI) then
    Exit;

  oIniFile := TIniFile.Create(sCaminhoArquivoINI);

  try
    oConnection.Params.DriverID := oIniFile.ReadString('PG', 'DriverID', '');
    oConnection.Params.Database := oIniFile.ReadString('PG', 'Database', '');
    oConnection.Params.UserName := oIniFile.ReadString('PG', 'User_Name', '');
    oConnection.Params.Password := oIniFile.ReadString('PG', 'Password', '');
    oConnection.Params.Add('Server=' + oIniFile.ReadString('PG', 'Server', ''));
    oConnection.Params.Add('Port=' + oIniFile.ReadString('PG', 'Port', ''));

  finally
    oIniFile.Destroy;
  end;
end;

end.
