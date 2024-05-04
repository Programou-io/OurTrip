# Padrão de Branch

A implementação de um padrão para nomes de branches é crucial para garantir que sejam descritivas e fáceis de identificar. Além disso, ao seguir o padrão definido, as branches são automaticamente organizadas em uma estrutura de pastas em ferramentas de gestão de Git, como Sourcetree, Kaleidoscope e GitKraken.

## Padrão

```sh
git branch {tipo}/{descricao-curta}-{identificador (opcional)}
```

### Componentes:

- **Tipo**: Identifica o propósito da branch. Exemplos incluem:

  - `feature`: Para novas funcionalidades.
  - `bugfix`: Para correções de bugs.
  - `hotfix`: Para correções urgentes a serem aplicadas diretamente em produção.
  - `docs`: Para adicionar ou atualizar documentação.
  - `release`: Para preparar novas versões.
  - `refactor`: Refatoração de código existente, sem adicionar funcionalidades ou corrigir bugs.
  - `style`: Mudanças que não afetam o significado do código (espaço em branco, formatação, pontuação, etc).
  - `perf`: Melhorias de desempenho que não alteram o comportamento do código.
  - `test`: Adição ou correção de testes existentes.
  - `chore`: Atualizações de tarefas rotineiras e manutenção que não modificam o código-fonte ou os testes.
  - `build`: Alterações que afetam o sistema de build ou dependências externas.
  - `ci`: Alterações nos arquivos e scripts de configuração de integração contínua (CI).

- **Descrição Curta**: Uma descrição concisa do propósito da branch. Deve ser clara o suficiente para que qualquer membro da equipe compreenda o objetivo da branch com uma rápida análise.

  - Utilize o padrão camelCase para a descrição.
  - Mantenha a descrição simples e objetiva.

- **Identificador (opcional)**: Um código ou número único, geralmente vinculado a um ticket no sistema de rastreamento de issues, como JIRA ou GitHub Issues. Isso facilita a ligação direta da branch a um requisito ou problema específico.

### Observações:

- Os nomes das branches devem ser criados em **inglês** para manter a consistência linguística do projeto.

### Exemplos:

- `bugfix/loginEmailValidation`
- `feature/searchUserInCommunity-2342`
- `docs/translateReadmeForBrazilian`
- `release/2.3.1`
