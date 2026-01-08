# Project Templates

This directory contains various project templates to help you jumpstart your development with GitHub CLI.

## Available Templates

### 1. [Basic Go Application](templates/basic-app.md)
A simple Go application with:
- Basic project structure
- GitHub Actions CI/CD
- Testing setup
- Module initialization

**Best for**: CLI tools, APIs, backend services

### 2. [Web Application](templates/web-app.md)
A Node.js web application with:
- Express server
- Frontend HTML/CSS/JavaScript
- REST API example
- Development workflow

**Best for**: Web services, APIs, full-stack applications

### 3. [Python Project](templates/python-project.md)
A Python project with:
- Virtual environment
- pytest testing
- Code formatting (black)
- Linting (flake8)
- CI/CD pipeline

**Best for**: Data science, automation, backend services

## How to Use

1. Choose a template that matches your project type
2. Follow the step-by-step instructions in the template
3. Customize the generated code for your needs
4. Use `gh` commands to manage your project

## Quick Start Commands

All templates follow a similar pattern:

```bash
# 1. Create repository
gh repo create my-project --public --clone
cd my-project

# 2. Follow template-specific setup

# 3. Commit and push
git add .
git commit -m "Initial commit"
git push -u origin main
```

## GitHub CLI Features

Enhance your workflow with these `gh` commands:

### Repository Management
```bash
gh repo create               # Create a new repository
gh repo clone                # Clone a repository
gh repo view                 # View repository details
gh repo fork                 # Fork a repository
```

### Issue Tracking
```bash
gh issue create              # Create a new issue
gh issue list                # List issues
gh issue view <number>       # View issue details
gh issue close <number>      # Close an issue
```

### Pull Requests
```bash
gh pr create                 # Create a pull request
gh pr list                   # List pull requests
gh pr checkout <number>      # Checkout a pull request
gh pr merge <number>         # Merge a pull request
```

### Actions & Workflows
```bash
gh workflow list             # List workflows
gh workflow run <name>       # Run a workflow
gh run list                  # List workflow runs
gh run view <id>             # View run details
```

## Customization

Each template can be customized:

1. **Project structure**: Add or remove directories as needed
2. **Dependencies**: Update `package.json`, `requirements.txt`, or `go.mod`
3. **CI/CD**: Modify `.github/workflows/` files
4. **Documentation**: Update README files with your project details

## Contributing

To add a new template:

1. Create a new markdown file in `templates/`
2. Follow the existing template format
3. Include complete setup instructions
4. Add an entry to this index
5. Submit a PR with your changes

## Resources

- [GitHub CLI Manual](https://cli.github.com/manual/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Docs](https://docs.github.com/)

## Support

For issues or questions:
- View the [GitHub CLI documentation](https://cli.github.com/manual/)
- Open an issue with `gh issue create`
- Check existing issues with `gh issue list`
