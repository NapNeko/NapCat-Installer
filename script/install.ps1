Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Windows.Forms

# Verify that types from both assemblies were loaded.
[System.IO.Compression.ZipArchiveMode]; [IO.Compression.ZipFile]

# 进度条会让大文件下载慢很多
$ProgressPreference = 'SilentlyContinue'

# GitHub 加速节点，来源 https://github.akams.cn/ ，失效了就从那里换新的；最后的空串表示直连
$GithubProxies = @("https://ghfast.top/", "https://ghproxy.net/", "https://github.dpik.top/", "https://ghm.078465.xyz/", "https://gh.monlor.com/", "https://gh-proxy.com/", "")

# QQ 9.9.33-52230。腾讯下架了部分旧版本的下载链接，所以先试官方 CDN，再试 GitHub 上的镜像，下载后校验 SHA256
$QQDownloadUrls = @("https://qqdl.gtimg.cn/qqfile/QQNT/9.9.33/release/497e2f1f/QQ_9.9.33_260813_x64_01.exe") +
    ($GithubProxies | ForEach-Object { $_ + "https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_x64_01.exe" })
$QQSha256 = "b25c0d3ce9df764074a9118d0ded927e1b2d7ebf60e306112e8df18a040ec492"

# 直接用 .NET 算 SHA256，不依赖 Get-FileHash 所在的模块
function Get-Sha256([string]$path) {
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $stream = [System.IO.File]::OpenRead($path)
    try {
        return ([System.BitConverter]::ToString($sha256.ComputeHash($stream)) -replace '-', '').ToLower()
    }
    finally {
        $stream.Close()
        $sha256.Dispose()
    }
}

# zip 文件以 PK 开头，用来识别代理拿不到文件时返回的网页
function Test-ZipFile([string]$path) {
    $stream = [System.IO.File]::OpenRead($path)
    try {
        return ($stream.ReadByte() -eq 0x50) -and ($stream.ReadByte() -eq 0x4B)
    }
    finally {
        $stream.Close()
    }
}

function Get-IsQQInstalled {
    param (
        [version]$targetVersion,
        [ref]$installPath
    )
    $currentVersion = $null
    try {
        $key = Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\QQ" -ErrorAction SilentlyContinue
        if ($null -eq $key) {
            return $false
        }
        if (-not [version]::TryParse($key.DisplayVersion, [ref]$currentVersion)) {
            return $false
        }
        $uninstallPath = $key.UninstallString
        if ($uninstallPath) {
            $installPath.Value = [System.IO.Path]::GetDirectoryName($uninstallPath)
            $exePath = [System.IO.Path]::Combine($installPath.Value, "QQ.exe")
            if (Test-Path $exePath) {
                if ($currentVersion -lt $targetVersion) {
                    return $false
                }
                return $true
            }
        }
        return $false
    }
    catch {
        return $false
    }
}

function Install-QQ {
    $QQInstallerPath = "$env:TEMP\QQInstaller.exe"
    $isDownloaded = $false
    foreach ($url in $QQDownloadUrls) {
        try {
            Write-Host "Download QQ: $url"
            Invoke-WebRequest -Uri $url -OutFile $QQInstallerPath -UseBasicParsing
            if ((Get-Sha256 $QQInstallerPath) -eq $QQSha256) {
                $isDownloaded = $true
                break
            }
            Write-Host "SHA256 mismatch, try next ..."
        }
        catch {
            Write-Host "Download failed, try next ..."
        }
    }
    if (!$isDownloaded) {
        return $false
    }
    try {
        Start-Process -FilePath $QQInstallerPath -ArgumentList "/s" -Wait
        Remove-Item -Path $QQInstallerPath -Force
    }
    catch {
        return $false
    }
    return Get-IsQQInstalled -targetVersion $targetVersion -installPath ([ref]$QQInstallPath)
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

# 用于检测是否安装QQ
$targetVersion = "9.9.33.52230"
$QQInstallPath = ""
$isQQInstalled = Get-IsQQInstalled -targetVersion $targetVersion -installPath ([ref]$QQInstallPath)
if (!$isQQInstalled) {
    $next = $true
    if ($QQInstallPath -eq "") {
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
        } else {
            $next = $false
            Write-Host "Install QQ canceled."
        }
    }
    if ($next) {
        Write-Host "Install QQ, Please Wait ..."
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
    }
}

# if (Test-Path -Path "./NapCatQQ/" -PathType Container) {
#     Write-Host "NapCat path already exists!"
#     exit 1
# }
# 直接下载最新版，不再单独查询版本号
$zipFile = Join-Path (Get-Location) "NapCatQQ.zip"
$isDownloaded = $false
foreach ($proxy in $GithubProxies) {
    $url = "${proxy}https://github.com/NapNeko/NapCatQQ/releases/latest/download/NapCat.Shell.zip"
    try {
        Write-Host "Download NapCat: $url"
        Invoke-WebRequest -Uri $url -OutFile $zipFile -UseBasicParsing
        if (Test-ZipFile $zipFile) {
            $isDownloaded = $true
            break
        }
        Write-Host "Not a zip file, try next ..."
    }
    catch {
        Write-Host "Download failed, try next ..."
    }
}
if (!$isDownloaded) {
    Write-Host "Download failed."
    exit 1
}
try {
    Expand-Archive -Path $zipFile -DestinationPath "./NapCatQQ/" -Force
    Remove-Item -Path $zipFile -Force
}catch{
    Write-Host "Unzip failed. $_"
    exit 1
}
Write-Host "Napcat Path: ./NapCatQQ/"
Write-Host "Install Success!"
taskkill /f /im QQ.exe 2>$null | Out-Null
# 询问是否启动 napcatqq
$result = [System.Windows.Forms.MessageBox]::Show("Run NapCatQQ?", "Hint", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Set-Location ./NapCatQQ
    cmd /c launcher-user.bat
}
