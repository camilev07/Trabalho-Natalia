#!/usr/bin/env bash
# Verifica todas as tags <a href>, <link href> e <img src> do index.html.
# - Caminhos locais: o arquivo precisa existir.
# - URLs externas (http/https): precisam responder com status 2xx/3xx.
# - mailto:, tel: e âncoras (#) são ignorados.
set -u

FILE="${1:-index.html}"
errors=0

if [ ! -f "$FILE" ]; then
  echo "::error::Arquivo $FILE não encontrado"
  exit 1
fi

# Extrai o valor de href="..." e src="..." (apenas nas tags a, link e img)
mapfile -t urls < <(grep -oE '<(a|link|img)[^>]*(href|src)="[^"]*"' "$FILE" \
  | grep -oE '(href|src)="[^"]*"' \
  | sed -E 's/^(href|src)="(.*)"$/\2/' \
  | sort -u)

for url in "${urls[@]}"; do
  case "$url" in
    "")
      echo "::error::Link/imagem com URL vazia"
      errors=$((errors + 1))
      ;;
    mailto:*|tel:*|\#*)
      echo "SKIP  $url"
      ;;
    http://*|https://*)
      status=$(curl -s -o /dev/null -L -A "Mozilla/5.0 (link-checker)" \
        --max-time 20 --retry 2 -w '%{http_code}' "$url" || true)
      # LinkedIn responde 999 para clientes automatizados (anti-bot): link existe.
      if [[ "$status" =~ ^[23][0-9][0-9]$ ]] || { [[ "$url" == *linkedin.com* ]] && [ "$status" = "999" ]; }; then
        echo "OK    [$status] $url"
      else
        echo "::error::URL inválida [$status]: $url"
        errors=$((errors + 1))
      fi
      ;;
    *)
      if [ -f "$url" ]; then
        echo "OK    [local] $url"
      else
        echo "::error::Caminho local inexistente: $url"
        errors=$((errors + 1))
      fi
      ;;
  esac
done

if [ "$errors" -gt 0 ]; then
  echo "Falha: $errors link(s)/imagem(ns) inválido(s)."
  exit 1
fi
echo "Todos os links e imagens são válidos."
