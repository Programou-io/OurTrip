# Branch Pattern

Implementing a standard for branch names is crucial to ensure they are descriptive and easy to identify. Additionally, following the defined pattern automatically organizes the branches into a folder structure in Git management tools like Sourcetree, Kaleidoscope, and GitKraken.

## Pattern

```sh
git branch {type}/{short-description}-{identifier (optional)}
```

### Components:

- **Type**: Identifies the purpose of the branch. Examples include:

  - `feature`: For new functionalities.
  - `bugfix`: For bug corrections.
  - `hotfix`: For urgent corrections to be applied directly in production.
  - `docs`: For adding or updating documentation.
  - `release`: For preparing new releases.
  - `refactor`: Refactoring existing code, without adding functionalities or correcting bugs.
  - `style`: Changes that do not affect the meaning of the code (white space, formatting, punctuation, etc).
  - `perf`: Performance improvements that do not alter the code behavior.
  - `test`: Adding or correcting existing tests.
  - `chore`: Routine task updates and maintenance that do not modify the source code or tests.
  - `build`: Changes that affect the build system or external dependencies.
  - `ci`: Changes in the files and scripts of continuous integration (CI) configuration.

- **Short Description**: A concise description of the branch's purpose. It should be clear enough for any team member to understand the objective of the branch at a quick glance.

  - Use the camelCase pattern for the description.
  - Keep the description simple and straightforward.

- **Identifier (optional)**: A unique code or number, usually linked to a ticket in the issue tracking system, such as JIRA or GitHub Issues. This facilitates a direct link between the branch and a specific requirement or issue.

### Notes:

- Branch names should be created in **English** to maintain linguistic consistency across the project.

### Examples:

- `bugfix/loginEmailValidation`
- `feature/searchUserInCommunity-2342`
- `docs/translateReadmeForBrazilian`
- `release/2.3.1`
