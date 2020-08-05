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


# Instalação Zabbix 5.0 - 3 camadas

timedatectl status
timedatectl list-timezones | grep Sao_Paulo
timedatectl set-timezone America/Sao_Paulo
timedatectl status

## Configure o chrony (NTP) para corrigir data e hora

dnf -y install chrony
systemctl enable --now chronyd
chronyc sources
service chronyd restart
firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload

## Instalar utilitários

dnf install -y net-tools vim nano epel-release wget curl tcpdump

## Desabilitar SELINUX

getenforce
sed -i 's/SELINUX=enforcing/SELINUX=permissive /g' /etc/selinux/config
setenforce 0
getenforce

## Instalando Mysql 8

dnf info mysql-server
dnf -y install mysql-server
systemctl enable --now mysqld
systemctl status mysqld
mysql_secure_installation 

Z4bb1x5!2o2o

mysql -u root -p
create database zabbix character set utf8 collate utf8_bin;
create user 'zabbix'@'localhost' identified by 'Curso!Zabbix5';
grant all privileges on zabbix.* to 'zabbix'@'localhost';
flush privileges;
exit

create user 'zabbix_server'@'172.20.127.162' identified with mysql_native_password by 'Curso!Zabbix5';
grant all privileges on zabbix.* to 'zabbix_server'@'172.20.127.162';
flush privileges;

create user 'zabbix_web'@'172.20.115.152' identified with mysql_native_password by 'Curso!Zabbix5';
grant all privileges on zabbix.* to 'zabbix_web'@'172.20.115.152';
flush privileges;
exit

firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload
