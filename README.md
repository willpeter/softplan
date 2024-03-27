# softplan
Componente de interação com a API ViaCEP + Sistema de Cadastro e Busca de Ceps (utilizando o componente.)
A unit "ViaCEP" é um componente para Delphi que facilita a consulta de informações relacionadas a CEP (Código de Endereçamento Postal) usando a API pública do ViaCEP. 

Funcionalidades:

O componente permite realizar pesquisas de CEP e endereço.
Ao executar uma pesquisa, o componente faz uma chamada à API do ViaCEP para obter os dados relacionados ao CEP ou endereço informado.
O resultado da pesquisa pode ser retornado em formato JSON ou XML, dependendo da configuração do componente.
Padrões de projeto:

O código faz uso do padrão de projeto "Componente" do Delphi, derivando a classe TViaCEP da classe TComponent. Isso permite que o componente seja facilmente instalado e utilizado no ambiente de desenvolvimento do Delphi.
A classe TViaCEP possui propriedades para configurar e acessar os dados relacionados à pesquisa, como CEP, logradouro, complemento, bairro, localidade, UF, etc.
O código utiliza o padrão de projeto "Strategy" para lidar com diferentes tipos de busca (CEP ou endereço) e tipos de retorno (JSON ou XML). Isso é feito com o uso dos tipos enumerados TTipoBusca e TTipoRetorno e com a utilização de estruturas condicionais.
O componente utiliza a classe THTTPClient da biblioteca System.Net.HttpClient para realizar as requisições HTTP à API do ViaCEP.
Além disso, o código possui métodos para validar os dados informados antes de realizar a pesquisa, para processar o resultado da pesquisa (em formato JSON ou XML) e preencher os campos correspondentes do componente.
