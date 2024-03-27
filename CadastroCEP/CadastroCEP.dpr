program CadastroCEP;

uses
  Vcl.Forms,
  View.Main in 'src\View\View.Main.pas' {ViewMain},
  Utils.Funcoes in 'src\Utils\Utils.Funcoes.pas',
  Utils.Constantes in 'src\Utils\Utils.Constantes.pas',
  Model.Database in 'src\Model\Model.Database.pas' {ModelDatabase: TDataModule},
  Controller.Database in 'src\Controller\Controller.Database.pas',
  Model.Endereco in 'src\Model\Model.Endereco.pas',
  Controller.Endereco in 'src\Controller\Controller.Endereco.pas',
  DTO.Endereco in 'src\DTO\DTO.Endereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewMain, ViewMain);
  Application.Run;
end.
