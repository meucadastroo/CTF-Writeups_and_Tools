set cmd = CreateObject("WSCript.Shell")

Set objNetwork = CreateObject("Wscript.Network")   
strComputer = "."     
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set objFSO = CreateObject("Scripting.FileSystemObject")


i = 1
x = 0

msgbox("Iniciando a varredura...")

Do While i <> x
  'verificando se ha conexoes com a porta 5900
   cmd.Run "cmd /K NETSTAT | FIND "":5900"" > .\log.txt",0
   nomeArquivo = ".\log.txt"

  'verificando o tamanho do arquivo pela primeira vez
   Set objFile = objFSO.GetFile(nomeArquivo) 
   intTempo1 = objFile.SIZE
   
  'tempo para checar o tamanho do arquivo novamente
   wscript.sleep 15000
   cmd.Run "NETSTAT | FIND :5900 > .\log.txt",0
   intTempo2 = objFile.SIZE
   
   if intTempo2 <> intTempo1 Then
     msgbox("alerta de conexao")
     x = 1   
   End if

   ''' Processo que será verificado '''''''
   Set colProcesses = objWMIService.ExecQuery _
    ("Select * from Win32_Process Where Name = 'cmd.exe'")

   ''' elimina o processo definido '''
   For each Processo in ColProcesses
     Processo.Terminate()
   Next

Loop





