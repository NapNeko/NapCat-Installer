$url = "https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.ps1"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
    [IO.File]::WriteAllBytes("./install.ps1", $response.Content)