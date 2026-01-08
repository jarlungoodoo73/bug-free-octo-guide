# Python Project Template

Quick-start template for creating a Python project with GitHub CLI.

## Features
- Python 3.9+
- Virtual environment setup
- Testing with pytest
- GitHub Actions CI/CD

## Quick Setup

### 1. Create Repository
```bash
gh repo create my-python-project --public --clone
cd my-python-project
```

### 2. Set Up Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Create Project Structure
```bash
mkdir src tests
touch src/__init__.py tests/__init__.py
```

### 4. Create Main Application
```bash
cat > src/main.py << 'EOF'
"""Main application module."""

def greet(name: str) -> str:
    """Return a greeting message."""
    return f"Hello, {name}! Welcome to GitHub CLI."

def main():
    """Main entry point."""
    message = greet("Developer")
    print(message)

if __name__ == "__main__":
    main()
EOF
```

### 5. Create Tests
```bash
cat > tests/test_main.py << 'EOF'
"""Tests for main module."""

from src.main import greet

def test_greet():
    """Test the greet function."""
    result = greet("Test")
    assert result == "Hello, Test! Welcome to GitHub CLI."
    assert "Test" in result
EOF
```

### 6. Create requirements.txt
```bash
cat > requirements.txt << 'EOF'
# Production dependencies
requests>=2.28.0

# Development dependencies
pytest>=7.0.0
pytest-cov>=4.0.0
black>=22.0.0
flake8>=5.0.0
mypy>=0.990
EOF

pip install -r requirements.txt
```

### 7. Create .gitignore
```bash
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
ENV/
env/
.venv

# Testing
.pytest_cache/
.coverage
htmlcov/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
```

### 8. Create Setup File
```bash
cat > setup.py << 'EOF'
from setuptools import setup, find_packages

setup(
    name="my-python-project",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "requests>=2.28.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "pytest-cov>=4.0.0",
            "black>=22.0.0",
            "flake8>=5.0.0",
        ],
    },
    python_requires=">=3.9",
)
EOF
```

### 9. Create GitHub Actions Workflow
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
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.9', '3.10', '3.11', '3.12']
    
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Lint with flake8
      run: |
        flake8 src tests --max-line-length=100
    
    - name: Format check with black
      run: |
        black --check --diff src tests
    
    - name: Test with pytest
      run: |
        pytest tests/ --cov=src --cov-report=term-missing
EOF
```

### 10. Create README
```bash
cat > README.md << 'EOF'
# My Python Project

A Python project created with GitHub CLI.

## Installation

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Usage

```bash
python src/main.py
```

## Testing

```bash
pytest tests/
```

## Development

```bash
# Format code
black src tests

# Lint code
flake8 src tests

# Type check
mypy src
```
EOF
```

### 11. Commit and Push
```bash
git add .
git commit -m "Initial Python project setup"
git push -u origin main
```

## Next Steps

1. Run tests: `pytest tests/`
2. Create an issue: `gh issue create`
3. Create a PR: `gh pr create`
4. Add more dependencies as needed

## Common Commands

```bash
# Run application
python src/main.py

# Run tests with coverage
pytest tests/ --cov=src

# Format code
black src tests

# Lint code
flake8 src tests
```
