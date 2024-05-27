curl -o install.ps1 https://fastly.jsdelivr.net/gh/NapNeko/NapCat-Installer@main/script/install.ps1
Net session >nul 2>&1
powershell -ExecutionPolicy RemoteSigned -File ./install.ps1 -verb runas