unit Model.Endereco;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  Utils.Funcoes,
  Model.Database,
  DTO.Endereco;


type
  TModelEndereco = class

  private
    FCodigo: Integer;
    FCEP: string;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUF: string;

  public
    property Codigo: Integer read FCodigo write FCodigo;
    property CEP: string read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property Localidade: string read FLocalidade write FLocalidade;
    property UF: string read FUF write FUF;
    class function NovoRegistro(oDtoEndereco: TDTOEndereco): Boolean;
    class function UpdateRegistro(oDtoEndereco: TDTOEndereco): Boolean;
    class function ExecSqlRetornaReg(const sInstrucaoSQL: string; const oDtoEndereco: TDTOEndereco): TDTOEndereco;
    class function CepCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
    class function EnderecoCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
    class function ExecutarSQL(const sInstrucaoSQL: string): Boolean;
    class function ScriptNovoRegistro(oDtoEndereco: TDTOEndereco): string;
    class function ScriptUpdateRegistro(oDtoEndereco: TDTOEndereco): string;
  end;

var
  ModelEndereco: TModelEndereco;


implementation

{ TModelEndereco }

class function TModelEndereco.NovoRegistro(oDtoEndereco: TDTOEndereco): Boolean;
begin
  Result := ExecutarSQL(ScriptNovoRegistro(oDtoEndereco));
end;

class function TModelEndereco.ScriptNovoRegistro(oDtoEndereco: TDTOEndereco): string;
var
  sScript: string;
begin
  sScript := 'INSERT INTO Enderecos (CEP, Logradouro, Complemento, Bairro, Localidade, UF) VALUES (' +
    QuotedStr(oDtoEndereco.CEP) + ', ' +
    QuotedStr(oDtoEndereco.Logradouro) + ', ' +
    QuotedStr(oDtoEndereco.Complemento) + ', ' +
    QuotedStr(oDtoEndereco.Bairro) + ', ' +
    QuotedStr(oDtoEndereco.Localidade) + ', ' +
    QuotedStr(oDtoEndereco.UF) + ')';

  Result := sScript;
end;

class function TModelEndereco.ScriptUpdateRegistro(oDtoEndereco: TDTOEndereco): string;
var
  sScript: string;
begin
  sScript := 'UPDATE Enderecos SET ' +
    'Logradouro = ' + QuotedStr(oDtoEndereco.Logradouro) + ', ' +
    'Complemento = ' + QuotedStr(oDtoEndereco.Complemento) + ', ' +
    'Bairro = ' + QuotedStr(oDtoEndereco.Bairro) + ', ' +
    'Localidade = ' + QuotedStr(oDtoEndereco.Localidade) + ', ' +
    'UF = ' + QuotedStr(oDtoEndereco.UF) +
    ' WHERE CEP = ' + QuotedStr(TUtils.SomenteNumeros(oDtoEndereco.CEP));

  Result := sScript;
end;

class function TModelEndereco.UpdateRegistro(
  oDtoEndereco: TDTOEndereco): Boolean;
begin
  Result := ExecutarSQL(ScriptUpdateRegistro(oDtoEndereco));
end;

class function TModelEndereco.CepCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
var
  sScript: string;
begin
  sScript := 'SELECT * FROM Enderecos WHERE CEP = ' + QuotedStr(oDtoEndereco.CEP);
  Result := ExecSqlRetornaReg(sScript, oDtoEndereco);
end;

class function TModelEndereco.EnderecoCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
var
  sScript: string;
begin
  sScript := 'SELECT * FROM Enderecos ' +
             ' WHERE UF LIKE ' + QuotedStr('%' + oDtoEndereco.UF + '%') +
             ' AND LOCALIDADE LIKE ' + QuotedStr('%' + oDtoEndereco.Localidade + '%') +
             ' AND LOGRADOURO LIKE ' + QuotedStr('%' + oDtoEndereco.Logradouro + '%');
  Result := ExecSqlRetornaReg(sScript, oDtoEndereco);
end;

class function TModelEndereco.ExecSqlRetornaReg(const sInstrucaoSQL: string; const oDtoEndereco: TDTOEndereco): TDTOEndereco;
var
  oConnection: TFDConnection;
  oQuery: TFDQuery;
begin
  try
    oQuery := TFDQuery.Create(nil);
    oConnection := TFDConnection.Create(nil);
    ModelDatabase.SetarConnection(oConnection);

    try
      oQuery.Connection := oConnection;
      oQuery.SQL.Text   := sInstrucaoSQL;
      oQuery.Open;

      if (not oQuery.IsEmpty) then
      begin
        oDtoEndereco.Codigo      := oQuery.FieldByName('codigo').AsInteger;
        oDtoEndereco.CEP         := oQuery.FieldByName('cep').AsString;
        oDtoEndereco.Logradouro  := oQuery.FieldByName('logradouro').AsString;
        oDtoEndereco.Complemento := oQuery.FieldByName('complemento').AsString;
        oDtoEndereco.Bairro      := oQuery.FieldByName('bairro').AsString;
        oDtoEndereco.Localidade  := oQuery.FieldByName('localidade').AsString;
        oDtoEndereco.UF          := oQuery.FieldByName('uf').AsString;
      end;

      Result := oDtoEndereco;

    finally
      oQuery.Destroy;
      oConnection.Destroy;
    end;

  except
    on E: Exception do
    begin
      TUtils.GravarLog('Erro ao executar Model.Endereco - ExecSqlRetornaReg : ' + E.Message);
    end;
  end;
end;

class function TModelEndereco.ExecutarSQL(const sInstrucaoSQL: string): Boolean;
var
  oQuery: TFDQuery;
  oConnection: TFDConnection;
begin
  Result := True;
  try
    oQuery := TFDQuery.Create(nil);
    oConnection := TFDConnection.Create(nil);
    ModelDatabase.SetarConnection(oConnection);

    try
      oQuery.Connection := oConnection;
      oQuery.SQL.Text   := sInstrucaoSQL;
      oQuery.ExecSQL;

    finally
      oQuery.Destroy;
      oConnection.Destroy;
    end;

  except
    on E: Exception do
    begin
      TUtils.GravarLog('Erro ao executar Model.Endereco - ExecutarSQL: ' + E.Message);
      Result := False;
    end;
  end;
end;



end.




