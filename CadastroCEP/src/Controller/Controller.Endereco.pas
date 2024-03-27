unit Controller.Endereco;

interface

uses
  Model.Endereco,
  DTO.Endereco;


type
  TControllerEndereco = class
  private
    ModelEndereco: TModelEndereco;

  public
    constructor Create;
    destructor Destroy;
    function NovoRegistro(oDtoEndereco: TDTOEndereco): Boolean;
    function UpdateRegistro(oDtoEndereco: TDTOEndereco): Boolean;
    function CepCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
    function EnderecoCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
  end;

var
  ControllerEndereco: TControllerEndereco;


implementation


{ TControllerEndereco }

constructor TControllerEndereco.Create;
begin
  inherited;
  ModelEndereco := Model.Endereco.ModelEndereco;
end;

destructor TControllerEndereco.Destroy;
begin
  ModelEndereco.Destroy;
  inherited;
end;

function TControllerEndereco.EnderecoCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
begin
  Result := TModelEndereco.EnderecoCadastrado(oDtoEndereco);
end;

function TControllerEndereco.CepCadastrado(oDtoEndereco: TDTOEndereco): TDTOEndereco;
begin
  Result := TModelEndereco.CepCadastrado(oDtoEndereco);
end;

function TControllerEndereco.NovoRegistro(oDtoEndereco: TDTOEndereco): Boolean;
begin
  Result := TModelEndereco.NovoRegistro(oDtoEndereco);
end;

function TControllerEndereco.UpdateRegistro(
  oDtoEndereco: TDTOEndereco): Boolean;
begin
  Result := TModelEndereco.UpdateRegistro(oDtoEndereco);
end;



end.
