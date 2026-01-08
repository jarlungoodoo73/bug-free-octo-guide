# Jumpstart Your Project with GitHub CLI

This guide helps you quickly get started with GitHub CLI (`gh`) to jumpstart your development workflow.

## Quick Start

### 1. Authentication
First, authenticate with GitHub:

```bash
gh auth login
```

### 2. Create a New Repository
Quickly create and initialize a new repository:

```bash
gh repo create my-project --public --clone
cd my-project
```

### 3. Initialize Your Project
Set up a basic project structure:

```bash
# Create a README
echo "# My Project" > README.md

# Create initial commit
git add .
git commit -m "Initial commit"
git push -u origin main
```

### 4. Common Workflows

#### Working with Pull Requests
```bash
# Create a new branch
git checkout -b feature-branch

# Make changes and commit
git add .
git commit -m "Add new feature"

# Create a pull request
gh pr create --title "Add new feature" --body "Description of changes"
```

#### Working with Issues
```bash
# Create an issue
gh issue create --title "Bug report" --body "Description of the bug"

# List issues
gh issue list

# View an issue
gh issue view 123
```

#### Repository Management
```bash
# Clone a repository
gh repo clone owner/repo

# Fork a repository
gh repo fork owner/repo

# View repository details
gh repo view
```

## Next Steps

- Explore more `gh` commands with `gh --help`
- Set up aliases for frequently used commands with `gh alias set`
- Install GitHub CLI extensions with `gh extension install`

For more information, visit the [GitHub CLI documentation](https://cli.github.com/manual/).
