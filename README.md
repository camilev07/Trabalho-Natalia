[![CD - Deploy no GitHub Pages](https://github.com/camilev07/Trabalho-Natalia/actions/workflows/deploy.yml/badge.svg)](https://github.com/camilev07/Trabalho-Natalia/actions/workflows/deploy.yml)
[![CI - Validação do Pull Request](https://github.com/camilev07/Trabalho-Natalia/actions/workflows/ci.yml/badge.svg)](https://github.com/camilev07/Trabalho-Natalia/actions/workflows/ci.yml)

# Portfólio Profissional - Camile Alves

Site: https://camilev07.github.io/Trabalho-Natalia/

## Pipeline CI/CD

**CI (`ci.yml`)** - roda em todo Pull Request para `main`:
1. Verifica se `index.html` existe na raiz
2. Linter HTMLHint em Node 18 e 20 (matrix)
3. Bloqueia arquivos acima de 500KB
4. Bloqueia comentários/termos proibidos
5. Valida links e imagens

**CD (`deploy.yml`)** - a cada push na `main` publica no GitHub Pages. Se falhar, abre uma Issue de alerta.
