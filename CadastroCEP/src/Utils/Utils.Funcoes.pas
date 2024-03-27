unit Utils.Funcoes;

interface

uses
  Winapi.WinSvc,
  Winapi.Windows,
  ComObj,
  ShellAPI,
  System.Win.Registry,
  WinInet,
  Vcl.Dialogs,
  Vcl.SvcMgr,
  Vcl.Forms,
  System.IOUtils,
  System.Classes,
  System.SysUtils,
  IniFiles,
  Utils.Constantes;

type
  TUtils = class

  public
    class function CaminhoArquivoINI: string;
    class function CaminhoArquivoLog: string;
    class procedure CriarArquivoIniPadrao;
    class procedure GravarLog(const texto: string);
    class procedure MsgAtencao(const sMsg: string);
    class procedure MsgInformacao(const sMsg: string);
    class procedure MsgErro(const sMsg: string);
    class function MsgPergunta(const sMsg: string): Boolean;
    class function RemoverQuebrasDeLinha(const str: string): string;
    class function SomenteNumeros(const sNumeros: string): string;

  end;


implementation


{ TUtils }

class function TUtils.CaminhoArquivoINI: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + NOME_ARQ_CONFIGURACAO;
end;

class function TUtils.CaminhoArquivoLog: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + NOME_ARQ_LOG;
end;

class procedure TUtils.CriarArquivoIniPadrao;
var
  oIniFile: TIniFile;
begin
  if FileExists(CaminhoArquivoINI) then
    Exit;

  oIniFile := TIniFile.Create(CaminhoArquivoINI);

  try
    oIniFile.WriteString('PG', 'DriverID',  PG_DRIVERID);
    oIniFile.WriteString('PG', 'Database',  PG_DATABASE);
    oIniFile.WriteString('PG', 'User_Name', PG_USERNAME);
    oIniFile.WriteString('PG', 'Password',  PG_PASSWORD);
    oIniFile.WriteString('PG', 'Server',    PG_SERVER);
    oIniFile.WriteString('PG', 'Port',      PG_PORT);

  finally
    oIniFile.Free;
  end;
end;

class procedure TUtils.GravarLog(const texto: string);
var
  arquivoLog: TextFile;
begin
  if Trim(texto) = '' then
    Exit;

  AssignFile(arquivoLog, CaminhoArquivoLog);

  try
    if not FileExists(CaminhoArquivoLog) then
      Rewrite(arquivoLog)
    else
      Append(arquivoLog);

    try
      Writeln(arquivoLog, '-------------------');
      Writeln(arquivoLog, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
      Writeln(arquivoLog, RemoverQuebrasDeLinha(texto));

    finally
      CloseFile(arquivoLog);
    end;

  except
    on E: Exception do
    begin
      AssignFile(arquivoLog, CaminhoArquivoLog);

      try
        Append(arquivoLog);
        Writeln(arquivoLog, 'Ocorreu um erro ao gravar o log: ' + RemoverQuebrasDeLinha(E.Message));
      finally
        CloseFile(arquivoLog);
      end;
    end;
  end;
end;

class procedure TUtils.MsgAtencao(const sMsg: string);
begin
  Application.MessageBox(PChar(sMsg), 'Atenção', MB_OK or MB_ICONWARNING);
end;

class procedure TUtils.MsgErro(const sMsg: string);
begin
  Application.MessageBox(PChar(sMsg), 'Erro', MB_OK or MB_ICONERROR);
end;

class procedure TUtils.MsgInformacao(const sMsg: string);
begin
  Application.MessageBox(PChar(sMsg), 'Atenção', MB_OK or MB_ICONINFORMATION);
end;

class function TUtils.MsgPergunta(const sMsg: string): Boolean;
begin
  Result := False;

  if Application.MessageBox(PChar(sMsg), 'Confirme', MB_YESNO or MB_ICONQUESTION) = IDYES then
    Result:= True;
end;

class function TUtils.RemoverQuebrasDeLinha(const str: string): string;
var
  i: Integer;
begin
  Result := str;

  for i := Length(Result) downto 1 do
  begin
    if (Result[i] = #13) or (Result[i] = #10) then
      Result[i] := ' ';
  end;
end;

class function TUtils.SomenteNumeros(const sNumeros: string): string;
var
  iCount: Integer;
begin
  Result := '';
  for iCount := 1 to Length(sNumeros) do
  begin
    if CharInSet(sNumeros[iCount], ['0'..'9']) then
      Result := Result + sNumeros[iCount];
  end;
end;

end.
