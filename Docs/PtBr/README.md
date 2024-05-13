# 🌍 OurTrip: Planejamento de Viagens Compartilhado

Este aplicativo facilita o planejamento e a organização de viagens para grupos. Com OurTrip, planejar sua próxima aventura em grupo fica mais fácil e interativo!

## 🌟 Motivação

OurTrip é um projeto open source desenvolvido pela comunidade SwiftConnect. Nosso objetivo é oferecer aos desenvolvedores a experiência de contribuir em um projeto significativo, desenvolvendo suas habilidades em um ambiente colaborativo e divertido!

Nos ajude a divulgar ainda mais esse projeto, para isso, clique no botão "⭐️ Star" no canto superior direito do navegador para ajudar o repositório a ser melhor rankeado. Se possível compartilhe 😉

## 🗃️ Leia no seu idioma de preferência

- [🇧🇷 Português (Brasileiro)](./docs/README.md)
- [🇺🇸 Ingles (Americano)](./README.md)

Não encontrou seu idioma? Caso queira pode contribuir com o rrepositório adicionando uma tradução para a documentação.

1. Acesse a aba [Issues do repositório](https://github.com/PaoloProdossimoLopes/OurTrip/issues).
2. Clique em "New issue".
3. Selecione o modelo "💬 Sugerir nova funcionalidade".
4. Preencha as informações solicitadas com as suas ideias.
5. Submeta sua tradução!

Sua tradução será analisada e, se aprovada, iremos mergea-la.

## 🧩 Requisitos

- Docker
- Xcode 15+
- Swiftlint
- Tuist
- Vapor

## 🛤️ Como rodar o projeto

1. Clone o repositorio localmente
2. Acesse a pasta `OurTrip`

**Frontend**

Para rodar o projeto frontend acesse o cominho `apps/frontend` a partir da raiz e siga os seguintes passos

1. Rode o comando `tuist generate`
2. Abra o arquivo `Ourtrip.xcworkspace` gerado pelo tuist
3. Faça o build

Após isso app sera disponibilizado no simulador escolhido

**Backend**

Para rodar o projeto backend acesse o cominho `apps/backend` a partir da raiz e siga os seguintes passos

1. Rode o comando `docker-composer up -d` (pode demorar um pouco)
1. Rode o comando `swift run App migrate`
1. Abra o arquivo `Package.swift` com o Xcode
1. Faça o build da aplicação para subir o servidor local

Após isso app sera disponibilizado na porta 8080

## 🚀 Como Sugerir uma Melhoria

Quer ajudar a fazer o OurTrip ainda melhor? Siga os passos abaixo para adicionar sua pitada de magia:

1. Acesse a aba [Issues do repositório](https://github.com/PaoloProdossimoLopes/OurTrip/issues).
2. Clique em "New issue".
3. Selecione o modelo "✨ Sugerir nova funcionalidade".
4. Preencha as informações solicitadas.
5. Submeta sua ideia brilhante!

Sua sugestão será analisada e, se aprovada, adicionaremos um card para desenvolvimento. Fique atento a possíveis contatos por comentários na sua issue ou por e-mail!

## 🐛 Reportar um Problema

Oops! Encontrou um bug? Ajude-nos a corrigi-lo seguindo estes passos:

1. Acesse a aba [Issues do repositório](https://github.com/PaoloProdossimoLopes/OurTrip/issues).
2. Clique em "New issue".
3. Selecione o modelo "🐛 Reportar um problema".
4. Preencha as informações solicitadas.
5. Envie sua solicitação para salvar o dia!

Após análise, abriremos um card para a solução heroica do problema.

_Obs: Caso você mesmo queira atuar diretamente, pode pular para seção "🤝 Como Contribuir" descrita nesse documento._

## ❓ Dúvidas ou Ajuda

Precisa de ajuda ou tem uma dúvida? Não se acanhe! 🙋‍♂️

1. Acesse a aba [Discussions](https://github.com/PaoloProdossimoLopes/OurTrip/discussions)
2. Verifique se sua questão já foi abordada em issues abertas ou fechadas.
3. Caso não tenha, clique em "New Discussion" para iniciar uma nova discussão.
4. Selecione a categoria "Q&A".
5. Envie sua dúvida para podermos ajudar!

Encerre sua discussão após ter sua dúvida esclarecida. Lembre-se: discussões inativas por mais de um mês serão fechadas automaticamente, mas podem ser reabertas se necessário.

_obs: Na aba de discussões do repositório tem várias categorias além de dúvida, aproveite, esses tópicos podem te ajudar em algo ou você mesmo pode ajudar outra pessoa_

## 🤝 Como Contribuir

Pronto para colocar a mão na massa? Siga estes passos:

1. Faça um [fork do projeto](https://docs.github.com/pt/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks).
2. Clone o projeto localmente.
3. Crie sua branch seguindo nosso padrão em [BRANCH_PATTERN.md](./BRANCH_PATTERN.md).
4. Implemente suas alterações.
5. Realize o commit conforme nossa convenção em [COMMIT_MESSAGE.md](./COMMIT_MESSAGE.md).
6. Faça um push para seu repositório remoto.
7. Abra um pull request conforme nosso template.
8. Preencha adequadamente o pull request.

🛠 Pull requests devem passar pela CI antes da revisão. A aprovação requer no mínimo dois revisores: um contribuidor experiente e um administrador do repositório.

## 📜 Licença

Quer saber mais sobre como estamos compartilhando? Confira mais informações sobre a licença no [LICENSE](./../../LICENSE).

## ✌🏼 Código de Conduta

Levamos muito a sério o nosso [Código de Conduta](./CODE_OF_CONDUCT). Comprometemo-nos a proporcionar um ambiente saudável e respeitoso para todos os colaboradores. Acreditamos que um ambiente comunitário positivo é fundamental para fomentar a colaboração e o desenvolvimento contínuo. Encorajamos todos a participar e a contribuir de maneira construtiva.

## 👥 Comunidade

Ficou curioso a respeito da nossa comunidade? Acesse nosso [Notion](https://paolo-prodossimo-lopes.notion.site/Swift-Connect-Feed-b2f769f82c524b1e84faa582e4d983e6) e saiba mais!
