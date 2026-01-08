# Basic Application Template

This template provides a starting point for building applications with GitHub CLI integration.

## Project Structure

```
my-project/
├── .github/
│   └── workflows/
│       └── ci.yml
├── src/
│   └── main.go
├── README.md
├── .gitignore
└── go.mod
```

## Setup Steps

### 1. Create Repository
```bash
gh repo create my-project --public --clone
cd my-project
```

### 2. Initialize Go Module
```bash
go mod init github.com/username/my-project
```

### 3. Create Basic Application
```bash
mkdir src
cat > src/main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, GitHub CLI!")
}
EOF
```

### 4. Create .gitignore
```bash
cat > .gitignore << 'EOF'
# Binaries
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary
*.test

# Output
/bin/
/dist/
EOF
```

### 5. Create GitHub Actions Workflow
```bash
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    - run: go build -v ./...
    - run: go test -v ./...
EOF
```

### 6. Commit and Push
```bash
git add .
git commit -m "Initial project setup"
git push -u origin main
```

## Next Steps

1. Add dependencies: `go get <package>`
2. Create issues for planned features: `gh issue create`
3. Set up branch protection rules: `gh api repos/:owner/:repo/branches/main/protection`
4. Create your first PR: `gh pr create`

## Using This Template

To use this template for your own project:

1. Follow the setup steps above
2. Customize the application code in `src/`
3. Update this README with your project details
4. Add tests and additional workflows as needed
