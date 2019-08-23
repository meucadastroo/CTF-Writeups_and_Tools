cls
gcc -c -DBUILD_DLL dll.c -o out.o
gcc -shared -o minha.dll out.o -Wl,--out-implib,minha.a
del out.o
gcc exe.c -o minha.exe minha.a