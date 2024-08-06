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

if [[ -z $use_docker ]]; then
    # Docker安装询问
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

# 保证 curl/wget apt/rpm 基础环境
echo "检测包管理器..."
package_manager=$(detect_package_manager)
# 开始安装基础依赖
if [ "$package_manager" = "apt" ]; then
    sudo apt update -y
    sudo apt install -y zip unzip jq curl xvfb screen
elif [ "$package_manager" = "yum" ]; then
    # 安装epel, 因为某些包在自带源里缺失
    sudo yum install -y epel-release
    sudo yum install -y zip unzip jq curl xorg-x11-server-Xvfb screen
else
    echo "包管理器检查失败，目前仅支持apt/yum。"
    exit 1
fi

install_linuxqq() {
    echo "安装LinuxQQ..."
    qq_download_url=""
    #https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.8_240520_amd64_01.deb
    if [ "$system_arch" = "amd64" ]; then
        if [ "$package_installer" = "rpm" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/f74d4392/linuxqq_3.2.12-26702_x86_64.rpm"
            #qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/f2ff7664/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_x86_64_[0-9]{2}\.rpm')
        elif [ "$package_installer" = "dpkg" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/f74d4392/linuxqq_3.2.12-26702_amd64.deb"
            #qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/f2ff7664/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_amd64_[0-9]{2}\.deb')
        fi
    elif [ "$system_arch" = "arm64" ]; then
        if [ "$package_installer" = "rpm" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/f74d4392/linuxqq_3.2.12-26702_aarch64.rpm"
            #qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/f2ff7664/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_aarch64_[0-9]{2}\.rpm')
        elif [ "$package_installer" = "dpkg" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/f74d4392/linuxqq_3.2.12-26702_arm64.deb"
            #qq_download_url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/f2ff7664/rainbow/linuxQQDownload.js | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_arm64_[0-9]{2}\.deb')
        fi
    fi

    if [ "$qq_download_url" = "" ]; then
        echo "无法下载QQ，请检查错误。"
        exit 1
    fi
    echo "QQ下载链接：$qq_download_url"

    # TODO: 优化QQ包依赖
    # 鉴于QQ似乎仍在变动linux包的依赖, 所以目前暂时安装所有QQ认为其自身所需的依赖以尽力保证脚本正常工作
    if [ "$package_manager" = "yum" ]; then
        curl -L "$qq_download_url" -o QQ.rpm
        sudo yum localinstall -y ./QQ.rpm
        rm -f QQ.rpm
    elif [ "$package_manager" = "apt" ]; then
        curl -L "$qq_download_url" -o QQ.deb
        sudo apt install -f -y ./QQ.deb
        # QQ自己声明的依赖不全...需要手动补全
        sudo apt install -y libnss3
        sudo apt install -y libgbm1
        # Ubuntu24.04开始libasound2已不存在, 这里偷懒尝试俩都装
        sudo apt install -y libasound2
        # sudo apt install -y libasound2t64
        rm -f QQ.deb
    fi
}

# 检测是否已安装LinuxQQ
package_name="linuxqq"
package_targetVer="3.2.12-26702"
package_installer=$(detect_package_installer)

echo "目标linuxqq版本：$package_targetVer"
if [ "$package_installer" = "rpm" ]; then
    if rpm -q $package_name &> /dev/null; then
        version=$(rpm -q --queryformat '%{VERSION}' $package_name)
        echo "$package_name 已安装，版本: $version"
        if [ "$version" -ne "$package_targetVer" ]; then
            install_linuxqq
        fi
    else
        install_linuxqq
    fi
elif [ "$package_installer" = "dpkg" ]; then
    if dpkg -s $package_name &> /dev/null; then
        version=$(dpkg -s $package_name | grep Version | awk '{print $2}')
        echo "$package_name 已安装，版本: $version"
        if [ "$version" != "$package_targetVer" ]; then
            install_linuxqq
        fi
    else
        install_linuxqq
    fi
fi

clean() {
    rm -rf ./NapCat/
    rm -rf ./tmp/
    if [ $? -ne 0 ]; then
        echo "临时文件删除失败，请手动删除 $default_file。"
    fi
    rm -rf ./NapCat.linux.zip
    if [ $? -ne 0 ]; then
        echo "NapCat压缩包删除失败，请手动删除 $default_file。"
    fi
}

install_napcat() {
    github_proxy="https://github.moeyy.xyz" # https://mirror.ghproxy.com
    
    napcat_download_url=""
    #https://github.com/NapNeko/NapCatQQ/releases/download/v1.4.0/NapCat.linux.arm64.zip
    #https://github.com/NapNeko/NapCatQQ/releases/download/v1.4.0/NapCat.linux.x64.zip
    if [ "$system_arch" = "amd64" ]; then
        napcat_download_url="$github_proxy/https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.linux.x64.zip"
    elif [ "$system_arch" = "arm64" ]; then
        napcat_download_url="$github_proxy/https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.linux.arm64.zip"
    else 
        echo "无法下载NapCatQQ，请检查错误。"
        exit 1
    fi

    default_file="NapCat.linux.zip"
    echo "NapCatQQ下载链接：$napcat_download_url"
    curl -L "$napcat_download_url" -o "$default_file"
    if [ $? -ne 0 ]; then
        echo "文件下载失败，请检查错误。"
        exit 1
    fi

    # 解压与清理
    mkdir ./NapCat/
    mkdir ./tmp/

    if [ -f "$default_file" ]; then
        echo "$default_file 成功下载。"
    else
        ext_file=$(basename "$napcat_download_url")
        if [ -f "$ext_file" ]; then
            mv "$ext_file" "$default_file"
            if [ $? -ne 0 ]; then
                echo "$default_file 成功下载。"
            else
                echo "文件更名失败，请检查错误。"
                clean
                exit 1
            fi
        else
            echo "文件下载失败，请检查错误。"
            clean
            exit 1
        fi
    fi

    unzip -q -o -d ./tmp NapCat.linux.zip
    if [ $? -ne 0 ]; then
        echo "文件解压失败，请检查错误。"
        clean
        exit 1
    fi

    if [ ! -d "$target_folder/napcat" ]; then
        sudo mkdir "$target_folder/napcat/"
    fi

    if [ "$system_arch" = "amd64" ]; then
        sudo cp -r -f ./tmp/NapCat.linux.x64/* "$target_folder/napcat/"
    elif [ "$system_arch" = "arm64" ]; then
        sudo cp -r -f ./tmp/NapCat.linux.arm64/* "$target_folder/napcat/"
    fi
    if [ $? -ne 0 -a $? -ne 1 ]; then
        echo "文件移动失败，请以root身份运行。"
        clean
        exit 1
    fi

    sudo chmod -R 777 "$target_folder/napcat/"
    sudo mv -f "$target_folder/index.js" "$target_folder/index.js.bak"
    output_index_js=$(echo -e "const path = require('path');\nconst CurrentPath = path.dirname(__filename)\nconst hasNapcatParam = process.argv.includes('--no-sandbox');\nif (hasNapcatParam) {\n    (async () => {\n        await import(\\\"file://\\\" + path.join(CurrentPath, './napcat/napcat.mjs'));\n    })();\n} else {\n    require('./launcher.node').load('external_index', module);\n}")
    sudo bash -c "echo \"$output_index_js\" > \"$target_folder/index.js\""

    if [ $? -ne 0 ]; then
        echo "index.js文件写入失败，请以root身份运行。"
        clean
        exit 1
    fi
    clean
}

napcat_version=$(curl "https://api.github.com/repos/NapNeko/NapCatQQ/releases/latest" | jq -r '.tag_name')
if [ "$napcat_version" = "" ]; then
    echo "无法获取NapCat版本，请检查错误。"
    exit 1
fi

echo "最新NapCat版本：$napcat_version"
target_folder="/opt/QQ/resources/app/app_launcher"
if [ -d "$target_folder/napcat" ]; then
    current_version=$(jq -r '.version' "$target_folder/napcat/package.json")
    echo "NapCat 已安装，版本：v$current_version"
    if [ "v$current_version" != "$napcat_version" ]; then
        install_napcat
    fi
else
    install_napcat
fi

echo -e "\n安装完成，请输入 xvfb-run -a qq --no-sandbox 命令启动。"
echo "保持后台运行 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox\""
echo "后台快速登录 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\""
echo "注意，您可以随时使用screen -r napcat来进入后台进程并使用ctrl + a + d离开(离开不会关闭后台进程)。"