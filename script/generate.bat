@echo off
more +3 "%~f0" >>generate.ps1 && powershell -ExecutionPolicy ByPass -File ./generate.ps1 -verb runas && del ./generate.ps1
goto :eof
foreach ($p in "https://ghfast.top/", "https://ghproxy.net/", "") { try { Invoke-WebRequest -Uri "${p}https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.ps1" -OutFile ./install.ps1 -UseBasicParsing; break } catch {} }