#!/bin/bash

# From DebianNET.sh
while [[ $# -ge 1 ]]; do
    case $1 in
        --docker)
            shift
            use_docker="$1"
            shift
            ;;
        --qq)
            shift
            qq="$1"
            shift
            ;;
        --mode)
            shift
            mode="$1"
            shift
            ;;
        --confirm)
            shift
            confirm="y"
            ;;
        *)
            echo -ne " Usage: bash $0 --docker [y|n] --qq \"114514\" --mode [ws|reverse_ws|reverse_http] --confirm\n"
            exit 1;
            ;;
    esac
done

# 函数：检查当前系统是amd64还是x86_64 读取失败返回none
get_system_arch() {
    echo $(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) 
}

# 函数：根据参数生成docker命令
generate_docker_command() {
    local qq=$1
    local mode=$2
    docker_ws="docker run -d -e ACCOUNT=$qq -e WS_ENABLE=true -p 3001:3001 -p 6099:6099 --name napcat --restart=always mlikiowa/napcat-docker:latest"
    docker_reverse_ws="docker run -d -e ACCOUNT=$qq -e WSR_ENABLE=true -e WS_URLS='[]' --name napcat --restart=always mlikiowa/napcat-docker:latest"
    docker_reverse_http="docker run -d -e ACCOUNT=$qq -e HTTP_ENABLE=true -e HTTP_POST_ENABLE=true -e HTTP_URLS='[]' -p 3000:3000 -p 6099:6099 --name napcat --restart=always mlikiowa/napcat-docker:latest"
    if [ "$mode" = "ws" ]; then
        echo $docker_ws
    elif [ "$mode" = "reverse_ws" ]; then
        echo $docker_reverse_ws
    elif [ "$mode" = "reverse_http" ]; then
        echo $docker_reverse_http
    else
        exit 1
    fi
}

# 函数：检查并返回可用的包管理器
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    else
        echo "none"
    fi
}

# 函数：检查并返回可用的命令
detect_package_installer() {
    if command -v dpkg &> /dev/null; then
        echo "dpkg"
    elif command -v rpm &> /dev/null; then
        echo "rpm"
    else
        echo "none"
    fi
}

# 函数：检查用户是否安装docker
check_docker() {
    if command -v docker &> /dev/null; then
        echo "true"
    else
        echo "false"
    fi
}

if ! command -v sudo &> /dev/null; then
    echo -ne "sudo不存在, 请手动安装: \n Centos: yum install -y sudo\n Debian/Ubuntu: apt install -y sudo\n"
	exit 1
fi

# 保证 curl/wget apt/rpm 基础环境
echo "检测包管理器..."

if [[ -z $use_docker ]]; then
    # 询Docker安装询问
    echo "是否使用Docker安装？(y/n)"
    read -r use_docker
fi
if [ "$use_docker" = "y" ]; then
    if [ "$(check_docker)" = "false" ]; then
         sudo curl -fsSL https://get.docker.com -o get-docker.sh
         sudo chmod +x get-docker.sh
         sudo sh get-docker.sh
    fi

    if [ "$(check_docker)" = "true" ]; then
        echo "Docker已安装"
    else
        echo "Docker安装失败"
        exit 1
    fi

    while true; do
        if [[ -z $qq ]]; then
            echo "请输入QQ号："
            read -r qq
        fi
        if [[ -z $mode ]]; then
            echo "请选择模式（ws/reverse_ws/reverse_http）"
            read -r mode
        fi
        docker_command=$(generate_docker_command "$qq" "$mode")
        if [[ -z $docker_command ]]; then
            echo "模式错误, 无法生成命令"
            confirm="n"
        else
            echo "即将执行以下命令：$docker_command"
        fi
        if [[ -z $confirm ]]; then
            read -p "是否继续？(y/n) " confirm
        fi
        case $confirm in
            y|Y ) break;;
            * )
                # 如果取消了则说明需要重新初始化以上信息
                confirm=""
                mode=""
                qq=""
                ;;
        esac
    done
    eval "$docker_command"
    echo "安装成功"
    exit 0
elif [ "$use_docker" = "n" ]; then
    echo "不使用Docker安装"
else
    echo "输入错误，请重新安装"
    exit 1
fi

system_arch=$(get_system_arch)
if [ "$system_arch" = "none" ]; then
    echo "无法识别的系统架构，请检查错误。"
    exit 1
fi

echo "当前系统架构：$system_arch"

package_manager=$(detect_package_manager)
# 开始安装依赖
if [ "$package_manager" = "apt" ];then
    sudo apt update -y
    sudo apt install -y libgbm1 libasound2 zip unzip jq curl
else
    sudo yum install -y libgbm alsa-lib-devel nss dbus-libs at-spi2-atk gtk3 cups-libs zip unzip jq curl
fi

qq_download_url=""
package_installer=$(detect_package_installer)
#https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.8_240520_amd64_01.deb
if [ "$system_arch" = "amd64" ]; then
    if [ "$package_installer" = "rpm" ]; then
        qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_x86_64_[0-9]{2}\.rpm')
    elif [ "$package_installer" = "dpkg" ]; then
        qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_amd64_[0-9]{2}\.deb')
    fi
elif [ "$system_arch" = "arm64" ]; then
    if [ "$package_installer" = "rpm" ]; then
        qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_aarch64_[0-9]{2}\.rpm')
    elif [ "$package_installer" = "dpkg" ]; then
        qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_arm64_[0-9]{2}\.deb')
    fi
fi

if [ "$qq_download_url" = "" ]; then
    echo "无法下载QQ，请检查错误。"
    exit 1
fi
echo "QQ下载链接：$qq_download_url"

# 没有完成强制安装
if [ "$package_installer" = "rpm" ]; then
    curl -L "$qq_download_url" -o QQ.rpm
    rpm -Uvh ./QQ.rpm
    rm QQ.rpm
 elif [ "$package_installer" = "dpkg" ]; then
    curl -L "$qq_download_url" -o QQ.deb
    dpkg -i QQ.deb
    rm QQ.deb
fi


napcat_version=$(curl "https://api.github.com/repos/NapNeko/NapCatQQ/releases/latest" | jq -r '.tag_name')
if [ "$napcat_version" = "" ]; then
    echo "无法获取NapCatQQ版本，请检查错误。"
    exit 1
fi

napcat_download_url=""
#https://github.com/NapNeko/NapCatQQ/releases/download/v1.4.0/NapCat.linux.arm64.zip
#https://github.com/NapNeko/NapCatQQ/releases/download/v1.4.0/NapCat.linux.x64.zip
if [ "$system_arch" = "amd64" ]; then
    napcat_download_url="https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.linux.x64.zip"
elif [ "$system_arch" = "arm64" ]; then
    napcat_download_url="https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.linux.arm64.zip"
else 
    echo "无法下载NapCatQQ，请检查错误。"
    exit 1
fi
echo "NapCatQQ下载链接：$napcat_download_url"
curl -L "$napcat_download_url" -o "NapCat.linux.zip"

# 解压与清理
mkdir ./NapCat/
mkdir ./tmp/
unzip -q -d ./tmp NapCat.linux.zip

rm -rf ./NapCat.linux.zip
if [ "$system_arch" = "amd64" ]; then
    mv ./tmp/NapCat.linux.x64/* ./NapCat/
elif [ "$system_arch" = "arm64" ]; then
    mv ./tmp/NapCat.linux.arm64/* ./NapCat/
fi
rm -rf ./tmp/
chmod +x ./NapCat/napcat.sh

echo "安装完成 输入 bash ./NapCat/napcat.sh 启动"
