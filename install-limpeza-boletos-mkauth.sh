#!/bin/bash
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Execute como root:"
  echo "sudo $0"
  exit 1
fi

CLEANUP_SCRIPT="/usr/local/sbin/limpar-boletos-excluidos-mkauth.sh"
CRON_FILE="/etc/cron.d/limpar-boletos-excluidos-mkauth"

cat > "$CLEANUP_SCRIPT" <<'EOF'
#!/bin/bash
mysql -h localhost -u root -pvertrigo mkradius -e "DELETE FROM sis_lanc WHERE deltitulo = '1'; DELETE FROM sis_carne WHERE delcarne = '1';"
EOF

chmod +x "$CLEANUP_SCRIPT"

cat > "$CRON_FILE" <<EOF
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

0 */6 * * * root $CLEANUP_SCRIPT >/dev/null 2>&1
EOF

chmod 644 "$CRON_FILE"

if command -v systemctl >/dev/null 2>&1; then
  systemctl reload cron 2>/dev/null || systemctl restart cron 2>/dev/null || true
fi

"$CLEANUP_SCRIPT"

echo "Instalacao concluida."
echo "Script: $CLEANUP_SCRIPT"
echo "Cron: $CRON_FILE"
echo "Agendamento: 0 */6 * * *"
