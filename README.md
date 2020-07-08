Curso Zabbix

Aula Zabbix AIO (Todos os serviços em um server)


Bônus:
ALTERAR HOSTNAME NO GNU/LINUX SEM REBOOT

1. Ajuste o novo nome no /etc/hosts:
# vim /etc/hosts

2. Ajuste o nome no arquivo /etc/hostname, executando:
# echo "NOVO_NOME" > /etc/hostname

3. Ajuste o nome direto em memória (a grande sacada):
# echo "NOVO_NOME" > /proc/sys/kernel/hostname

4. Faça logoff e login e já estará com novo nome.

Pronto!


Verificando o horário no servidor
 - timedatectl status

Ajustando o timezone do servidor
 ''' 
 timedatectl set-timezone America/Sao_Paulo
 '''

Instalando recursos básicos
dnf install -y net-tools vim nano epel-release wget curl tcpdump


 - Verificar repositório do MySQL
dnf info mysql-server
 - Instalar o MySQL
dnf install -y mysql-server
 - Iniciar o serviço do MySQL
systemctl enable --now mysqld
 - Verificando se o serviço iniciou
systemctl status mysqld
 - Testar o acesso a base de dados
mysql -u root
 - Iniciar configuração de senha
mysql_secure_installation
 - Criar banco de dados
create database zabbix character set utf8 collate utf8_bin;
 - Criando usuário Zabbix (o "identified by" é o password do usuário)
create user 'zabbix'@'localhost' identified by 'Curso!Zabbix5';
 - Conceder acesso para o usuário do banco
grant all privileges on zabbix.* to 'zabbix'@'localhost'
 - limpar os privilegios
flush privileges;
 - 

 Instalar repositório oficial

rpm -ivh http://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm

vim 