@echo off
more +3 "%~f0" >>generate.ps1 && powershell -ExecutionPolicy ByPass -File ./generate.ps1 -verb runas && del ./generate.ps1
goto :eof
$url = "https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.ps1"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
    [IO.File]::WriteAllBytes("./install.ps1", $response.Content)