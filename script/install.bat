curl -o install.ps1 https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.ps1
taskkill /f /im QQ.exe
powershell -ExecutionPolicy ByPass -File ./install.ps1 -verb runas
