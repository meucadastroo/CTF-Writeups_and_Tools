'############## Randomize Proxy-Server #################
'#                    Dev. by JJ                       #
'########################666############################

public proxy

valUserInit = MsgBox("Deseja Iniciar o Proxy ?",4,"ProxyServer Randomize 1.0")

If valUserInit=vbYes Then
   msgbox("ProxyServer Randomizer[INICIADO] !")
   Call laco  
Else
   msgbox("ProxyServer Randomizer [CANCELADO] !")
   WScript.Quit
End If


'______________________________________________________

Sub laco()

  i = 1
  x = 0
   
  Do While i <> x
     
     Call setNewProxy 
     
     AckTime = 5
     valUserEnd = InfoBox.Popup("Para Encerrar o ProyServer Select [YES] ?", AckTime, "ProyServer [" & proxy & "] ?",4)
     If valUserEnd=vbYes Then
        i = 0
        msgBox("ProxyServer Encerrado Com Sucesso !")
        Call endProxyServer
     End If  

  Loop

End Sub

'________________________________________________________

Sub setNewProxy()
          
     Randomize
     opc=int(rnd*2) + 1

     if opc = 1 Then
       proxy = "177.128.210.250:8080"
     ElseIf opc = 2 Then
       proxy = "127.0.0.1:8080"
     End If 

     Set objShell = WScript.CreateObject("WScript.Shell")  
     RegLocate = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyServer"
     objShell.RegWrite RegLocate,newProxy,"REG_SZ"
     RegLocate = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable"
     objShell.RegWrite RegLocate,"1","REG_DWORD"

End Sub

'________________________________________________________

Sub endProxyServer()
   
     Set objShell = WScript.CreateObject("WScript.Shell")  
     RegLocate = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyServer"
     objShell.RegWrite RegLocate,"0.0.0.0:80","REG_SZ"
     RegLocate = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable"
     objShell.RegWrite RegLocate,"0","REG_DWORD"

   WScript.Quit

End Sub

'______________________________________________________


