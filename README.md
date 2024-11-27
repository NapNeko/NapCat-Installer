# NapCat-Installer
NapCat 启动!

## 使用
### Linux(支持Ubuntu 20+/Debian 10+, Centos系仅支持9)
在需要的文件夹 执行此代码 稍等片刻即可运行
```bash
curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh
```
国外服务器可使用以下命令
```bash
curl -o napcat.sh https://raw.githubusercontent.com/NapNeko/NapCat-Installer/refs/heads/main/script/install.sh && sudo bash napcat.sh
```
注意：如果无法下载NapCat.Shell.zip以及QQ安装包请尝试手动下载并将QQ安装包重命名为QQ.deb或者QQ.rpm, NapCat.Shell.zip无需更改名字。
两者的下载链接脚本会给出，当然你也可以先下载再执行脚本。
<details>
  <summary>命令选项(高级用法)</summary>

  0. --tui: 使用tui可视化交互安装

  1. --docker [y/n]: --docker y 为使用docker安装反之为shell安装

  2. --qq \"123456789\": 传入docker安装时的QQ号

  3. --mode [ws|reverse_ws|reverse_http]: 传入docker安装时的运行模式

  4. --confirm: 传入docker安装时的是否确认执行安装

  5. --proxy [0|1|2|3|4|5|6]: 传入代理, 0为不使用代理, 1为使用内置的第一个,不支持自定义, docker安装可选0-7, shell安装可选0-5

  6. --cli [y/n]: shell安装时是否安装cli

  7. --force: 传入则执行shell强制重装

  **使用示例:**
  1. 使用tui可视化交互安装:
      ```bash
      curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh --tui
      ```

  2. 运行docker安装并传入 qq\"123456789\" 模式ws 使用第一个代理 直接安装:
      ```bash
      curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh --docker y --qq \"123456789\" --mode ws --proxy 1 --confirm
      ```

  3. 运行shell安装并传入 不安装cli 不使用代理 强制重装:
      ```bash
      curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh --docker n --cli n --proxy 0 --force
      ```

</details>


### Termux(存储空间占用~1.5GB)
执行此代码 稍等片刻即可运行
```bash
curl -o napcat.termux.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.termux.sh && bash napcat.termux.sh
```
或者使用tmoe脚本来安装proot(无root)/chroot(有root)容器并执行上面的[Linux安装命令](#使用)而非本命令

### Windows11
在需要的文件夹右键选择 `在终端中打开` 
![Open](https://github.com/NapNeko/NapCat-Installer/assets/61873808/1ceb84a5-0aed-4193-ac19-b0128299632d)

```bat
curl -o install.ps1 https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.ps1
powershell -ExecutionPolicy ByPass -File ./install.ps1 -verb runas
```
复制上面内容 粘贴 选择仍然粘贴后回车即可

![image](https://github.com/NapNeko/NapCat-Installer/assets/61873808/b16aeb92-acb7-4cf7-a07e-0b1143d9b835)

## Windows10
Win+R 输入 cmd 输入以下内容
```bat
more +3 "%~f0" >>generate.ps1 && powershell -ExecutionPolicy ByPass -File ./generate.ps1 -verb runas && del ./generate.ps1 && powershell -ExecutionPolicy ByPass -File ./install.ps1 -verb runas 
goto :eof
$url = "https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.ps1"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
    [IO.File]::WriteAllBytes("./install.ps1", $response.Content)
```

## 常见问题

### screen无法上下自由滚动

执行一次 `echo 'termcapinfo xterm* ti@:te@' >> ~/.screenrc` 即可(无需重复执行)
