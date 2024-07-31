Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Windows.Forms

# Verify that types from both assemblies were loaded.
[System.IO.Compression.ZipArchiveMode]; [IO.Compression.ZipFile]

function Get-QQpath {
    try {
        $key = Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\QQ"
        $uninstallString = $key.UninstallString
        return [System.IO.Path]::GetDirectoryName($uninstallString) + "\QQ.exe"
    }
    catch {
        throw "get QQ path error: $_"
    }
}
function Get-QQDownloadUrl {
    #请求https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/windowsDownloadUrl.js获取返回文本 正则匹配 https://dldir1\.qq\.com/qqfile/qq/QQNT/Windows/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_64_[0-9]{2}\.exe
    try {
        $url = "https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/windowsDownloadUrl.js"
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        $regex = "https://dldir1\.qq\.com/qqfile/qq/QQNT/Windows/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_64_[0-9]{2}\.exe"
        $response.Content -match $regex
        return $matches[0]
    }
    catch {
        throw "get QQ download url error: $_"
    }
}
function Get-IsQQInstalled {
    try {
        Get-QQpath
        return $true
    }
    catch {
        return $false
    }
}
function Install-QQ {
    try {
        $QQInstallerUrl = Get-QQDownloadUrl
        $QQInstallerPath = "$env:TEMP\QQInstaller.exe"
        Invoke-WebRequest -Uri $QQInstallerUrl -OutFile $QQInstallerPath
        Start-Process -FilePath $QQInstallerPath -ArgumentList "/s" -Wait
        Remove-Item -Path $QQInstallerPath -Force
    }
    catch {
        return $false
    }
    return Get-IsQQInstalled
}
function Get-RemoteNapCatVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$url = "https://fastly.jsdelivr.net/gh/NapNeko/NapCatQQ@main/package.json"
    )

    begin {
        # 验证URL格式
        if (-not [Uri]::IsWellFormedUriString($url, [System.UriKind]::Absolute)) {
            throw "The provided URL '$url' is not well formed."
        }
    }

    process {
        try {
            # 使用UseBasicParsing是为了在不支持.NET Framework的系统上避免问题
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing
            
            # 检查HTTP状态码
            if ($response.StatusCode -ne 200) {
                throw "Failed to retrieve the resource at '$url'. Status code: $($response.StatusCode)"
            }

            $json = $response.Content | ConvertFrom-Json
            # 验证JSON是否包含version属性
            if (-not ($json -and $json.version)) {
                throw "The JSON content at '$url' does not contain a valid 'version' property."
            }

            return $json.version
        }
        catch [System.Net.WebException], [System.Management.Automation.PSInvocationException] {
            # 处理可能的网络异常和JSON解析异常
            throw "Error when attempting to get version from '$url': $_"
        }
    }
}
$isQQInstalled = Get-IsQQInstalled

# 用于检测是否安装QQ
if (!$isQQInstalled) {
    $result = [System.Windows.Forms.MessageBox]::Show("Install QQ?", "HInt", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($result -eq "OK") {
        $QQInstallPath = $folderBrowserDialog.SelectedPath
        if ($QQInstallPath -eq "") {
            Write-Host "Install QQ canceled."
            exit
        }
        # 将安装目录写入 HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Tencent\QQNT 的Install键（string） 注册表
        $registryPath = "HKLM:\SOFTWARE\WOW6432Node\Tencent\QQNT"
        $registryKey = "Install"
        $registryValue = $QQInstallPath
        if (!(Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force | Out-Null
        }
        if (!(Test-Path "$registryPath\$registryKey")) {
            New-ItemProperty -Path $registryPath -Name $registryKey -Value $registryValue-PropertyType String -Force | Out-Null
        }
        Write-Host "Please Wait ..."
        $isInstalled = Install-QQ
        if (!$isInstalled) {
            Write-Host "Install QQ failed."
            exit
        }
        else {
            Write-Host "Install QQ canceled."
            exit
        }
    }
}
# 获取远程版本号
$remoteVersion = Get-RemoteNapCatVersion
if ($null -eq $remoteVersion) {
    Write-Host "Get remote version failed."
    exit
}
Write-Host "Remote Version: $remoteVersion"
#下载https://github.com/NapNeko/NapCatQQ/releases/download/v$remoteVersion/NapCat.win32.x64.zip 的zip
$url = "https://mirror.ghproxy.com/https://github.com/NapNeko/NapCatQQ/releases/download/v$remoteVersion/NapCat.win32.x64.zip"
try {
    Write-Host "Wait ..."
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $zipFile = ".\NapCatQQ.zip"
    # 保存文件到当前目录
    [IO.File]::WriteAllBytes($zipFile, $response.Content)
    Expand-Archive -Path "./NapCatQQ.zip" -DestinationPath "./NapCatQQ/"
    Remove-Item -Path $zipFile -Force
}catch{
    Write-Host "Download failed. $_"
    exit
}
# 移动./NapCatQQ/NapCat.win32.x64/内所有文件到./NapCatQQ/
Get-ChildItem -Path "./NapCatQQ/NapCat.win32.x64/" -Recurse | Move-Item -Destination "./NapCatQQ/" -Force
Remove-Item -Path "./NapCatQQ/NapCat.win32.x64/" -Recurse -Force
Write-Host "Install Success!"
# 询问是否启动 ./NapCatQQ/napcat-utf8.bat
$result = [System.Windows.Forms.MessageBox]::Show("Run NapCatQQ?", "Hint", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
if ($result -eq "Yes") {
    Set-Location ./NapCatQQ
    powershell -ExecutionPolicy ByPass -File ./BootWay05.ps1
}
