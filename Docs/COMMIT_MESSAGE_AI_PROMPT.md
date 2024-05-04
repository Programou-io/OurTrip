# Prompt for Creating Commit Messages Using AI

## How to Use

1. Open your preferred AI tool.
2. Copy the prompt provided in the following section.
3. Paste it into the AI's text field.
4. Fill it out appropriately.
5. Submit and wait for the AI's response.

## Prompt

```txt
I am a software engineer working on an open-source project that adopts the 'gitmoji' standard for commit messages. I need help creating a succinct and cohesive commit message.

Please create a descriptive yet brief message for the change I made. Below, I have provided a brief description in {{insert_description_language_here}}:

{{describe_your_implementation_here}}

Remember to follow these guidelines:
- Use gitmoji to symbolize the type of change made.
- The message should contain between 6 and 15 words.
- The commit message must be in English.
- In the commit message, use the icon instead of the tag.
```

**Example of use**

I am a software engineer working on an open-source project that adopts the 'gitmoji' standard for commit messages. I need help creating a succinct and cohesive commit message.

Please create a descriptive yet brief message for the change I made. Below, I have provided a brief description in PT-BR:

Corrigi um erro na tela de login a validação do formulário que pedia o email do usuário, isso faz com que o usuário apenas possa colocar um email com formato valido

Remember to follow these guidelines:

- Use gitmoji to symbolize the type of change made.
- The message should contain between 6 and 15 words.
- The commit message must be in English.

**Result:**

```txt
🐛 Fix email validation on login screen to enforce correct format
```
