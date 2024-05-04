# Prompt para criação de mensagens de commit usando IA

## Como usar

1. Abra sua IA de preferencia
2. Copie o prompt diponibilizado na seção a seguir
3. Coloe na compo de texto da IA
4. Preencha-o da forma adequada
5. envie e aguarde a resposta da IA

## Prompt

```txt
Sou engenheiro de software trabalhando em um projeto open source que adota o padrão 'gitmoji' para mensagens de commit. Preciso de ajuda para criar uma mensagem de commit sucinta e coesa.

Por favor, crie uma mensagem descritiva, porém breve, para a mudança que realizei. Abaixo, forneci uma breve descrição em {{coloque_o_idioma_da_descrição_a_seguir}}:

{{descreva_aqui_sua_implementação}}

Lembre-se de seguir estas diretrizes:
- Utilize gitmoji para simbolizar o tipo de mudança feita.
- A mensagem deve conter entre 6 e 15 palavras.
- A mensagem de commit deve ser em inglês.
- Na mensagem de commit, use o ícone ao invés da tag.
```

**Exemplo de uso**

Sou engenheiro de software trabalhando em um projeto open source que adota o padrão 'gitmoji' para mensagens de commit. Preciso de ajuda para criar uma mensagem de commit sucinta e coesa.

Por favor, crie uma mensagem descritiva, porém breve, para a mudança que realizei. Abaixo, forneci uma breve descrição em Portugues do Brasil:

Corrigi um erro na tela de login a validação do formulário que pedia o email do usuário, isso faz com que o usuário apenas possa colocar um email com formato valido

Lembre-se de seguir estas diretrizes:

- Utilize gitmoji para simbolizar o tipo de mudança feita.
- A mensagem deve conter entre 6 e 15 palavras.
- A mensagem de commit deve ser em inglês.
- Na mensagem de commit, use o ícone ao invés da tag.

**Resultado**

```txt
🐛 Fix email validation on login screen to enforce correct format
```
