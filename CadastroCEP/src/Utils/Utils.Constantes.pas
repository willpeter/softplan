unit Utils.Constantes;

interface

const
  // Variaveis
  STRING_INDEFINIDO = '';

  // Nomes de arquivos
  NOME_ARQ_LOG = 'Log.txt';
  NOME_ARQ_CONFIGURACAO = 'Config.ini';


  // Tabelas do sistema
  NOME_TABELA_ENDERECOS = 'Enderecos';


  //Dados Default BD - para criacao do arquivo .ini
  PG_DRIVERID = 'PG';
  PG_DATABASE = 'postgres';
  PG_USERNAME = 'postgres';
  PG_PASSWORD = '123';
  PG_SERVER   = 'localhost';
  PG_PORT     = '5432';

  // Mensagens Sucesso
  MSG_OK_ADD_ENDERECO = ' - CEP CADASTRADO com sucesso na base de dados!';
  MSG_OK_EDIT_ENDERECO = ' - CEP ATUALIZADO com sucesso na base de dados!';

  // Mensagem Info
  MSG_INFO_CEP_EXISTENTE = ' - CEP EXISTENTE na base de dados.';
  MSG_INFO_CEP_NAO_ENCONTRADO = 'O CEP informado n�o foi encontrado!';
  MSG_INFO_PESQUISA_NAO_RET = 'A pesquisa n�o obteve resultados!';

  // Mensagens Atencao
  MSG_ATENCAO_INFORME_CEP_VALIDO = 'Informe um CEP v�lido.';

  // Mensagens Perguntas
  MSG_PERGUNTA_CEP_EXISTE_BD = 'O Cep encontra-se na base! O que deseja fazer?' +#13+#13+
                               'Clique em SIM para ver o endere�o j� registrado.'+#13+
                               'Clique em N�O para substitu�-lo pelos dados de uma nova consulta.';

  // Mensagens de Erro
  MSG_ERRO_CONEXAO_BD             = 'Falha ao conectar com o Banco de Dados.' + #13 +
                                    'Verifique as configura��es do arquivo ' + NOME_ARQ_CONFIGURACAO +
                                    ' e confira o arquivo de Log.';
  MSG_ERRO_CRIAR_TABELA_ENDERECOS = 'Falha ao criar a tabela Enderecos.' + #13 +
                                    'Verifique o arquivo de Log.';
  MSG_ERRO_DEFINE_EXECUCAO_FALHA  = 'Verifique as configura��es e log gerado';
  MSG_ERRO_CONSISTIR_BD           = 'Ocorreu um erro ao consistir a base e dados.' + #13 + 'Verifique o arquivo de log.';
  MSG_ERRO_PROC_REQUISICAO        = 'Erro ao processar a requisi��o';
  MSG_ERRO_DADOS_EM_BRANCO        = 'N�o � aceito campos em branco (sem conte�do)';
  MSG_ERRO_CAMPOS_ENDERECO        = 'N�o ser� efetuada a pesquisa quando:' +#13+#13+
                                    '1. O campo UF possuir menos de 2 caracteres.' +#13+
                                    '2. Os campos Localidade e Logradouro possuirem menos de 3 caracteres.';
  MSG_ERRO_APENAS_NUMEROS         = 'Apenas n�meros s�o permitidos no CEP.';
  MSG_ERRO_AO_BUSCAR_CEP          = 'Erro ao buscar o CEP.';


implementation

end.
