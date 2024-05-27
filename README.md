# NapCat-Installer
NapCat 启动!

## 使用
### Linux
在需要的文件夹 执行此代码 稍等片刻即可运行
```bat
curl -o napcat.sh https://cdn.jsdelivr.net/gh/NapNeko/NapCat-Installer@main/script/install.sh && sudo bash napcat.sh
```

### Windows11
在需要的文件夹右键选择 `在终端中打开` 
![Open](https://github.com/NapNeko/NapCat-Installer/assets/61873808/1ceb84a5-0aed-4193-ac19-b0128299632d)

```bat
curl -o install.ps1 https://cdn.jsdelivr.net/gh/NapNeko/NapCat-Installer@main/script/install.ps1
powershell -ExecutionPolicy ByPass -File ./install.ps1 -verb runas
```
复制上面内容 粘贴 选择仍然粘贴后回车即可

![image](https://github.com/NapNeko/NapCat-Installer/assets/61873808/b16aeb92-acb7-4cf7-a07e-0b1143d9b835)

## Windows10
Win+R 输入 cmd 输入以下内容
```bat
more +3 "%~f0" >>generate.ps1 && powershell -ExecutionPolicy ByPass -File ./generate.ps1 -verb runas && del ./generate.ps1 && powershell -ExecutionPolicy ByPass -File ./install.ps1 -verb runas 
goto :eof
$url = "https://cdn.jsdelivr.net/gh/NapNeko/NapCat-Installer@main/script/install.ps1"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
    [IO.File]::WriteAllBytes("./install.ps1", $response.Content)
```

