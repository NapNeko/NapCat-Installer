Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Windows.Forms

# Verify that types from both assemblies were loaded.
[System.IO.Compression.ZipArchiveMode]; [IO.Compression.ZipFile]

function Get-QQDownloadUrl {
    #请求https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/windowsDownloadUrl.js获取返回文本 正则匹配 https://dldir1\.qq\.com/qqfile/qq/QQNT/Windows/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_64_[0-9]{2}\.exe
    try {
        $url = "https://qq-web.cdn-go.cn/im.qq.com_new/4d7d217d/202408201134/windowsDownloadUrl.js"
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        $regex = "https://dldir1\.qq\.com/qqfile/qq/QQNT/Windows/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_x64_[0-9]{2}\.exe"
        #$downloadUrl = [regex]::Match($response.Content, $regex).Value
        $downloadUrl = "https://dldir1.qq.com/qqfile/qq/QQNT/b07cb1a5/QQ9.9.15.27597_x64.exe"
        return $downloadUrl
    }
    catch {
        throw "get QQ download url error: $_"
    }
}

function Get-IsQQInstalled {
    try {
        $key = Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\QQ" -ErrorAction SilentlyContinue
        if ($null -eq $key) {
            return $false
        }
        return Test-Path ([System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($key.UninstallString), "QQ.exe"))
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

# https://stackoverflow.com/questions/77508119/npm-run-dev-shows-error-return-process-dlopenmodule-path-tonamespacedpathf
function Install-VCREDIST {
    try {
        $VCREDISTInstallerUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        $VCREDISTInstallerPath = "$env:TEMP\vc_redist.x64.exe"
        Invoke-WebRequest -Uri $VCREDISTInstallerUrl -OutFile $VCREDISTInstallerPath
        Start-Process -FilePath $VCREDISTInstallerPath -ArgumentList "/install", "/quiet", "/norestart" -Wait
        Remove-Item -Path $VCREDISTInstallerPath -Force
        return $true
    }
    catch {
        return $false
    }
}

function Get-RemoteNapCatVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$url = "https://nclatest.znin.net/"
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
            # 验证JSON是否包含tag_name属性
            if (-not ($json -and $json.tag_name)) {
                throw "The JSON content at '$url' does not contain a valid 'tag_name' property."
            }

            return $json.tag_name
        }
        catch [System.Net.WebException], [System.Management.Automation.PSInvocationException] {
            # 处理可能的网络异常和JSON解析异常
            throw "Error when attempting to get version from '$url': $_"
        }
    }
}

# 用于检测是否安装QQ
$isQQInstalled = Get-IsQQInstalled
if (!$isQQInstalled) {
    $result = [System.Windows.Forms.MessageBox]::Show("Install QQ?", "HInt", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        $QQInstallPath = "C:\Program Files\Tencent\QQNT"
        [System.Windows.Forms.Application]::EnableVisualStyles()
        $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{Description='Select QQ Install Path, Cancel to use default path'}
        $result = $folderBrowserDialog.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $QQInstallPath = $folderBrowserDialog.SelectedPath
        }
        Write-Host "QQ Path: $QQInstallPath"
        # 将安装目录写入 HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Tencent\QQNT 的Install键（string） 注册表
        $registryPath = "HKLM:\SOFTWARE\WOW6432Node\Tencent\QQNT"
        $registryKey = "Install"
        $registryValue = $QQInstallPath
        if (!(Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force | Out-Null
        }
        if (!(Test-Path "$registryPath\$registryKey")) {
            New-ItemProperty -Path $registryPath -Name $registryKey -Value $registryValue -PropertyType String -Force | Out-Null
        }
        Write-Host "Please Wait ..."
        $isInstalled = Install-QQ
        if (!$isInstalled) {
            Write-Host "Install QQ failed."
            exit 1
        }
        else {
            Write-Host "Install QQ Successed."
        }

        Write-Host "Install Microsoft Visual C++ Redistributable (x64)"
        $isVCREDISTInstalled = Install-VCREDIST
        if (!$isVCREDISTInstalled) {
            Write-Host "Microsoft Visual C++ Redistributable (x64) Install Failed! napcat may not work properly!!"
        }
        # 看起来似乎库装上去也没用, 需要再手动开启下QQ??
        Write-Host "Try to boot qq once to fix issue??"
        try {
            $QQProcess = Start-Process "$QQInstallPath\QQ.exe" -PassThru
            Write-Host "QQ.exe will automatically exit in 15 seconds."
            Start-Sleep -Seconds 10
            Stop-Process -Id $QQProcess.Id
        }
        catch {
            Write-Host "Try to auto fix failed, if you meet 'Error: The specified module could not be found.', please manual open once qq."
        }
    } else {
        Write-Host "Install QQ canceled."
    }
}

if (Test-Path -Path "./NapCatQQ/" -PathType Container) {
    Write-Host "NapCat path already exists!"
    exit 1
}
# 获取远程版本号
$remoteVersion = Get-RemoteNapCatVersion
if ($null -eq $remoteVersion) {
    Write-Host "Get remote version failed."
    exit 1
}
Write-Host "Remote Version: $remoteVersion"
#下载https://github.com/NapNeko/NapCatQQ/releases/download/v$remoteVersion/NapCat.Shell.zip
$url = "https://mirror.ghproxy.com/https://github.com/NapNeko/NapCatQQ/releases/download/$remoteVersion/NapCat.Shell.zip"
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
    exit 1
}
Write-Host "Napcat Path: ./NapCatQQ/"
Write-Host "Install Success!"
taskkill /f /im QQ.exe
# 询问是否启动 napcatqq
$result = [System.Windows.Forms.MessageBox]::Show("Run NapCatQQ?", "Hint", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Set-Location ./NapCatQQ
    powershell -ExecutionPolicy ByPass -File ./BootWay05.ps1
}
