# NapCat-Installer

Linux / Termux 安装脚本。完整说明见 [Shell 安装文档](https://napneko.github.io/guide/boot/Shell)。

## Linux

在安装用户的终端中执行：

```bash
curl -fL -o napcat.sh https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.sh &&
bash napcat.sh --docker n --cli y --github-proxy 0
```

默认安装到 `~/Napcat`。仅安装 Shell 使用 `--cli n`，交互安装使用 `--tui`，更新使用 `--force`；参数说明见 `bash napcat.sh --help`。

[代理、证书与离线安装](https://napneko.github.io/guide/boot/Shell#linux)

## Termux

```bash
curl -fL -o napcat.termux.sh https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.termux.sh &&
bash napcat.termux.sh
```

安装后启动及恢复方法见 [Termux 文档](https://napneko.github.io/guide/boot/Shell#termux)。

Windows 使用 [一键安装包](https://napneko.github.io/guide/boot/Shell#windows-onekey)。
