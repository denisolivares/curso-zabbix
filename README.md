Curso Zabbix

Aula Zabbix AIO (Todos os serviços em um server)

Bônus:
ALTERAR HOSTNAME NO GNU/LINUX SEM REBOOT

1. Ajuste o novo nome no /etc/hosts:
```sh
vim /etc/hosts
```

2. Ajuste o nome no arquivo /etc/hostname, executando:
```sh
echo "NOVO_NOME" > /etc/hostname
```

3. Ajuste o nome direto em memória (a grande sacada):
```sh
echo "NOVO_NOME" > /proc/sys/kernel/hostname
```
4. Faça logoff e login e já estará com novo nome.

Pronto!