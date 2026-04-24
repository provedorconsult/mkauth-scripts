# mkauth-scripts

Scripts simples para rotinas operacionais em servidores MKAuth.

## Instalador de rotinas

O script `install-rotinas-mkauth.sh`:

- cria `/usr/local/sbin/limpar-boletos-excluidos-mkauth.sh`
- cria o cron em `/etc/cron.d/limpar-boletos-excluidos-mkauth`
- agenda a limpeza para rodar a cada 6 horas
- cria o cron em `/etc/cron.d/restart-php-api-mkauth`
- agenda o comando `service php-api restart` para rodar a cada 4 horas
- executa uma limpeza imediatamente apos a instalacao

Comando unico:

```bash
git clone https://github.com/provedorconsult/mkauth-scripts.git && cd mkauth-scripts && chmod +x install-rotinas-mkauth.sh && ./install-rotinas-mkauth.sh
```

Conferir se o cron foi criado:

```bash
cat /etc/cron.d/limpar-boletos-excluidos-mkauth /etc/cron.d/restart-php-api-mkauth
```

Cron da limpeza de boletos:

```cron
0 */6 * * * root /usr/local/sbin/limpar-boletos-excluidos-mkauth.sh >/dev/null 2>&1
```

Cron do restart do php-api:

```cron
0 */4 * * * root service php-api restart >/dev/null 2>&1
```

Comandos executados na limpeza:

```sql
DELETE FROM sis_lanc WHERE deltitulo = '1';
DELETE FROM sis_carne WHERE delcarne = '1';
```
