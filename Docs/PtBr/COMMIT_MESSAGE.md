# Padrão de Mensagens de Commit

É crucial padronizar as mensagens de commit para manter um histórico organizado e descritivo. Esta prática facilita a compreensão das alterações e melhora a manutenção do projeto.

> **Importante!**
> Além de utilizar mensagens descritivas, é recomendável fazer commits de pequenas alterações. Isso permite que as descrições sejam mais precisas e coesas.

Evite agrupar múltiplas mudanças em um único commit. Embora isso requeira um pouco mais de esforço, os benefícios são significativos em termos de clareza e gerenciamento do projeto.

## Padrão Escolhido

Optamos por usar o [Gitmoji](https://gitmoji.dev) para padronizar nossas mensagens de commit.

O idioma das mensagens de commit devem ser em **Ingles** para manter um padrão internacional.

## Ferramenta Recomendada

Para facilitar a utilização dos Gitmojis, você pode usar a ferramenta CLI [gitmoji-cli](https://github.com/carloscuesta/gitmoji-cli). Veja mais detalhes no link fornecido.

## Exemplos de Mensagens de Commit

**Exemplo 1:** Implementação de uma busca por usuário na tela de comunidade.

```sh
git commit -m "✨ Adicionado recurso de busca por usuário na tela de comunidade"
```

**Exemplo 2:** Correção na validação do e-mail do usuário no formulário de login.

```sh
git commit -m "🐛 Corrigida a validação do e-mail no formulário de login"
```

**Exemplo 3:** Configuração da pipeline para a aplicação iOS no GitHub usando Actions.

```sh
git commit -m "⚙️ Configurada pipeline do app iOS usando GitHub Actions"
```

**Exemplo 4:** Adição de uma nova tradução do README para o Português brasileiro.

```sh
git commit -m "📝 Adicionada tradução do README para Português (Brasil)"
```

**Exemplo 5:** Atualização da versão do Snapkit.

```sh
git commit -m "⬆️ Atualizada versão do Snapkit de 'x.x.x' para 'y.y.y'"
```

> Dica: Se tiver dificuldade para criar mensagens, considere usar um assistente de Inteligência Artificial. Fornecemos um [**Prompt**](./../COMMIT_MESSAGE_AI_PROMPT.md) que pode ajudá-lo a solicitar à IA uma mensagem de commit baseada em sua descrição.
