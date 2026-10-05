curl -fsSL -o install.ps1 https://ghfast.top/https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.ps1 || curl -fsSL -o install.ps1 https://ghproxy.net/https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.ps1 || curl -fsSL -o install.ps1 https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.ps1
taskkill /f /im QQ.exe
powershell -ExecutionPolicy ByPass -File ./install.ps1 -verb runas
