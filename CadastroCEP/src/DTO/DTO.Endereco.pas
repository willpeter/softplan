unit DTO.Endereco;

interface

type
  TDTOEndereco = class
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
  end;

implementation

end.

