unit ViaCEP;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.HttpClient,
  System.Variants,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.Dialogs,
  Winapi.Windows,
  System.JSON,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Xml.XMLDOM,
  Utils.Constantes,
  Utils.Funcoes;

type
  TTipoRetorno = (trJSON, trXML);

  TTipoBusca = (tbCEP, tbEndereco);

  TViaCEP = class(TComponent)
  private
    FsURL: string;
    FCep: string;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUF: string;
    FIBGE: string;
    FGIA: string;
    FDDD: string;
    FSIAFI: string;
    FRetorno: TStrings;
    FTipoBusca: TTipoBusca;
    FTipoRetorno: TTipoRetorno;

    function ValidarCEP: Boolean;
    function ValidarEndereco: Boolean;
    function EndpointPesquisa: string;
    function GetCep: Integer;
    function ProcessarResultado(const sResultado: string): Boolean;
    function ProcessouJSON(const sResultado: string): Boolean;
    function ProcessouXML(const sResultado: string): Boolean;
    function EnderecoValidoParaPesquisa: Boolean;
    procedure PreencherCamposXML(const oXMLNode: IXMLNode);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecutarPesquisa: Boolean;
    function GetURL: string;

  published
    property Cep:         string       read FCep          write FCep;
    property Logradouro:  string       read FLogradouro   write FLogradouro;
    property Complemento: string       read FComplemento  write FComplemento;
    property Bairro:      string       read FBairro       write FBairro;
    property Localidade:  string       read FLocalidade   write FLocalidade;
    property UF:          string       read FUF           write FUF;
    property IBGE:        string       read FIBGE         write FIBGE;
    property GIA:         string       read FGIA          write FGIA;
    property DDD:         string       read FDDD          write FDDD;
    property SIAFI:       string       read FSIAFI        write FSIAFI;
    property TipoBusca:   TTipoBusca   read FTipoBusca    write FTipoBusca;
    property TipoRetorno: TTipoRetorno read FTipoRetorno  write FTipoRetorno;
    property Retorno:     TStrings     read FRetorno;

  end;

procedure Register;

implementation


function TViaCEP.ExecutarPesquisa: Boolean;
begin
  Result := False;

  case FTipoBusca of
    tbCEP:      Result := ValidarCEP;
    tbEndereco: Result := ValidarEndereco
  end;

  if not Result then
    Exit;

  FsURL := EndpointPesquisa;

  if not (GetCep = 200) then
  begin
    TUtils.MsgInformacao(MSG_INFO_PESQUISA_NAO_RET);
    Exit;
  end;

  Result := ProcessarResultado(FRetorno.Text);
end;

function TViaCEP.ValidarEndereco: Boolean;
begin
  Result := False;

  if not EnderecoValidoParaPesquisa then
  begin
    TUtils.MsgErro(MSG_ERRO_CAMPOS_ENDERECO);
    Exit;
  end;

  Result := True;
end;

function TViaCEP.ProcessarResultado(const sResultado: string): Boolean;
begin
  Result := False;

  try
    case TipoRetorno of
      trJSON: Result := ProcessouJSON(sResultado);
      trXML:  Result := ProcessouXML(sResultado);
    end;

  except
    on E: Exception do
    begin
      TUtils.MsgInformacao(MSG_INFO_CEP_NAO_ENCONTRADO);
      Exit;
    end;
  end;
end;

function TViaCEP.ProcessouJSON(const sResultado: string): Boolean;
var
  oJSONValue: TJSONValue;
begin
  Result := False;
  oJSONValue := TJSONObject.ParseJSONValue(sResultado);

  try
    if Assigned(oJSONValue) then
    begin
      Retorno.Clear;

      if oJSONValue is TJSONArray then
      begin
        var oJSONArray := oJSONValue as TJSONArray;

        Retorno.Add(oJSONArray.Format);

        if oJSONArray.Count > 0 then
        begin
          var oFirstItem := oJSONArray.Items[0] as TJSONObject;
          FCep           := oFirstItem.GetValue<string>('cep');
          FLogradouro    := oFirstItem.GetValue<string>('logradouro');
          FComplemento   := oFirstItem.GetValue<string>('complemento');
          FBairro        := oFirstItem.GetValue<string>('bairro');
          FLocalidade    := oFirstItem.GetValue<string>('localidade');
          FUF            := oFirstItem.GetValue<string>('uf');
          FIBGE          := oFirstItem.GetValue<string>('ibge');
          FGIA           := oFirstItem.GetValue<string>('gia');
          FDDD           := oFirstItem.GetValue<string>('ddd');
          FSIAFI         := oFirstItem.GetValue<string>('siafi');
        end;
      end
      else if oJSONValue is TJSONObject then
      begin
        var oJSONObject := oJSONValue as TJSONObject;

        Retorno.Add(oJSONObject.Format);
        FCep         := oJSONObject.GetValue<string>('cep');
        FLogradouro  := oJSONObject.GetValue<string>('logradouro');
        FComplemento := oJSONObject.GetValue<string>('complemento');
        FBairro      := oJSONObject.GetValue<string>('bairro');
        FLocalidade  := oJSONObject.GetValue<string>('localidade');
        FUF          := oJSONObject.GetValue<string>('uf');
        FIBGE        := oJSONObject.GetValue<string>('ibge');
        FGIA         := oJSONObject.GetValue<string>('gia');
        FDDD         := oJSONObject.GetValue<string>('ddd');
        FSIAFI       := oJSONObject.GetValue<string>('siafi');
      end;

      Result := True;
    end;
  finally
    oJSONValue.Free;
  end;
end;

function TViaCEP.ProcessouXML(const sResultado: string): Boolean;
var
  oXMLDocument: IXMLDocument;
  oXMLNode: IXMLNode;
  oChildNode: IXMLNode;
  i: Integer;
begin
  Result := False;
  oXMLDocument := TXMLDocument.Create(nil);

  try
    oXMLDocument.LoadFromXML(sResultado);
    oXMLNode := oXMLDocument.DocumentElement;

    if Assigned(oXMLNode) then
    begin
      for i := 0 to oXMLNode.ChildNodes.Count - 1 do
      begin
        oChildNode := oXMLNode.ChildNodes[i];
        PreencherCamposXML(oXMLNode);
      end;

      Result := True;
    end;
  finally
    oXMLDocument := nil;
    oXMLNode := nil;
    oChildNode := nil;
  end;
end;

procedure TViaCEP.PreencherCamposXML(const oXMLNode: IXMLNode);
begin
  FLogradouro  := VarToStrDef(oXMLNode.ChildValues['logradouro'], '');
  FComplemento := VarToStrDef(oXMLNode.ChildValues['complemento'], '');
  FBairro      := VarToStrDef(oXMLNode.ChildValues['bairro'], '');
  FLocalidade  := VarToStrDef(oXMLNode.ChildValues['localidade'], '');
  FUF          := VarToStrDef(oXMLNode.ChildValues['uf'], '');
  FIBGE        := VarToStrDef(oXMLNode.ChildValues['ibge'], '');
  FGIA         := VarToStrDef(oXMLNode.ChildValues['gia'], '');
  FDDD         := VarToStrDef(oXMLNode.ChildValues['ddd'], '');
  FSIAFI       := VarToStrDef(oXMLNode.ChildValues['siafi'], '');
end;

function TViaCEP.ValidarCEP: Boolean;
var
  icount: Integer;
begin
  Result := False;

  if Length(cep) < 8 then
  begin
    TUtils.MsgAtencao(MSG_ATENCAO_INFORME_CEP_VALIDO);
    Exit;
  end;

  for icount := 1 to Length(cep) do
  begin
    if not CharInSet(cep[icount], ['0'..'9']) then
    begin
      TUtils.MsgErro(MSG_ERRO_APENAS_NUMEROS);
      Exit;
    end;
  end;

  Result := True;
end;

constructor TViaCEP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRetorno := TStringList.Create;
end;

destructor TViaCEP.Destroy;
begin
  FRetorno.Free;
  inherited Destroy;
end;

function TViaCEP.EnderecoValidoParaPesquisa: Boolean;
begin
  Result := ((FUF <> '')
    and (FLocalidade <> '')
    and (FLogradouro <> '')
    and (Length(FUF) = 2)
    and (Length(FLocalidade) >= 3)
    and (Length(FLogradouro) >= 3));
end;

function TViaCEP.EndpointPesquisa: string;
begin
  case FTipoBusca of
    tbCEP:
    begin
      case FTipoRetorno of
        trJSON: Result := Format('https://viacep.com.br/ws/%s/json/', [FCep]);
        trXML:  Result := Format('https://viacep.com.br/ws/%s/xml/',  [FCep]);
      end;
    end;

    tbEndereco:
    begin
      case FTipoRetorno of
        trJSON: Result := Format('https://viacep.com.br/ws/%s/%s/%s/json/', [FUF, FLocalidade, FLogradouro]);
        trXML:  Result := Format('https://viacep.com.br/ws/%s/%s/%s/xml/',  [FUF, FLocalidade, FLogradouro]);
      end;
    end;
  end;
end;

function TViaCEP.GetCep: Integer;
var
  oHTTPClient: THTTPClient;
  oHTTPResponse: IHTTPResponse;
begin
  try
    oHTTPClient := THTTPClient.Create;
    oHTTPResponse := oHTTPClient.Get(FsURL);
    FRetorno.Text:= oHTTPResponse.ContentAsString;

  except
    on E: Exception do
    begin
      TUtils.MsgAtencao(MSG_ERRO_AO_BUSCAR_CEP + #13 + E.Message);
      Exit;
    end;
  end;

  Result := oHTTPResponse.StatusCode;
end;

function TViaCEP.GetURL: string;
begin
  Result := FsURL;
end;

procedure Register;
begin
  RegisterComponents('Softplan', [TViaCEP]);
end;

end.
