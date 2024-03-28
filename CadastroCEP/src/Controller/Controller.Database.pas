unit Controller.Database;

interface

uses
  Utils.Funcoes,
  Utils.Constantes,
  Model.Database;

type
  TControllerDatabase = class
  private
    ModelDatabase: TModelDatabase;

  public
    constructor Create;
    destructor Destroy; override;
    function ExecutarSQL(sInstrucaoSQL: string): Boolean;
  end;

var
  ControllerDatabase: TControllerDatabase;

implementation

{ TControllerDatabase }

constructor TControllerDatabase.Create;
begin
  inherited;

  ModelDatabase := TModelDatabase.Create(nil);
end;

destructor TControllerDatabase.Destroy;
begin
  ModelDatabase.Destroy;
  inherited;
end;

function TControllerDatabase.ExecutarSQL(sInstrucaoSQL: string): Boolean;
begin
  Result :=  ModelDatabase.ExecutarSQL(sInstrucaoSQL);
end;

initialization
  ControllerDatabase := TControllerDatabase.Create;

finalization
  ControllerDatabase.Destroy;

end.
