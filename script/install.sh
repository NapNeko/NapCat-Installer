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
        --force)
            shift
            force="y"
            shift
            ;;
        --proxy)
            shift
            proxy_num="$1"
            shift
            ;;
        *)
            echo -ne "Docker安装命令: bash $0 --docker [y|n] --qq \"114514\" --mode [ws|reverse_ws|reverse_http] --confirm --proxy [0|1|2|3|4|5|6]\n"
            echo -ne "直接安装命令: bash $0 --docker n --proxy [0|1|2|3|4] --force\n"
            exit 1;
            ;;
    esac
done

# 函数：检查当前系统是amd64还是x86_64 读取失败返回none
get_system_arch() {
    echo $(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) 
}

# 函数：代理连通性测试
network_test() {
    local parm1=$1
    local found=0
    target_proxy=""
    proxy_num=${proxy_num:-9}

    if [ "$parm1" == "Github" ]; then
        proxy_arr=("https://github.moeyy.xyz" "https://mirror.ghproxy.com" "https://gh-proxy.com" "https://x.haod.me")
        check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    else
        proxy_arr=("docker.1panel.dev" "dockerpull.com" "dockerproxy.cn" "docker.agsvpt.work" "docker.agsv.top" "docker.registry.cyou")
        check_url=""
    fi

    if [ ! -z "$proxy_num" ] && [ "$proxy_num" -ge 1 ] && [ "$proxy_num" -le ${#proxy_arr[@]} ]; then
        echo "手动指定代理：${proxy_arr[$proxy_num-1]}"
        target_proxy="${proxy_arr[$proxy_num-1]}"
    else
        if [ "$proxy_num" -ne 0 ]; then
            echo "proxy 未指定或超出范围，正在检查${parm1}代理可用性..."
            for proxy in "${proxy_arr[@]}"; do
                status=$(curl -o /dev/null -s -w "%{http_code}" "$proxy/$check_url")
                if [ "$parm1" == "Github" ] && [ $status -eq 200 ]; then
                    found=1
                    target_proxy="$proxy"
                    echo "将使用${parm1}代理：$proxy"
                    break
                elif [ "$parm1" == "Docker" ] && ([ $status -eq 200 ] || [ $status -eq 301 ]); then
                    found=1
                    target_proxy="$proxy"
                    echo "将使用${parm1}代理：$proxy"
                    break
                fi
            done

            if [ $found -eq 0 ]; then
                echo "无法连接到${parm1}，请检查网络。"
                exit 1
            fi
        else
            echo "代理已关闭，将直接连接${parm1}..."
        fi
    fi
    napcat_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.Shell.zip"
}

# 函数：根据参数生成docker命令
generate_docker_command() {
    # 检查网络
    network_test "Docker" > /dev/null 2>&1

    local qq=$1
    local mode=$2
    docker_cmd1="sudo docker run -d -e ACCOUNT=$qq -e"
    docker_cmd2="--name napcat --restart=always ${target_proxy:+${target_proxy}/}mlikiowa/napcat-docker:latest"
    docker_ws="$docker_cmd1 WS_ENABLE=true -p 3001:3001 -p 6099:6099 $docker_cmd2"
    docker_reverse_ws="$docker_cmd1 WSR_ENABLE=true -e WS_URLS='[]' $docker_cmd2"
    docker_reverse_http="$docker_cmd1 HTTP_ENABLE=true -e HTTP_POST_ENABLE=true -e HTTP_URLS='[]' -p 3000:3000 -p 6099:6099 $docker_cmd2"
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

# 使用sudo id命令获取身份信息
sudo_id_output=$(sudo whoami)

# 检查输出中是否包含uid=0
if [[ $sudo_id_output == "root" ]]; then
  echo "当前用户是root用户（uid=0），继续执行……"
else
  echo "当前用户不是root用户，请将此用户加入sudo group后再试。"
  exit 1
fi

if [[ -z $use_docker ]]; then
    # Docker安装询问
    echo "是否使用Docker安装？(y/n)"
    read -r use_docker
fi
if [ "$use_docker" = "y" ]; then
    if [ "$(check_docker)" = "false" ]; then
         sudo apt update -y
         sudo apt install -y curl
         sudo curl -fsSL https://nclatest.znin.net/getdocker -o get-docker.sh
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
            echo -e "即将执行以下命令：$docker_command\n"
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
    if [ $? -ne 0 ]; then
        echo "Docker启动失败，请检查错误。"
        exit 1
    fi
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
echo "正在更新依赖..."
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
    qq_downGetUrl="https://qq-web.cdn-go.cn/im.qq.com_new/4d7d217d/202408081656/linuxQQDownload.js"
    if [ "$system_arch" = "amd64" ]; then
        if [ "$package_installer" = "rpm" ]; then
            qq_download_url=$(curl -s "$qq_downGetUrl" | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_x86_64_[0-9]{2}\.rpm')
        elif [ "$package_installer" = "dpkg" ]; then
            qq_download_url=$(curl -s "$qq_downGetUrl" | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_amd64_[0-9]{2}\.deb')
        fi
    elif [ "$system_arch" = "arm64" ]; then
        if [ "$package_installer" = "rpm" ]; then
            qq_download_url=$(curl -s "$qq_downGetUrl" | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_aarch64_[0-9]{2}\.rpm')
        elif [ "$package_installer" = "dpkg" ]; then
            qq_download_url=$(curl -s "$qq_downGetUrl" | grep -o -E 'https://dldir1\.qq\.com/qqfile/qq/QQNT/Linux/QQ_[0-9]+\.[0-9]+\.[0-9]+_[0-9]{6}_arm64_[0-9]{2}\.deb')
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
        sudo curl -L "$qq_download_url" -o QQ.rpm
        if [ $? -ne 0 ]; then
            echo "文件下载失败，请检查错误。"
            exit 1
        fi
        sudo yum localinstall -y ./QQ.rpm
        if [ $? -ne 0 ]; then
            echo "QQ安装失败，请检查错误。"
            exit 1
        fi
        rm -f QQ.rpm
    elif [ "$package_manager" = "apt" ]; then
        sudo curl -L "$qq_download_url" -o QQ.deb
        if [ $? -ne 0 ]; then
            echo "文件下载失败，请检查错误。"
            exit 1
        fi
        sudo apt install -f -y ./QQ.deb
        if [ $? -ne 0 ]; then
            echo "QQ安装失败，请检查错误。"
            exit 1
        fi
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
target_build=${package_targetVer##*-}
package_installer=$(detect_package_installer)

echo "最低linuxQQ版本：$package_targetVer，构建：$target_build"
if [ "$force" = "y" ]; then
    echo "强制重装模式..."
    install_linuxqq
else
    if [ "$package_installer" = "rpm" ]; then
        if rpm -q $package_name &> /dev/null; then
            version=$(rpm -q --queryformat '%{VERSION}' $package_name)
            installed_build=${version##*-}
            echo "$package_name 已安装，版本: $version，构建：$installed_build"
            if (( installed_build < target_build )); then
                echo "版本过低，需要更新。"
                install_linuxqq
            else
                echo "版本已满足要求，无需更新。"
            fi
        else
            install_linuxqq
        fi
    elif [ "$package_installer" = "dpkg" ]; then
        if dpkg -l | grep $package_name &> /dev/null; then
            version=$(dpkg -l | grep "^ii" | grep "linuxqq" | awk '{print $3}')
            installed_build=${version##*-}
            echo "$package_name 已安装，版本: $version，构建：$installed_build"
            if (( installed_build < target_build )); then
                echo "版本过低，需要更新。"
                install_linuxqq
            else
                echo "版本已满足要求，无需更新。"
            fi
        else
            install_linuxqq
        fi
    fi
fi

# 函数：清理临时文件
clean() {
    rm -rf ./NapCat/
    rm -rf ./tmp/
    if [ $? -ne 0 ]; then
        echo "临时文件删除失败，请手动删除 $default_file。"
    fi
    rm -rf ./NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        echo "NapCatQQ压缩包删除失败，请手动删除 $default_file。"
    fi
}

# 函数：安装NapCatQQ
install_napcat() {
    echo "安装NapCatQQ..."
    
    # 网络测试    
    network_test "Github"

    default_file="NapCat.Shell.zip"
    echo "NapCatQQ下载链接：$napcat_download_url"
    sudo curl -L "$napcat_download_url" -o "$default_file"
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

    echo "正在验证 $default_file..."
    unzip -t "$default_file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "文件验证失败，请检查错误。"
        clean
        exit 1
    fi

    echo "正在解压 $default_file..."
    unzip -q -o -d ./tmp/NapCat.Shell NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        echo "文件解压失败，请检查错误。"
        clean
        exit 1
    fi
    
    if [ ! -d "$target_folder/napcat" ]; then
        sudo mkdir "$target_folder/napcat/"
    fi

    echo "正在移动文件..."
    sudo cp -r -f ./tmp/NapCat.Shell/* "$target_folder/napcat/"
    if [ $? -ne 0 -a $? -ne 1 ]; then
        echo "文件移动失败，请以root身份运行。"
        clean
        exit 1
    fi

    sudo chmod -R 777 "$target_folder/napcat/"
    echo "正在修补文件..."
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

# napcat_version=$(curl "https://api.github.com/repos/NapNeko/NapCatQQ/releases/latest" | jq -r '.tag_name')
napcat_version=$(curl "https://nclatest.znin.net/" | jq -r '.tag_name')
if [ -z $napcat_version ]; then
    echo "无法获取NapCatQQ版本，请检查错误。"
    exit 1
fi

echo "最新NapCatQQ版本：$napcat_version"
target_folder="/opt/QQ/resources/app/app_launcher"
if [ "$force" = "y" ]; then
    echo "强制重装模式..."
    install_napcat
else
    if [ -d "$target_folder/napcat" ]; then
        current_version=$(jq -r '.version' "$target_folder/napcat/package.json")
        echo "NapCatQQ已安装，版本：v$current_version"
        target_version=${napcat_version#v}
        IFS='.' read -r i1 i2 i3 <<< "$current_version"
        IFS='.' read -r t1 t2 t3 <<< "$target_version"
        if (( i1 < t1 || (i1 == t1 && i2 < t2) || (i1 == t1 && i2 == t2 && i3 < t3) )); then
            install_napcat
        else
            echo "已安装最新版本，无需更新。"
        fi
    else
        install_napcat
    fi
fi

echo -e "\n安装完成，请输入 xvfb-run -a qq --no-sandbox 命令启动。"
echo "保持后台运行 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox\""
echo "后台快速登录 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\""
echo "Napcat安装位置 $target_folder/napcat"
echo "注意，您可以随时使用screen -r napcat来进入后台进程并使用ctrl + a + d离开(离开不会关闭后台进程)。"
