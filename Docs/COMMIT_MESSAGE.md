# Commit Message Standards

Standardizing commit messages is crucial for maintaining an organized and descriptive history. This practice makes understanding the changes easier and improves project maintenance.

> **Important!**
> In addition to using descriptive messages, it is advisable to make commits for small changes. This allows the descriptions to be more precise and cohesive.

Avoid bundling multiple changes in a single commit. While this requires a bit more effort, the benefits are significant in terms of clarity and project management.

## Chosen Standard

We have chosen to use [Gitmoji](https://gitmoji.dev) to standardize our commit messages.

The language for commit messages should be **English** to maintain an international standard.

## Recommended Tool

To facilitate the use of Gitmojis, you can use the CLI tool [gitmoji-cli](https://github.com/carloscuesta/gitmoji-cli). See more details at the provided link.

## Examples of Commit Messages

**Example 1:** Implementation of a user search feature on the community screen.

```sh
git commit -m "✨ Added user search feature on the community screen"
```

**Example 2:** Correction of the email validation for the user login form.

```sh
git commit -m "🐛 Corrected the email validation on the login form"
```

**Example 3:** Configuration of the pipeline for the iOS app on GitHub using Actions.

```sh
git commit -m "⚙️ Configured the iOS app pipeline using GitHub Actions"
```

**Example 4:** Addition of a new translation of the README to Brazilian Portuguese.

```sh
git commit -m "📝 Added translation of the README to Brazilian Portuguese"
```

**Example 5:** Update of the Snapkit version.

```sh
git commit -m "⬆️ Updated the Snapkit version from 'x.x.x' to 'y.y.y'"
```

> Tip: If you have difficulty creating messages, consider using an Artificial Intelligence assistant. We provide a [**Prompt**](COMMIT_MESSAGE_AI_PROMPT.md) that can help you request a commit message from AI based on your description.
