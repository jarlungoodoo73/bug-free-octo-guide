# Web Application Template

Quick-start template for creating a web application with GitHub integration.

## Stack
- Frontend: HTML, CSS, JavaScript
- Backend: Node.js with Express
- CI/CD: GitHub Actions

## Quick Setup

### 1. Create and Clone Repository
```bash
gh repo create my-web-app --public --clone
cd my-web-app
```

### 2. Initialize Node.js Project
```bash
npm init -y
npm install express
npm install --save-dev nodemon
```

### 3. Create Basic Server
```bash
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.static('public'));
app.use(express.json());

app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello from GitHub CLI!' });
});

app.listen(port, () => {
  console.log(\`Server running on http://localhost:\${port}\`);
});
EOF
```

### 4. Create Public Directory
```bash
mkdir public
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Web App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        .container {
            text-align: center;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My Web App</h1>
        <button onclick="fetchMessage()">Get Message</button>
        <p id="message"></p>
    </div>
    <script>
        async function fetchMessage() {
            const response = await fetch('/api/hello');
            const data = await response.json();
            document.getElementById('message').textContent = data.message;
        }
    </script>
</body>
</html>
EOF
```

### 5. Update package.json Scripts
```bash
npm pkg set scripts.start="node server.js"
npm pkg set scripts.dev="nodemon server.js"
```

### 6. Create .gitignore
```bash
cat > .gitignore << 'EOF'
node_modules/
npm-debug.log
.env
.DS_Store
EOF
```

### 7. Create GitHub Actions Workflow
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
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-node@v3
      with:
        node-version: '18'
    - run: npm ci
    - run: npm test
EOF
```

### 8. Commit and Push
```bash
git add .
git commit -m "Initial web app setup"
git push -u origin main
```

## Development

Start the development server:
```bash
npm run dev
```

Visit http://localhost:3000 to see your app.

## Deployment

Deploy to GitHub Pages, Vercel, or your preferred hosting platform.

For GitHub Pages:
```bash
gh workflow run deploy.yml
```
