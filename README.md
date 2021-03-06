# README

## PROJETO PAYNOW - TREINADEV 06

### SOBRE

Uma escola de programação, a CodePlay, decidiu lançar uma plataforma de cursos online de
programação. Você já está trabalhando nesse projeto e agora vamos começar uma nova etapa:
uma ferramenta de pagamentos capaz de configurar os meios de pagamentos e registrar as
cobranças referentes a cada venda de curso na CodePlay. O objetivo deste projeto é construir
o mínimo produto viável (MVP) dessa plataforma de pagamentos.
Na plataforma de pagamentos temos dois perfis de usuários: os administradores da plataforma
e os donos de negócios que querem vender seus produtos por meio da plataforma, como as
pessoas da CodePlay, por exemplo. Os administradores devem cadastrar os meios de
pagamento disponíveis, como boletos bancários, cartões de crédito, PIX etc, especificando
detalhes de cada formato. Administradores também podem consultar os clientes da plataforma,
consultar e avaliar solicitações de reembolso, bloquear compras por suspeita de fraudes etc.
Já os donos de negócios devem ser capazes de cadastrar suas empresas e ativar uma conta
escolhendo quais meios de pagamento serão utilizados. Devem ser cadastrados também os
planos disponíveis para venda, incluindo seus valores e condições de desconto de acordo com
o meio de pagamento. E a cada nova venda realizada, devem ser armazenados dados do
cliente, do produto selecionado e do meio de pagamento escolhido. Um recibo deve ser emitido
para cada pagamento e esse recibo deve ser acessível para os clientes finais, alunos da
CodePlay no nosso contexto.

### STACK

- Ruby 3.0.0
- Rails 6.1.3.2

### GEMS

- Rspec
- Capybara
- Devise
- CPF/CNPJ
- PaperTrail
- SimpleCov

### INICIANDO

```
git clone https://github.com/ericdaher/treinadev-paynow
cd treinadev-paynow
bin/setup
rails s
```

### TESTANDO

- É possível executar todos os testes com o comando `rspec`, ou executar um teste específico. Por exemplo:

```
rspec spec/system/visitor/visitor_visits_homepage_spec.rb
```

- Ao executar testes, um arquivo de cobertura pode ser encontrado em coverage/index.html
