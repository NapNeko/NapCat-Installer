#!/bin/bash

# 函数：检查当前系统是amd64还是x86_64 读取失败返回none
get_system_arch() {
    arch=$(uname -m)
    if [ "$arch" = "x86_64" ] || [ "$arch" = "amd64" ]; then
        return "amd64"
    elif [ "$arch" = "i386" ] || [ "$arch" = "i686" ]; then
        return "x86_64"
    fi
    return "none"
}

# 函数：根据参数生成docker命令
generate_docker_command(qq,mode) {
    local qq=$1
    local mode=$2
    docker_ws = "docker run -d -e ACCOUNT=$qq -e WS_ENABLE=true -p 3001:3001 -p 6099:6099 --name napcat --restart=always mlikiowa/napcat-docker:latest"
    docker_reverse_ws = "docker run -d -e ACCOUNT=$qq -e WSR_ENABLE=true -e WS_URLS='[]' --name napcat --restart=always mlikiowa/napcat-docker:latest"
    docker_reverse_http = "docker run -d -e ACCOUNT=$qq -e HTTP_ENABLE=true -e HTTP_POST_ENABLE=true -e HTTP_URLS='[]' -p 3000:3000 -p 6099:6099 --name napcat --restart=always mlikiowa/napcat-docker:latest"
    if [ "$mode" = "ws" ]; then
        return "$docker_ws"
    elif [ "$mode" = "reverse_ws" ]; then
        return "$docker_reverse_ws"
    elif [ "$mode" = "reverse_http" ]; then
        return "$docker_reverse_http"
    else
        echo "Invalid mode: $mode"
        exit 1
    fi
    return ""
}

# 函数：检查并返回可用的下载工具
detect_download_tool() {
    if command -v wget &> /dev/null; then
        return "wget"
    elif command -v curl &> /dev/null; then
        return "curl"
    else
        return "none"
    fi
}

# 函数：检查并返回可用的包管理器
detect_package_manager() {
    if command -v apt &> /dev/null; then
        return "apt"
    elif command -v yum &> /dev/null; then
        return "yum"
    else
        return "none"
    fi
}

# 函数：检查并返回可用的命令
detect_package_installer() {
    if command -v dpkg &> /dev/null; then
        return "dpkg"
    elif command -v rpm &> /dev/null; then
        return "rpm"
    else
        return "none"
    fi
}

# 函数：检查用户是否安装docker
check_docker() {
    if command -v docker &> /dev/null; then
        return "true"
    else
        return "false"
    fi
}

# 函数：请求http url获取文本内容作为函数返回值
http_get() {
    local url=$1
    local tool=$2

    if [ "$tool" = "wget" ]; then
        return $(wget -qO- $url)
    elif [ "$tool" = "curl" ]; then
        return $(curl -s $url)
    else
        echo "无法识别的包管理器，无法安装下载工具。"
        exit 1
    fi
    return ""
}


# 保证 curl/wget apt/rpm 基础环境
echo "检测下载工具和包管理器..."
download_tool=$(detect_download_tool)
package_manager=$(detect_package_manager)

# 如果没有可用的下载工具，则根据包管理器安装curl或wget
if [ "$download_tool" = "none" ]; then
    if [ "$package_manager" = "apt" ]; then
        echo "尝试使用apt安装curl..."
        apt install curl -y || { echo "安装curl失败，请检查错误。"; }
    elif [ "$package_manager" = "yum" ]; then
        echo "尝试使用yum安装curl..."
        yum install curl -y || { echo "安装curl失败，请检查错误。"; }
    else
        echo "无法识别的包管理器，无法安装下载工具。"
        exit 1
    fi

    # 再次检查下载工具
    download_tool=$(detect_download_tool)

    if [ "$download_tool" = "none" ]; then
        if [ "$package_manager" = "apt" ]; then
            echo "尝试使用apt安装wget..."
            apt install wget -y || { echo "安装wget失败，请检查错误。"; }
        elif [ "$package_manager" = "yum" ]; then
            echo "尝试使用yum安装wget..."
            yum install wget -y || { echo "安装wget失败，请检查错误。"; }
        else
            echo "无法识别的包管理器，无法安装下载工具。"
            exit 1
        fi
    fi
else
    echo "已有的下载工具：$download_tool"
fi

# 最终检查curl/wegt环境
if [ "$download_tool" = "none" ]; then
    echo "无法识别的下载工具，请检查错误。"
    exit 1
fi

# 询Docker安装询问
echo "是否使用Docker安装？(y/n)"
read -r use_docker
if [ "$use_docker" = "y" ]; then
    if [ "$(check_docker)" = "false" ]; then
        if["$download_tool" = "curl" ]; then
         sudo curl -fsSL https://get.docker.com -o get-docker.sh
        elif ["$download_tool" = "wget" ]; then
         sudo wget -O get-docker.sh https://get.docker.com
        fi
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
        echo "请输入QQ号："
        read -r qq
        echo "请选择模式（ws/reverse_ws/reverse_http） 不选择默认启用ws："
        read -r mode
        docker_command=$(generate_docker_command "$qq" "$mode")
        echo "即将执行以下命令：$docker_command"
        read -p "是否继续？(y/n)" confirm
        case $confirm in
            y|Y ) break;;
            n|N ) continue;;
            * ) echo "请输入y或n";;
        esac
    done
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

# 读取 https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/linuxQQDownload.js 内容
# ReqData 如下为文本需要文本处理匹配出 https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_?_?_?_??????_arm64_??.deb  的下载链接 ?代表未知值
# 或者https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_?_?_?_??????_x86_64_??.deb 的下载链接 ?代表未知值
ReqData=$(http_get "https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/linuxQQDownload.js" "$download_tool")

# 获取链接还有问题
qq_download_url=""

if [ "$system_arch" = "amd64" ]; then
    if ["$package_installer" = "rpm" ]; then
        qq_download_url=$(echo "$ReqData" | grep -oP 'https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_[0-9.]+_[0-9]+_x86_64_[0-9]+.rpm')
    elif ["$package_installer" = "dpkg" ]; then
        qq_download_url=$(echo "$ReqData" | grep -oP 'https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_[0-9.]+_[0-9]+_x86_64_[0-9]+.deb')
    fi
elif [ "$system_arch" = "arm64" ]; then
        if ["$package_installer" = "rpm" ]; then
        qq_download_url=$(echo "$ReqData" | grep -oP 'https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_[0-9.]+_[0-9]+_arm64_[0-9]+.rpm')
    elif ["$package_installer" = "dpkg" ]; then
        qq_download_url=$(echo "$ReqData" | grep -oP 'https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_[0-9.]+_[0-9]+_arm64_[0-9]+.deb')
    fi
fi

if ["$qq_download_url" = "" ]; then
    echo "无法下载QQ，请检查错误。"
    exit 1
fi
echo "QQ下载链接：$qq_download_url"

package_installer=$(detect_package_installer)

# 没有完成强制安装
if [ "$download_tool" = "curl" ]; then
    if ["$package_installer" = "rpm" ]; then
        curl -L "$qq_download_url" -o "QQ.rpm"
        rpm -ivh "QQ.rpm"
        rm QQ.rpm
    elif ["$package_installer" = "dpkg" ]; then
        curl -L "$qq_download_url" -o "QQ.deb"
        dpkg -i --force-depends QQ.deb
        rm QQ.deb
elif [ "$download_tool" = "wget" ]; then
    if ["$package_installer" = "rpm" ]; then
        wget -O "QQ.rpm" "$qq_download_url"
        rpm -ivh "QQ.rpm"
        rm QQ.rpm
    elif ["$package_installer" = "dpkg" ]; then
        wget -O "QQ.deb" "$qq_download_url"
        dpkg -i --force-depends QQ.deb
        rm QQ.deb
else
   echo "无法识别的下载工具，请检查错误。"
   exit 1
fi

# 开始安装依赖
if [ "$package_manager" = "apt" ];then
    sudo apt install libgbm1 libasound2
else
    sudo yum install libgbm libasound
fi

if [ "$napcat_version" = "" ]; then
    echo "无法获取NapCatQQ版本，请检查错误。"
    exit 1
fi

napcat_download_url=""
if ["$system_arch" = "amd64" ]; then
    napcat_download_url="https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.linux.amd64.zip"
elif ["$system_arch" = "arm64" ]; then
    napcat_download_url="https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.linux.arm64.zip"
fi
if ["$napcat_download_url" = "" ]; then
    echo "无法下载NapCatQQ，请检查错误。"
    exit 1
fi
if [ "$download_tool" = "curl" ]; then
    curl -L "$napcat_download_url" -o "NapCat.linux.zip"
elif [ "$download_tool" = "wget" ]; then
    wget -O "NapCat.linux.zip" "$napcat_download_url"
else
   echo "无法识别的下载工具，请检查错误。"
   exit 1
fi

# 解压与清理
unzip -q NapCat.linux.zip
mkdir ./NapCat/
mv ./NapCat.linux.${system_arch} ./NapCat/
rm -rf ./NapCat.linux.zip

sudo chmod +x ./NapCat/start.sh

echo "安装完成 输入./NapCat/start.sh 启动"
