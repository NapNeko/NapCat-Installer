#!/bin/bash

clear

MAGENTA='\033[0;1;35;95m'
RED='\033[0;1;31;91m'
YELLOW='\033[0;1;33;93m'
GREEN='\033[0;1;32;92m'
CYAN='\033[0;1;36;96m'
BLUE='\033[0;1;34;94m'
NC='\033[0m'

echo -e " ${MAGENTA}┌${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}${RED}─┐${NC}"
echo -e " ${MAGENTA}│${RED}  ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA}  ${RED}  ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA}  ${RED}  ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA}  ${RED}  ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA}  ${RED}  ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA}  ${RED}  ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA} ${RED}│${NC}"
echo -e " ${RED}│${YELLOW}██${GREEN}█╗${CYAN}  ${BLUE} █${MAGENTA}█╗${RED}  ${YELLOW}  ${GREEN} █${CYAN}██${BLUE}██${MAGENTA}╗ ${RED}  ${YELLOW}  ${GREEN}██${CYAN}██${BLUE}██${MAGENTA}╗ ${RED}  ${YELLOW}  ${GREEN} █${CYAN}██${BLUE}██${MAGENTA}█╗${RED}  ${YELLOW}  ${GREEN} █${CYAN}██${BLUE}██${MAGENTA}╗ ${RED}  ${YELLOW}  ${GREEN}██${CYAN}██${BLUE}██${MAGENTA}██${RED}╗${YELLOW}│${NC}"
echo -e " ${YELLOW}│${GREEN}██${CYAN}██${BLUE}╗ ${MAGENTA} █${RED}█║${YELLOW}  ${GREEN}  ${CYAN}██${BLUE}╔═${MAGENTA}═█${RED}█╗${YELLOW}  ${GREEN}  ${CYAN}██${BLUE}╔═${MAGENTA}═█${RED}█╗${YELLOW}  ${GREEN}  ${CYAN}██${BLUE}╔═${MAGENTA}══${RED}═╝${YELLOW}  ${GREEN}  ${CYAN}██${BLUE}╔═${MAGENTA}═█${RED}█╗${YELLOW}  ${GREEN}  ${CYAN}╚═${BLUE}═█${MAGENTA}█╔${RED}══${YELLOW}╝${YELLOW}│${NC}"
echo -e " ${GREEN}│${CYAN}██${BLUE}╔█${MAGENTA}█╗${RED} █${YELLOW}█║${GREEN}  ${CYAN}  ${BLUE}██${MAGENTA}██${RED}██${YELLOW}█║${GREEN}  ${CYAN}  ${BLUE}██${MAGENTA}██${RED}██${YELLOW}╔╝${GREEN}  ${CYAN}  ${BLUE}██${MAGENTA}║ ${RED}  ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}██${MAGENTA}██${RED}██${YELLOW}█║${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA} █${RED}█║${YELLOW}  ${GREEN} ${GREEN}│${NC}"
echo -e " ${CYAN}│${BLUE}██${MAGENTA}║╚${RED}██${YELLOW}╗█${GREEN}█║${CYAN}  ${BLUE}  ${MAGENTA}██${RED}╔═${YELLOW}═█${GREEN}█║${CYAN}  ${BLUE}  ${MAGENTA}██${RED}╔═${YELLOW}══${GREEN}╝ ${CYAN}  ${BLUE}  ${MAGENTA}██${RED}║ ${YELLOW}  ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA}██${RED}╔═${YELLOW}═█${GREEN}█║${CYAN}  ${BLUE}  ${MAGENTA}  ${RED} █${YELLOW}█║${GREEN}  ${CYAN} ${CYAN}│${NC}"
echo -e " ${BLUE}│${MAGENTA}██${RED}║ ${YELLOW}╚█${GREEN}██${CYAN}█║${BLUE}  ${MAGENTA}  ${RED}██${YELLOW}║ ${GREEN} █${CYAN}█║${BLUE}  ${MAGENTA}  ${RED}██${YELLOW}║ ${GREEN}  ${CYAN}  ${BLUE}  ${MAGENTA}  ${RED}╚█${YELLOW}██${GREEN}██${CYAN}█╗${BLUE}  ${MAGENTA}  ${RED}██${YELLOW}║ ${GREEN} █${CYAN}█║${BLUE}  ${MAGENTA}  ${RED}  ${YELLOW} █${GREEN}█║${CYAN}  ${BLUE} ${BLUE}│${NC}"
echo -e " ${MAGENTA}│${RED}╚═${YELLOW}╝ ${GREEN} ╚${CYAN}══${BLUE}═╝${MAGENTA}  ${RED}  ${YELLOW}╚═${GREEN}╝ ${CYAN} ╚${BLUE}═╝${MAGENTA}  ${RED}  ${YELLOW}╚═${GREEN}╝ ${CYAN}  ${BLUE}  ${MAGENTA}  ${RED}  ${YELLOW} ╚${GREEN}══${CYAN}══${BLUE}═╝${MAGENTA}  ${RED}  ${YELLOW}╚═${GREEN}╝ ${CYAN} ╚${BLUE}═╝${MAGENTA}  ${RED}  ${YELLOW}  ${GREEN} ╚${CYAN}═╝${BLUE}  ${MAGENTA} ${MAGENTA}│${NC}"
echo -e " ${RED}└${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}──${YELLOW}──${GREEN}──${CYAN}──${BLUE}──${MAGENTA}──${RED}${YELLOW}─┘${NC}"
    echo -e "                      ${BLUE}Powered by NapCat-Installer${NC}\n"

execute_command() {
    echo -e "${2}中...${NC}"
    $1 > /dev/null 2>&1 &
    wait $!
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$2 成功${NC}"
    else
        echo -e "${RED}$2 失败${NC}"
        exit 1
    fi
}

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
        --proot)
            shift
            proot="$1"
            shift
            ;;
        *)
            echo -ne "${GREEN}Docker安装命令: bash $0 --docker [y|n] --qq \"114514\" --mode [ws|reverse_ws|reverse_http] --confirm --proxy [0|1|2|3|4|5|6]\n${NC}"
            echo -ne "${GREEN}直接安装命令: bash $0 --docker n --proxy [0|1|2|3|4] --force\n${NC}"
            exit 1;
            ;;
    esac
done

# 函数: 检查当前系统是amd64还是arm64 读取失败返回none
get_system_arch() {
    echo $(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) 
}

# 函数: 代理连通性测试
network_test() {
    local parm1=$1
    local found=0
    target_proxy=""
    proxy_num=${proxy_num:-9}

    if [ "$parm1" == "Github" ]; then
        proxy_arr=("https://ghp.ci" "https://github.moeyy.xyz" "https://mirror.ghproxy.com" "https://gh-proxy.com" "https://x.haod.me")
        check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    else
        proxy_arr=("docker.rainbond.cc" "docker.1panel.dev" "dockerpull.com" "dockerproxy.cn" "docker.agsvpt.work" "docker.agsv.top" "docker.registry.cyou")
        check_url=""
    fi

    if [ ! -z "$proxy_num" ] && [ "$proxy_num" -ge 1 ] && [ "$proxy_num" -le ${#proxy_arr[@]} ]; then
        echo -e "${GREEN}手动指定代理: ${proxy_arr[$proxy_num-1]}${NC}"
        target_proxy="${proxy_arr[$proxy_num-1]}"
    else
        if [ "$proxy_num" -ne 0 ]; then
            echo -e "${RED}proxy 未指定或超出范围, 正在检查${parm1}代理可用性...${NC}"
            for proxy in "${proxy_arr[@]}"; do
                status=$(curl -o /dev/null -s -w "%{http_code}" "$proxy/$check_url")
                if [ "$parm1" == "Github" ] && [ $status -eq 200 ]; then
                    found=1
                    target_proxy="$proxy"
                    echo "将使用${parm1}代理: $proxy"
                    break
                elif [ "$parm1" == "Docker" ] && ([ $status -eq 200 ] || [ $status -eq 301 ]); then
                    found=1
                    target_proxy="$proxy"
                    echo "将使用${parm1}代理: $proxy"
                    break
                fi
            done

            if [ $found -eq 0 ]; then
                echo -e "${RED}无法连接到${parm1}, 请检查网络。${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}代理已关闭, 将直接连接${parm1}...${NC}"
        fi
    fi
    napcat_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.Shell.zip"

    if [ "$system_arch" = "amd64" ]; then
        napcat_dlc_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/napcat.packet.linux"
    elif [ "$system_arch" = "arm64" ]; then
        napcat_dlc_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/napcat.packet.arm64"
    fi
    napcat_cli_download_url="${target_proxy:+${target_proxy}/}https://raw.githubusercontent.com/NapNeko/NapCat-Installer/refs/heads/main/script/napcat"
}

# 函数: 根据参数生成docker命令
generate_docker_command() {
    # 检查网络
    network_test "Docker" > /dev/null 2>&1

    local qq=$1
    local mode=$2
    docker_cmd1="sudo docker run -d -e ACCOUNT=$qq"
    docker_cmd2="--privileged --name napcat --restart=always ${target_proxy:+${target_proxy}/}mlikiowa/napcat-docker:latest"
    docker_ws="$docker_cmd1 -e WS_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -p 3001:3001 -p 6099:6099 $docker_cmd2"
    docker_reverse_ws="$docker_cmd1 -e WSR_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -e WS_URLS='[]' -p 6099:6099 $docker_cmd2"
    docker_reverse_http="$docker_cmd1 -e HTTP_ENABLE=true  -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -e HTTP_POST_ENABLE=true -e HTTP_URLS='[]' -p 3000:3000 -p 6099:6099 $docker_cmd2"
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

# 函数: 检查并返回可用的包管理器
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    else
        echo "none"
    fi
}

# 函数: 检查并返回可用的命令
detect_package_installer() {
    if command -v dpkg &> /dev/null; then
        echo "dpkg"
    elif command -v rpm &> /dev/null; then
        echo "rpm"
    else
        echo "none"
    fi
}

# 函数: 检查用户是否安装docker
check_docker() {
    if command -v docker &> /dev/null; then
        echo "true"
    else
        echo "false"
    fi
}

if ! command -v sudo &> /dev/null; then
    echo -ne "${RED}sudo不存在, 请手动安装: \n Centos: yum install -y sudo\n Debian/Ubuntu: apt install -y sudo\n${NC}"
	exit 1
fi

# 使用sudo id命令获取身份信息
sudo_id_output=$(sudo whoami)

# 检查输出中是否包含uid=0
if [[ $sudo_id_output == "root" ]]; then
  echo -e "${GREEN}当前用户是root用户 (uid=0) ,继续执行……${NC}"
else
  echo -e "${RED}当前用户不是root用户, 请将此用户加入sudo group后再试。${NC}"
  exit 1
fi

if [[ -z $use_docker ]]; then
    # Docker安装询问
    echo -e "${MAGENTA}是否使用Docker安装? (y/n)${NC}"
    read -r use_docker
fi
if [ "$use_docker" = "y" ]; then
    if [ "$(check_docker)" = "false" ]; then
         execute_command "sudo apt update -y" "更新软件包列表"
         execute_command "sudo apt install -y curl" "安装curl"
         sudo curl -fsSL https://nclatest.znin.net/docker_install_script -o get-docker.sh
         sudo chmod +x get-docker.sh
         execute_command "sudo sh get-docker.sh" "执行docker安装脚本"
    fi

    if [ "$(check_docker)" = "true" ]; then
        echo -e "${GREEN}Docker已安装${NC}"
    else
        echo -e "${RED}Docker安装失败${NC}"
        exit 1
    fi

    while true; do
        if [[ -z $qq ]]; then
            echo -e "${MAGENTA}请输入QQ号: ${NC}"
            read -r qq
        fi
        if [[ -z $mode ]]; then
            echo -e "${MAGENTA}请选择模式 (ws/reverse_ws/reverse_http) ${NC}"
            read -r mode
        fi
        docker_command=$(generate_docker_command "$qq" "$mode")
        if [[ -z $docker_command ]]; then
            echo -e "${RED}模式错误, 无法生成命令${NC}"
            confirm="n"
        else
            echo -e "${GREEN}${MAGENTA}即将执行以下命令: ${NC}${GREEN}$docker_command\n${NC}"
        fi
        if [[ -z $confirm ]]; then
            echo -e "${MAGENTA}是否继续? (y/n) ${NC}"
            read confirm
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
        echo -e "${RED}Docker启动失败, 请检查错误。${NC}"
        exit 1
    fi
    echo -e "${GREEN}安装成功${NC}"
    exit 0
elif [ "$use_docker" = "n" ]; then
    echo -e "${GREEN}不使用Docker安装${NC}"
else
    echo -e "${RED}输入错误, 请重新安装${NC}"
    exit 1
fi

system_arch=$(get_system_arch)
if [ "$system_arch" = "none" ]; then
    echo -e "${RED}无法识别的系统架构, 请检查错误。${NC}"
    exit 1
fi
echo -e "${GREEN}当前系统架构: $system_arch${NC}"

# 保证 curl/wget apt/rpm 基础环境
echo "正在更新依赖..."
package_manager=$(detect_package_manager)
# 开始安装基础依赖
if [ "$package_manager" = "apt" ]; then
    execute_command "sudo apt update -y" "更新软件包列表"
    execute_command "sudo apt install -y zip unzip jq curl xvfb screen xauth procps" "安装zip unzip jq curl xvfb screen xauth procps"
elif [ "$package_manager" = "yum" ]; then
    # 安装epel, 因为某些包在自带源里缺失
    execute_command "sudo yum install -y epel-release" "安装epel"
    execute_command "sudo yum install -y zip unzip jq curl xorg-x11-server-Xvfb screen procps-ng" "安装zip unzip jq curl xorg-x11-server-Xvfb screen procps-ng"
else
    echo -e "${RED}包管理器检查失败, 目前仅支持apt/yum。${NC}"
    exit 1
fi

update_linuxqq_config() {
    echo -e "正在更新用户QQ配置..."
    # 查找用户的QQ配置文件
    confs=$(sudo find /home -name "config.json" -path "*/.config/QQ/versions/*" 2>/dev/null)
    if [ -f /root/.config/QQ/versions/config.json ]; then
        confs="/root/.config/QQ/versions/config.json $confs"
    fi
    # 遍历配置文件并进行修改
    for conf in $confs; do
        echo -e "正在修改 $conf..."
        sudo jq --arg targetVer "$1" --arg buildId "$2" \
        '.baseVersion = $targetVer | .curVersion = $targetVer | .buildId = $buildId' "$conf" > "$conf.tmp" && \
        sudo mv "$conf.tmp" "$conf" || { echo -e "${RED}QQ配置更新失败! ${NC}"; exit 1; }
    done
    echo -e "${GREEN}更新用户QQ配置成功...${NC}"
}

modify_qq_config() {
    # 修改QQ Package配置
    echo -e "正在修改QQ启动配置..."
    index_path="./loadNapCat.js"
    tmp_path="/tmp/package.json.tmp"
    package_path="/opt/QQ/resources/app/package.json"
    echo -e "${GREEN}正在修改 $package_path..."
    sudo jq --arg jsPath "$index_path" \
    '.main = $jsPath' "$package_path" > "$tmp_path" && \
    sudo mv "$tmp_path" "$package_path" || { echo -e "${RED}QQ Package配置更新失败! "; exit 1; }
    wait $!
    echo -e "${GREEN}修改QQ启动配置成功...${NC}"
}

get_qq_target_version() {
    response=$( curl -s "https://nclatest.znin.net/get_qq_ver" )
    remoteQQVer=$( echo "$response" | jq -r '.linuxVersion' )
    remoteQQVerHash=$( echo "$response" | jq -r '.linuxVerHash' )
    echo "$remoteQQVer $remoteQQVerHash"
}

install_linuxqq() {
    echo -e "安装LinuxQQ..."
    base_url="https://dldir1.qq.com/qqfile/qq/QQNT/$package_targetVerHash/linuxqq_$package_targetVer"
    if [ "$system_arch" = "amd64" ]; then
        if [ "$package_installer" = "rpm" ]; then
            qq_download_url="${base_url}_x86_64.rpm"
        elif [ "$package_installer" = "dpkg" ]; then
            qq_download_url="${base_url}_amd64.deb"
        fi
    elif [ "$system_arch" = "arm64" ]; then
        if [ "$package_installer" = "rpm" ]; then
            qq_download_url="${base_url}_aarch64.rpm"
        elif [ "$package_installer" = "dpkg" ]; then
            qq_download_url="${base_url}_arm64.deb"
        fi
    fi

    if [ "$qq_download_url" = "" ]; then
        echo -e "${RED}无法下载QQ, 请检查错误。${NC}"
        exit 1
    fi
    echo -e "QQ下载链接: $qq_download_url"

    # TODO: 优化QQ包依赖
    # 鉴于QQ似乎仍在变动linux包的依赖, 所以目前暂时安装所有QQ认为其自身所需的依赖以尽力保证脚本正常工作
    if [ "$package_manager" = "yum" ]; then
        sudo curl -# -L "$qq_download_url" -o QQ.rpm
        if [ $? -ne 0 ]; then
            echo "文件下载失败, 请检查错误。"
            exit 1
        else
            echo "文件下载成功"
        fi
        execute_command "sudo yum localinstall -y ./QQ.rpm" "安装QQ"
        rm -f QQ.rpm
    elif [ "$package_manager" = "apt" ]; then
        sudo curl -# -L "$qq_download_url" -o QQ.deb
        if [ $? -ne 0 ]; then
            echo "文件下载失败, 请检查错误。"
            exit 1
        else
            echo "文件下载成功"
        fi
        execute_command "sudo apt install -f -y ./QQ.deb" "安装QQ"
        # QQ自己声明的依赖不全...需要手动补全
        execute_command "sudo apt install -y libnss3" "安装libnss3"
        execute_command "sudo apt install -y libgbm1" "安装libgbm1"
        # Ubuntu24.04开始libasound2已不存在, 这里偷懒尝试俩都装
        execute_command "sudo apt install -y libasound2" "安装libasound2"
        # sudo apt install -y libasound2t64
        rm -f QQ.deb
    fi
    update_linuxqq_config "$package_targetVer" "$target_build"
}

# 检测是否已安装LinuxQQ
package_name="linuxqq"
remote_qq_info=$(get_qq_target_version)
package_targetVer=$(echo "$remote_qq_info" | awk '{print $1}')
package_targetVerHash=$(echo "$remote_qq_info" | awk '{print $2}')
if [[ -z "$package_targetVer" || "$package_targetVer" == "null" ]] || [[ -z "$package_targetVerHash" || "$package_targetVerHash" == "null" ]]; then
    echo -e "${RED}无法获取远程QQ版本, 请检查错误。${NC}"
    exit 1
fi
target_build=${package_targetVer##*-}
package_installer=$(detect_package_installer)

echo -e "${YELLOW}最低linuxQQ版本: $package_targetVer, 构建: $target_build${NC}"
if [ "$force" = "y" ]; then
    echo -e "${GREEN}强制重装模式...${NC}"
    install_linuxqq
else
    if [ "$package_installer" = "rpm" ]; then
        if rpm -q $package_name &> /dev/null; then
            version=$(rpm -q --queryformat '%{VERSION}' $package_name)
            installed_build=${version##*-}
            echo -e "${MAGENTA}$package_name 已安装, 版本: $version, 构建: $installed_build${NC}"
            if (( installed_build < target_build )); then
                echo -e "${RED}版本过低, 需要更新。${NC}"
                install_linuxqq
            else
                echo -e "${GREEN}版本已满足要求, 无需更新。${NC}"
                update_linuxqq_config "$version" "$installed_build"
            fi
        else
            install_linuxqq
        fi
    elif [ "$package_installer" = "dpkg" ]; then
        if dpkg -l | grep $package_name &> /dev/null; then
            version=$(dpkg -l | grep "^ii" | grep "linuxqq" | awk '{print $3}')
            installed_build=${version##*-}
            echo -e "${YELLOW}$package_name 已安装, 版本: $version, 构建: $installed_build${NC}"
            if (( installed_build < target_build )); then
                echo -e "${RED}版本过低, 需要更新。${NC}"
                install_linuxqq
            else
                echo -e "${GREEN}版本已满足要求, 无需更新。${NC}"
                update_linuxqq_config "$version" "$installed_build"
            fi
        else
            install_linuxqq
        fi
    fi
fi
# 修改QQ配置
modify_qq_config

# 函数: 清理临时文件
clean() {
    rm -rf ./NapCat/
    rm -rf ./tmp/
    if [ $? -ne 0 ]; then
        echo -e "${RED}临时文件删除失败, 请手动删除 $default_file。${NC}"
    fi
    rm -rf ./NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        echo -e "${RED}NapCatQQ压缩包删除失败, 请手动删除 $default_file。${NC}"
    fi
}

install_napcat_cli() {
    if [ -f "/etc/init.d/napcat" ]; then
        sudo rm -f /etc/init.d/napcat
    fi

    echo -e "${GREEN}安装NapCatQQ CLI...${NC}"   
    network_test "Github"
    default_file="./tmp/napcat"
    echo -e "${MAGENTA}NapCatQQ CLI 下载链接: $napcat_cli_download_url${NC}"
    sudo curl -# -L "$napcat_cli_download_url" -o "$default_file"

    if [ $? -ne 0 ]; then
        echo -e "${RED}文件下载失败, 请检查错误。${NC}"
        exit 1
    fi

    if [ -f "$default_file" ]; then
        echo -e "${GREEN}$default_file 成功下载。${NC}"
    else
        ext_file=$(basename "$napcat_cli_download_url")
        if [ -f "$ext_file" ]; then
            mv "$ext_file" "$default_file"
            if [ $? -ne 0 ]; then
                echo -e "${GREEN}$default_file 成功下载。${NC}"
            else
                echo -e "${RED}文件更名失败, 请检查错误。${NC}"
                clean
                exit 1
            fi
        else
            echo -e "${RED}文件下载失败, 请检查错误。${NC}"
            clean
            exit 1
        fi
    fi

    echo -e "${GREEN}正在移动文件...${NC}"
    sudo cp -f ./tmp/napcat /usr/local/bin/napcat
    if [ $? -ne 0 -a $? -ne 1 ]; then
        echo -e "${RED}文件移动失败, 请以root身份运行。${NC}"
        clean
        exit 1
    fi
    sudo chmod +x /usr/local/bin/napcat
}

# 函数: 安装NapCatQQ DLC
install_napcat_dlc() {
    echo -e "安装NapCatQQ DLC..."
    
    # 网络测试    
    network_test "Github"

    default_file="./tmp/napcat.packet.linux"
    echo -e "${MAGENTA}NapCatQQ DLC 下载链接: $napcat_dlc_download_url${NC}"
    sudo curl -# -L "$napcat_dlc_download_url" -o "$default_file"
    if [ $? -ne 0 ]; then
        echo -e "${RED}文件下载失败, 请检查错误。${NC}"
        exit 1
    fi

    if [ -f "$default_file" ]; then
        echo -e "${GREEN}$default_file 成功下载。${NC}"
    else
        ext_file=$(basename "$napcat_dlc_download_url")
        if [ -f "$ext_file" ]; then
            mv "$ext_file" "$default_file"
            if [ $? -ne 0 ]; then
                echo -e "${GREEN}$default_file 成功下载。${NC}"
            else
                echo -e "${RED}文件更名失败, 请检查错误。${NC}"
                clean
                exit 1
            fi
        else
            echo -e "${RED}文件下载失败, 请检查错误。${NC}"
            clean
            exit 1
        fi
    fi

    if [ ! -d "$target_folder/napcat.packet" ]; then
        sudo mkdir "$target_folder/napcat.packet/"
    fi

    echo -e "正在移动文件..."
    sudo cp -f ./tmp/napcat.packet.linux "$target_folder/napcat.packet/"
    if [ $? -ne 0 -a $? -ne 1 ]; then
        echo -e "${RED}文件移动失败, 请以root身份运行。${NC}"
        clean
        exit 1
    fi

    sudo chmod +x "$target_folder/napcat.packet/napcat.packet.linux"
    jq '.packetServer = "127.0.0.1:8086"' $target_folder/napcat/config/napcat.json > $target_folder/napcat/config/napcat._json
    mv $target_folder/napcat/config/napcat._json $target_folder/napcat/config/napcat.json
}

# 函数: 安装NapCatQQ
install_napcat() {
    echo -e "安装NapCatQQ..."
    
    # 网络测试    
    network_test "Github"

    default_file="NapCat.Shell.zip"
    echo -e "${MAGENTA}NapCatQQ下载链接: $napcat_download_url${NC}"
    sudo curl -# -L "$napcat_download_url" -o "$default_file"
    if [ $? -ne 0 ]; then
        echo -e "${RED}文件下载失败, 请检查错误。${NC}"
        exit 1
    fi

    # 解压与清理
    mkdir ./NapCat/
    mkdir ./tmp/

    if [ -f "$default_file" ]; then
        echo -e "${GREEN}$default_file 成功下载。${NC}"
    else
        ext_file=$(basename "$napcat_download_url")
        if [ -f "$ext_file" ]; then
            mv "$ext_file" "$default_file"
            if [ $? -ne 0 ]; then
                echo -e "${GREEN}$default_file 成功下载。${NC}"
            else
                echo -e "${RED}文件更名失败, 请检查错误。${NC}"
                clean
                exit 1
            fi
        else
            echo -e "${RED}文件下载失败, 请检查错误。${NC}"
            clean
            exit 1
        fi
    fi

    echo -e "${GREEN}正在验证 $default_file..."
    unzip -t "$default_file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${RED}文件验证失败, 请检查错误。${NC}"
        clean
        exit 1
    fi

    echo -e "正在解压 $default_file..."
    unzip -q -o -d ./tmp/NapCat.Shell NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        echo -e "${RED}文件解压失败, 请检查错误。${NC}"
        clean
        exit 1
    fi
    
    if [ ! -d "$target_folder/napcat" ]; then
        sudo mkdir "$target_folder/napcat/"
    fi

    echo -e "正在移动文件..."
    sudo cp -r -f ./tmp/NapCat.Shell/* "$target_folder/napcat/"
    if [ $? -ne 0 -a $? -ne 1 ]; then
        echo -e "${RED}文件移动失败, 请以root身份运行。${NC}"
        clean
        exit 1
    fi

    sudo chmod -R 777 "$target_folder/napcat/"
    echo -e "正在修补文件..."
    sudo echo "(async () => {await import('file:///$target_folder/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js
    if [ $? -ne 0 ]; then
        echo -e "${RED}loadNapCat.js文件写入失败, 请以root身份运行。${NC}"
        clean
        exit 1
    fi

    if [ "$proot" = "y" ]; then
        echo -e "${RED}当前环境为proot, 跳过安装DLC。${NC}"
    elif [ "$proot" = "n" ]; then
        install_napcat_dlc
        install_napcat_cli
    else
        echo -e "${RED}输入错误, 请重新安装${NC}"
        exit 1
    fi

    clean
}

# napcat_version=$(curl "https://api.github.com/repos/NapNeko/NapCatQQ/releases/latest" | jq -r '.tag_name')
napcat_version=$(curl -s "https://nclatest.znin.net/" | jq -r '.tag_name')
if [ -z $napcat_version ]; then
    echo -e "${RED}无法获取NapCatQQ版本, 请检查错误。${NC}"
    exit 1
fi

echo -e "${YELLOW}最新NapCatQQ版本: $napcat_version${NC}"
target_folder="/opt/QQ/resources/app/app_launcher"
if [ "$force" = "y" ]; then
    echo -e "${GREEN}强制重装模式...${NC}"
    install_napcat
else
    if [ -d "$target_folder/napcat" ]; then
        current_version=$(jq -r '.version' "$target_folder/napcat/package.json")
        echo -e "${MAGENTA}NapCatQQ已安装, 版本: v$current_version${NC}"
        target_version=${napcat_version#v}
        IFS='.' read -r i1 i2 i3 <<< "$current_version"
        IFS='.' read -r t1 t2 t3 <<< "$target_version"
        if (( i1 < t1 || (i1 == t1 && i2 < t2) || (i1 == t1 && i2 == t2 && i3 < t3) )); then
            install_napcat
        else
            echo -e "${GREEN}已安装最新版本, 无需更新。${NC}"
        fi
    else
        install_napcat
    fi
fi
WEB_TOKEN=$(jq -r '.token' ${target_folder}/napcat/config/webui.json)
#clear
echo -e "\n安装完成, 请输入 ${GREEN}napcat help ${NC} 获取帮助。"
echo -e "后台快速登录 请输入 ${GREEN}napcat start QQ账号 ${NC}"
echo -e "Napcat安装位置 ${MAGENTA}$target_folder/napcat ${NC}"
echo -e "Napcat_DLC安装位置 ${MAGENTA}$target_folder/napcat.packet ${NC}"
echo -e "${GREEN}WEB_UI访问密钥为${RED} ${WEB_TOKEN} ${NC}"
echo
echo "旧方法: "
echo -e "输入${GREEN} xvfb-run -a qq --no-sandbox ${NC}命令启动。"
echo -e "保持后台运行 请输入${GREEN} screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox\" ${NC}"
echo -e "后台快速登录 请输入${GREEN} screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\" ${NC}"
echo -e "注意, 您可以随时使用${GREEN} screen -r napcat ${NC}来进入后台进程并使用${GREEN} ctrl + a + d ${NC}离开(离开不会关闭后台进程)。"
echo -e "停止后台运行 请输入${GREEN} screen -S napcat -X quit${NC}"
echo
echo -e "注意, 您需要手动执行以下命令${GREEN} cp -f $target_folder/napcat/config/napcat.json $target_folder/napcat/config/napcat_QQ号码.json${NC}"
echo -e "输入${GREEN} env -C $target_folder/napcat.packet ./napcat.packet.linux ${NC}命令启动DLC。"
echo -e "保持后台运行 请输入${GREEN} screen -dmS napcatdlc bash -c \"env -C $target_folder/napcat.packet ./napcat.packet.linux\"${NC}"
echo -e "停止后台运行 请输入${GREEN} screen -S napcatdlc -X quit${NC}"