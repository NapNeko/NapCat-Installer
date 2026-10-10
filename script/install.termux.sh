#!/bin/bash
set -e

image="debian:bookworm-slim"
github_proxy=""
resume="n"

while [ $# -gt 0 ]; do
    case "$1" in
        --image|--github-proxy)
            if [ $# -lt 2 ] || [[ "$2" == --* ]]; then
                echo "参数 $1 缺少值。" >&2
                exit 1
            fi
            if [ "$1" = "--image" ]; then
                image="$2"
            else
                github_proxy="${2%/}"
            fi
            shift 2
            ;;
        --resume)
            resume="y"
            shift
            ;;
        --help|-h)
            echo "用法: bash install.termux.sh [--image 镜像名或本地归档路径] [--github-proxy URL] [--resume]"
            echo "--image 指定 proot-distro 的 Debian 镜像来源；--github-proxy 仅用于下载 NapCat。"
            echo "--resume 在已有的 napcat 容器中继续安装或更新，保留数据。"
            exit 0
            ;;
        *) echo "未知参数: $1" >&2; exit 1 ;;
    esac
done

case "$github_proxy" in
    ""|http://*|https://*) ;;
    *) echo "--github-proxy 需要 HTTP(S) URL。" >&2; exit 1 ;;
esac

echo "准备 proot-distro 环境..."
apt update -y
apt install -y proot-distro screen

if [ "$resume" = "n" ]; then
    if ! proot-distro install "$image" --override-alias napcat; then
        echo "容器安装失败。proot-distro 5 使用 OCI 镜像仓库；可通过 --image 指定可访问的 Debian 镜像或本地归档。" >&2
        exit 1
    fi
fi

echo "正在初始化 napcat 容器..."
login_options=()
for variable in http_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY \
    NAPCAT_CONNECT_TIMEOUT NAPCAT_DOWNLOAD_TIMEOUT; do
    if [ -n "${!variable+x}" ]; then
        login_options+=(--env "$variable=${!variable}")
    fi
done
for variable in CURL_CA_BUNDLE SSL_CERT_FILE; do
    if [ -n "${!variable:-}" ]; then
        certificate=$(realpath -- "${!variable}")
        if [ ! -f "$certificate" ]; then
            echo "$variable 指定的证书文件不存在。" >&2
            exit 1
        fi
        login_options+=(--bind "$certificate:/tmp/napcat-$variable.pem" --env "$variable=/tmp/napcat-$variable.pem")
    fi
done
if proot-distro login "${login_options[@]}" napcat -- bash -s -- "$github_proxy" <<'EOF'
set -e
apt update -y
apt install -y sudo curl ca-certificates libgcrypt20
github_proxy="${1%/}"
script=$(mktemp /root/napcat-install.XXXXXX)
trap 'rm -f -- "$script"' EXIT
curl -fL --connect-timeout "${NAPCAT_CONNECT_TIMEOUT:-20}" --max-time "${NAPCAT_DOWNLOAD_TIMEOUT:-1800}" \
    --proto '=http,https' --proto-redir '=http,https' \
    "${github_proxy:+${github_proxy}/}https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.sh" \
    -o "$script"
cd /root
read -r first_line < "$script"
if [[ "$first_line" != '#!'* ]]; then
    echo "下载的 NapCat 安装器不是 Shell 脚本。" >&2
    exit 1
fi
bash -n "$script"
bash "$script" --docker n --cli n --github-proxy "${github_proxy:-0}"
apt clean
EOF
then
    echo "NapCat 安装完成。"
else
    echo "初始化失败，已保留容器和数据。排除错误后使用 --resume 继续安装。" >&2
    exit 1
fi

echo '启动: proot-distro login napcat -- bash -c "xvfb-run -a /root/Napcat/opt/QQ/qq --no-sandbox"'
echo '后台启动: screen -dmS napcat proot-distro login napcat -- bash -c "xvfb-run -a /root/Napcat/opt/QQ/qq --no-sandbox"'
echo '快速登录: 在启动命令的 --no-sandbox 后添加 -q QQ号码。'
echo '进入容器: proot-distro login napcat'
echo '容器内配置目录: /root/Napcat/opt/QQ/resources/app/app_launcher/napcat/config'
echo '查看后台: screen -r napcat；按 Ctrl+A 后按 D 离开会话。'
