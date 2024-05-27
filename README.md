# NapCat-Installer
NapCat 启动!

## 使用
### Linux
在需要的文件夹 执行此代码 稍等片刻即可运行
```bat
curl -o napcat.sh https://fastly.jsdelivr.net/gh/NapNeko/NapCat-Installer@master/script/install.sh && sudo bash napcat.sh
```

### Windows
在需要的文件夹右键 `选择在终端中打开` 复制以下内容 粘贴 并运行 即可在此目录安装NC 

```bat
curl -o install.ps1 https://fastly.jsdelivr.net/gh/NapNeko/NapCat-Installer@main/script/install.ps1
powershell -ExecutionPolicy ByPass -File ./install.ps1 -verb runas
```