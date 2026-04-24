# mkauth-scripts

Scripts simples para rotinas operacionais em servidores MKAuth.

## Limpeza de boletos excluidos

O script `install-limpeza-boletos-mkauth.sh`:

- cria `/usr/local/sbin/limpar-boletos-excluidos-mkauth.sh`
- cria o cron em `/etc/cron.d/limpar-boletos-excluidos-mkauth`
- agenda a limpeza para rodar a cada 6 horas
- executa uma limpeza imediatamente apos a instalacao

Comando unico:

```bash
git clone https://github.com/provedorconsult/mkauth-scripts.git && cd mkauth-scripts && chmod +x install-limpeza-boletos-mkauth.sh && sudo ./install-limpeza-boletos-mkauth.sh
```

O cron criado roda todos os dias em:

```cron
0 */6 * * * root /usr/local/sbin/limpar-boletos-excluidos-mkauth.sh >/dev/null 2>&1
```

Comandos executados na limpeza:

```sql
DELETE FROM sis_lanc WHERE deltitulo = '1';
DELETE FROM sis_carne WHERE delcarne = '1';
```
