
SwapStudy

Um projeto do grupo The Code Breakers - Facens
🚧 Status do Projeto: Em Desenvolvimento (Versão Inicial) 🚧

📖 Descrição
Bem-vindo ao SwapStudy! Este é o protótipo inicial de uma plataforma de troca, onde os usuários podem se cadastrar e adquirir "contratos" (que podem representar serviços, aulas, ou materiais de estudo).

O objetivo é criar um ecossistema onde os membros possam usar um saldo de "moedas" virtuais ou trocar serviços para ter acesso a novos conhecimentos e oportunidades.

Esta primeira versão é uma aplicação de console (CLI) desenvolvida em Java, focada em estabelecer a lógica de negócios principal: cadastro de usuário, visualização de contratos e o sistema de pagamento/saldo.

✨ Funcionalidades Atuais (v0.1 - Console)
Cadastro de Usuário: Permite que um novo usuário se cadastre na plataforma fornecendo nome, e-mail e um saldo inicial.

Listagem de Contratos: Exibe uma lista de contratos pré-definidos disponíveis na plataforma.

Seleção de Contrato: O usuário pode escolher um contrato da lista usando um índice numérico.

Sistema de Pagamento: O usuário pode "pagar" por um contrato de duas formas:

Serviço (S): Uma troca direta (lógica de pagamento ainda não implementada).

Moedas (N): Usando seu saldo virtual.

Validação de Saldo: O sistema verifica se o usuário possui moedas suficientes para adquirir o contrato.

Atualização de Saldo: Se o pagamento for efetuado com moedas, o saldo do usuário é atualizado automaticamente.

🚀 Como Executar
Este projeto é uma aplicação Java baseada em console.

Pré-requisitos
Java Development Kit (JDK): Versão 11 ou superior (o projeto foi testado com OpenJDK 21).

IDE (Recomendado): Visual Studio Code (com o "Java Extension Pack") ou IntelliJ IDEA.

Um Terminal ou Prompt de Comando.

1. Executando via IDE (Recomendado)
Abra a pasta do projeto (ex: ProjetoSwap) na sua IDE.

Certifique-se de que a IDE reconheceu o JDK.

Localize o arquivo Application/Application.java.

Clique com o botão direito e selecione "Run" (Executar).

2. Executando via Linha de Comando (Manual)
Abra seu terminal e navegue até a pasta raiz do projeto (a pasta que contém Application e Entities).

Compile todos os arquivos .java:

Bash

javac Application/Application.java Entities/*.java
Execute a classe principal (note que usamos . ao invés de / para o nome da classe):

Bash

java Application.Application
O programa será iniciado no seu terminal.

📂 Estrutura do Projeto
O projeto está organizado nos seguintes pacotes:

ProjetoSwap/
│
├── Application/
│   └── Application.java   # Classe principal (main), controla o fluxo do console.
│
└── Entities/
    ├── Entitie.java       # Representa o Usuário (nome, email, saldo).
    └── Contrato.java      # Representa o Contrato (contratante, valor).
🧠 Classes Principais
Application.java
É o ponto de entrada do programa. Contém o método main e gerencia toda a interação com o usuário (menus, leitura de dados do Scanner) e orquestra o fluxo da aplicação.

Entitie.java
Representa o Usuário da plataforma.

Atributos: nome, email, saldo.

Métodos-chave:

adicionarContrato(Contrato c): Associa um contrato escolhido ao usuário.

metodoPagamento(char resposta): Processa a lógica de pagamento, verificando o saldo e atualizando-o se necessário.

Contrato.java
Uma classe-modelo (POJO) que representa um Contrato disponível.

Atributos: contratante, valorContrato.

Métodos-chave:

toString(): Formata o contrato para ser exibido de forma legível no console.

🎯 Próximos Passos (Roadmap)
Como este é o início do projeto, os próximos passos planejados incluem:

[ ] Persistência de Dados: Substituir a lista de contratos estática e o cadastro de usuário por um banco de dados (ex: MySQL, PostgreSQL ou H2).

[ ] Criação de Contratos: Permitir que os próprios usuários possam criar e publicar seus contratos.

[ ] Interface Gráfica (GUI): Migrar a aplicação de console para uma interface gráfica (usando JavaFX ou Swing) ou uma aplicação web (usando Spring Boot).

[ ] Sistema de Troca de Serviços: Detalhar a lógica de pagamento com "serviço".

👥 Autores
Este projeto está sendo desenvolvido pelo grupo:

The Code Breakers (Facens)

Pedro Cesar Camargo Dos Santos

Leonardo Barros

Luana moreira de arruda

Pedro Paulo Salvetti

Eduardo Sobral Leite

Yasmin Kamilly Da Silva Antunes

...
