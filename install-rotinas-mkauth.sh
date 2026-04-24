#!/bin/bash
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Execute como root:"
  echo "sudo $0"
  exit 1
fi

CLEANUP_SCRIPT="/usr/local/sbin/limpar-boletos-excluidos-mkauth.sh"
CLEANUP_CRON_FILE="/etc/cron.d/limpar-boletos-excluidos-mkauth"
PHP_API_CRON_FILE="/etc/cron.d/restart-php-api-mkauth"

instalar_limpeza_boletos() {
  cat > "$CLEANUP_SCRIPT" <<'EOF'
#!/bin/bash
mysql -h localhost -u root -pvertrigo mkradius -e "DELETE FROM sis_lanc WHERE deltitulo = '1'; DELETE FROM sis_carne WHERE delcarne = '1';"
EOF

  chmod +x "$CLEANUP_SCRIPT"

  cat > "$CLEANUP_CRON_FILE" <<EOF
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

0 */6 * * * root $CLEANUP_SCRIPT >/dev/null 2>&1
EOF

  chmod 644 "$CLEANUP_CRON_FILE"
}

instalar_restart_php_api() {
  cat > "$PHP_API_CRON_FILE" <<'EOF'
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

0 */4 * * * root service php-api restart >/dev/null 2>&1
EOF

  chmod 644 "$PHP_API_CRON_FILE"
}

recarregar_cron() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl reload cron 2>/dev/null || systemctl restart cron 2>/dev/null || true
  fi
}

instalar_limpeza_boletos
instalar_restart_php_api
recarregar_cron

"$CLEANUP_SCRIPT"

echo "Instalacao concluida."
echo "Limpeza boletos: $CLEANUP_SCRIPT"
echo "Cron limpeza boletos: $CLEANUP_CRON_FILE"
echo "Agendamento limpeza boletos: 0 */6 * * *"
echo "Cron restart php-api: $PHP_API_CRON_FILE"
echo "Agendamento restart php-api: 0 */4 * * *"
