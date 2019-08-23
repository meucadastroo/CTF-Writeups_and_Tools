strComputer = "."

Set objNetwork = CreateObject("Wscript.Network")

Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

''' Processo que será verificado '''''''
Set colProcesses = objWMIService.ExecQuery _
    ("Select * from Win32_Process Where Name = 'cmd.exe'")

''' elimina o processo definido '''
For each Processo in ColProcesses
   Processo.Terminate()
Next