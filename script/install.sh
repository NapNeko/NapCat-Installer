#!/bin/bash

# 清屏
clear

# 自定义颜色
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

# QQ安装目录
target_folder="/opt/QQ/resources/app/app_launcher"

# 日志
function log() {
    time=$(date +"%Y-%m-%d %H:%M:%S")
    message="[${time}]: $1 "
    case "$1" in
        *"失败"*|*"错误"*|*"sudo不存在"*|*"当前用户不是root用户"*|*"无法连接"*)
            echo -e "${RED}${message}${NC}"
            ;;
        *"成功"*)
            echo -e "${GREEN}${message}${NC}"
            ;;
        *"忽略"*|*"跳过"*)
            echo -e "${YELLOW}${message}${NC}"
            ;;
        *)
            echo -e "${BLUE}${message}${NC}"
            ;;
    esac
}

# 执行命令
function execute_command() {
    log "${2}中..."
    $1
    if [ $? -eq 0 ]; then
        log "$2 ($1)成功"
    else
        log "$2 ($1)失败"
        exit 1
    fi
}

# 检查sudo
function sudo_check() {
    if ! command -v sudo &> /dev/null; then
        log "sudo不存在, 请手动安装: \n Centos: dnf install -y sudo\n Debian/Ubuntu: apt-get install -y sudo\n"
        exit 1
    fi
}

# 检查root
function root_check() {
    sudo_check
    sudo_id_output=$(sudo whoami)
    if [[ ! $sudo_id_output == "root" ]]; then
        log "当前用户不是root用户, 请将此用户加入sudo group后再试。"
        exit 1
    fi
    get_system_arch
}

# 检查当前系统是amd64还是arm64 读取失败返回none
function get_system_arch() {
    system_arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)
    if [ "$system_arch" = "none" ]; then
        log "无法识别的系统架构, 请检查错误。"
        exit 1
    fi
}

# 检查并返回可用的高级包管理器
function detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        package_manager="apt-get"
    elif command -v dnf &> /dev/null; then
        package_manager="dnf"
    fi
}

# 检查并返回可用的基础包管理器
function detect_package_installer() {
    if command -v dpkg &> /dev/null; then
        package_installer="dpkg"
    elif command -v rpm &> /dev/null; then
        package_installer="rpm"
    fi
}

function create_tmp_folder() {
    if [[ -d "./NapCat/" ]] || [[ -d "./napcattmp/" ]] ; then
        log "文件夹已存在(./NapCat/及./napcattmp/), 请重命名后重新执行脚本防止误删"
        exit 1
    fi
    sudo mkdir -p ./NapCat/
    sudo mkdir -p ./napcattmp/
}

# 函数: 清理临时文件
function clean() {
    sudo rm -rf ./NapCat/
    sudo rm -rf ./napcattmp/
    if [ $? -ne 0 ]; then
        log "临时文件删除失败, 请手动删除 $default_file。"
    fi
    sudo rm -rf ./NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        log "NapCatQQ压缩包删除失败, 请手动删除 $default_file。"
    fi
    if [ -f "/etc/init.d/napcat" ]; then
        sudo rm -f /etc/init.d/napcat
    fi
    if [ -d "$target_folder/napcat.packet" ]; then
        sudo rm -rf  "$target_folder/napcat.packet"
    fi
}

# 代理连通性测试并获取下载链接
function network_test() {
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
        log "手动指定代理: ${proxy_arr[$proxy_num-1]}"
        target_proxy="${proxy_arr[$proxy_num-1]}"
    else
        if [ "$proxy_num" -ne 0 ]; then
            log "proxy 未指定或超出范围, 正在检查${parm1}代理可用性..."
            for proxy in "${proxy_arr[@]}"; do
                status=$(curl -o /dev/null -s -w "%{http_code}" "$proxy/$check_url")
                if [ "$parm1" == "Github" ] && [ $status -eq 200 ]; then
                    found=1
                    target_proxy="$proxy"
                    log "将使用${parm1}代理: $proxy"
                    break
                elif [ "$parm1" == "Docker" ] && ([ $status -eq 200 ] || [ $status -eq 301 ]); then
                    found=1
                    target_proxy="$proxy"
                    log "将使用${parm1}代理: $proxy"
                    break
                fi
            done

            if [ $found -eq 0 ]; then
                log "无法连接到${parm1}, 请检查网络。"
                exit 1
            fi
        else
            log "代理已关闭, 将直接连接${parm1}..."
        fi
    fi
    napcat_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.Shell.zip"
    napcat_cli_download_url="${target_proxy:+${target_proxy}/}https://raw.githubusercontent.com/NapNeko/NapCat-Installer/refs/heads/main/script/napcat"
}

# 根据参数生成docker命令
function generate_docker_command() {
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

# 获取 QQ 号
function get_qq() {
    while true; do
        qq=$(whiptail --title "Napcat Installer" --inputbox "请输入您的 QQ 号:" 10 50 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            if [ -z "$qq" ]; then
                whiptail --title "错误" --msgbox "QQ 号不能为空，请重新输入。" 10 30
            else
                get_mode
                break
            fi
        else
            break
        fi
    done
}

# 获取选择模式
function get_mode() {
    while true; do
        mode=$(whiptail --title "选择模式" --menu "请选择运行模式:" 15 50 3 \
            "ws" "WebSocket 模式" \
            "reverse_ws" "反向 WebSocket 模式" \
            "reverse_http" "反向 HTTP 模式" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            if [ -z "$mode" ]; then
                whiptail --title "错误" --msgbox "模式选择不能为空，请重新选择。" 10 30
            else
                get_confirm
                break
            fi
        else
            break
        fi
    done
}

function get_confirm() {
    if (whiptail --title "确认" --yesno "您输入的 QQ 号是: $qq\n您选择的模式是: $mode\n\n是否继续下一步?" 15 50); then
        confirm="y"
        docker_install
    else
        return
    fi
}

# 使用docker安装
function docker_install() {
    log "当前系统架构: $system_arch"
    if ! command -v docker &> /dev/null; then
        execute_command "sudo apt-get update -y" "更新软件包列表"
        execute_command "sudo apt-get install -y -qq curl" "安装curl"
        execute_command "sudo curl -fsSL https://nclatest.znin.net/docker_install_script -o get-docker.sh" "下载docker安装脚本"
        sudo chmod +x get-docker.sh
        execute_command "sudo sh get-docker.sh" "安装docker"
    fi

    if command -v docker &> /dev/null; then
        log "Docker已安装"
    else
        log "Docker安装失败"
        exit 1
    fi

    while true; do
        if [[ -z $qq ]]; then
            log "请输入QQ号: "
            read -r qq
        fi
        if [[ -z $mode ]]; then
            log "请选择模式 (ws/reverse_ws/reverse_http) "
            read -r mode
        fi
        docker_command=$(generate_docker_command "$qq" "$mode")
        if [[ -z $docker_command ]]; then
            log "模式错误, 无法生成命令"
            confirm="n"
        else
            log "即将执行以下命令: $docker_command\n"
        fi
        if [[ -z $confirm ]]; then
            log "是否继续? (y/n) "
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
        log "Docker启动失败, 请检查错误。"
        exit 1
    fi
    log "安装成功"
    # exit 0
}

# 安装基础环境
function install_dependency() {
    log "当前系统架构: $system_arch"
    # 保证 curl/wget apt-get/rpm 基础环境
    log "正在更新依赖..."
    detect_package_manager
    # 开始安装基础依赖
    if [ "$package_manager" = "apt-get" ]; then
        execute_command "sudo apt-get update -y" "更新软件包列表"
        execute_command "sudo apt-get install -y -qq zip unzip jq curl xvfb screen xauth procps" "安装zip unzip jq curl xvfb screen xauth procps"
    elif [ "$package_manager" = "dnf" ]; then
        # 安装epel, 因为某些包在自带源里缺失
        execute_command "sudo dnf install -y epel-release" "安装epel"
        execute_command "sudo dnf install --allowerasing -y zip unzip jq curl xorg-x11-server-Xvfb screen procps-ng" "安装zip unzip jq curl xorg-x11-server-Xvfb screen procps-ng"
    else
        log "包管理器检查失败, 目前仅支持apt-get/dnf。"
        exit 1
    fi
}

# 获取QQ最新版本
function get_qq_target_version() {
    response=$( curl -s "https://nclatest.znin.net/get_qq_ver" )
    remoteQQVer=$( echo "$response" | jq -r '.linuxVersion' )
    remoteQQVerHash=$( echo "$response" | jq -r '.linuxVerHash' )
}

# 检测是否已安装LinuxQQ
function check_linuxqq(){
    package_name="linuxqq"
    get_qq_target_version
    package_targetVer=${remoteQQVer}
    package_targetVerHash=${remoteQQVerHash}
    if [[ -z "$package_targetVer" || "$package_targetVer" == "null" ]] || [[ -z "$package_targetVerHash" || "$package_targetVerHash" == "null" ]]; then
        log "无法获取远程QQ版本, 请检查错误。"
        exit 1
    fi
    target_build=${package_targetVer##*-}
    detect_package_installer

    log "最低linuxQQ版本: $package_targetVer, 构建: $target_build"
    if [ "$force" = "y" ]; then
        log "强制重装模式..."
        install_linuxqq
    else
        if [ "$package_installer" = "rpm" ]; then
            if rpm -q $package_name &> /dev/null; then
                version=$(rpm -q --queryformat '%{VERSION}' $package_name)
                installed_build=${version##*-}
                log "$package_name 已安装, 版本: $version, 构建: $installed_build"
                if (( installed_build < target_build )); then
                    log "版本过低, 需要更新。"
                    install_linuxqq
                else
                    log "版本已满足要求, 无需更新。"
                    update_linuxqq_config "$version" "$installed_build"
                fi
            else
                install_linuxqq
            fi
        elif [ "$package_installer" = "dpkg" ]; then
            if dpkg -l | grep $package_name &> /dev/null; then
                version=$(dpkg -l | grep "^ii" | grep "linuxqq" | awk '{print $3}')
                installed_build=${version##*-}
                log "$package_name 已安装, 版本: $version, 构建: $installed_build"
                if (( installed_build < target_build )); then
                    log "版本过低, 需要更新。"
                    install_linuxqq
                else
                    log "版本已满足要求, 无需更新。"
                    if [ "$use_tui" = "y" ]; then
                        reinstall=$(whiptail --title "Napcat Installer" --yesno "已安装最新版本, 是否重装。" 15 50 3>&1 1>&2 2>&3)
                        if [ $? -eq 0 ]; then
                            force="y"
                        else
                            force="n"
                            update_linuxqq_config "$version" "$installed_build"
                        fi
                    else
                        log "是否重装(y/n)"
                        read -r force
                        if [[ "$force" =~ ^[Yy]?$ ]]; then
                            force="y"
                        else
                            force="n"
                            update_linuxqq_config "$version" "$installed_build"
                        fi
                    fi
                fi
            else
                install_linuxqq
            fi
        fi
    fi
}

# 安装QQ
function install_linuxqq() {
    get_system_arch
    log "安装LinuxQQ..."
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
        log "无法下载QQ, 请检查错误。"
        exit 1
    fi
    log "QQ下载链接: $qq_download_url"

    # TODO: 优化QQ包依赖
    # 鉴于QQ似乎仍在变动linux包的依赖, 所以目前暂时安装所有QQ认为其自身所需的依赖以尽力保证脚本正常工作
    if [ "$package_manager" = "dnf" ]; then
        sudo curl -L "$qq_download_url" -o QQ.rpm
        if [ $? -ne 0 ]; then
            log "文件下载失败, 请检查错误。"
            exit 1
        else
            log "文件下载成功"
        fi
        execute_command "sudo dnf localinstall -y ./QQ.rpm" "安装QQ"
        rm -f QQ.rpm
    elif [ "$package_manager" = "apt-get" ]; then
        sudo curl -L "$qq_download_url" -o QQ.deb
        if [ $? -ne 0 ]; then
            log "文件下载失败, 请检查错误。"
            exit 1
        else
            log "文件下载成功"
        fi
        execute_command "sudo apt-get install -f -y ./QQ.deb" "安装QQ"
        # QQ自己声明的依赖不全...需要手动补全
        execute_command "sudo apt-get install -y libnss3" "安装libnss3"
        execute_command "sudo apt-get install -y libgbm1" "安装libgbm1"
        # Ubuntu24.04开始libasound2已不存在
        log "安装libasound2中..."
        sudo apt-get install -y libasound2
        if [ $? -eq 0 ]; then
            log "安装libasound2 成功"
        else
            log "安装libasound2 失败"
            log "尝试安装libasound2t64中..."
            sudo apt-get install -y libasound2t64
            wait $!
            if [ $? -eq 0 ]; then
                log "安装libasound2 成功"
            else
                log "安装libasound2t64 失败"
                exit 1
            fi
        fi
        sudo rm -f QQ.deb
    fi
    update_linuxqq_config "$package_targetVer" "$target_build"
}

# 更新用户QQ配置
function update_linuxqq_config() {
    log "正在更新用户QQ配置..."
    # 查找用户的QQ配置文件
    confs=$(sudo find /home -name "config.json" -path "*/.config/QQ/versions/*" 2>/dev/null)
    if [ -f /root/.config/QQ/versions/config.json ]; then
        confs="/root/.config/QQ/versions/config.json $confs"
    fi
    # 遍历配置文件并进行修改
    for conf in $confs; do
        log "正在修改 $conf..."
        sudo jq --arg targetVer "$1" --arg buildId "$2" \
        '.baseVersion = $targetVer | .curVersion = $targetVer | .buildId = $buildId' "$conf" > "$conf.tmp" && \
        sudo mv "$conf.tmp" "$conf" || { log "QQ配置更新失败! "; exit 1; }
    done
    log "更新用户QQ配置成功..."
}

# 修改QQ Package配置
function modify_qq_config() {
    log "正在修改QQ启动配置..."
    index_path="./loadNapCat.js"
    tmp_path="/tmp/package.json.tmp"
    package_path="/opt/QQ/resources/app/package.json"
    log "正在修改 $package_path..."
    sudo jq --arg jsPath "$index_path" \
    '.main = $jsPath' "$package_path" > "$tmp_path" && \
    sudo mv "$tmp_path" "$package_path" || { log "QQ Package配置更新失败! "; exit 1; }
    wait $!
    log "修改QQ启动配置成功..."
}

function check_napcat() {
    install_dependency
    check_linuxqq
    modify_qq_config
    napcat_version=$(curl -s "https://nclatest.znin.net" | jq -r '.tag_name')
    if [ -n "$napcat_version" ]; then
        if [[ "$napcat_version" == v* ]]; then
            log "最新NapCatQQ版本: $napcat_version"
        else
            log "获取NapCatQQ版本失败, 尝试使用GitHub官方api获取。"
            napcat_version=$(curl -s "https://api.github.com/repos/NapNeko/NapCatQQ/releases/latest" | jq -r '.tag_name')
            if [ -n "$napcat_version" ]; then
                if [[ "$napcat_version" == v* ]]; then
                    log "最新NapCatQQ版本: $napcat_version"
                else
                    log "无法获取NapCatQQ版本, 请检查错误。"
                    exit 1
                fi
            fi
        fi
    fi

    if [ "$force" = "y" ]; then
        log "强制重装模式..."
        install_napcat
    else
        if [ -d "$target_folder/napcat" ]; then
            current_version=$(jq -r '.version' "$target_folder/napcat/package.json")
            log "NapCatQQ已安装, 版本: v$current_version"
            target_version=${napcat_version#v}
            IFS='.' read -r i1 i2 i3 <<< "$current_version"
            IFS='.' read -r t1 t2 t3 <<< "$target_version"
            if (( i1 < t1 || (i1 == t1 && i2 < t2) || (i1 == t1 && i2 == t2 && i3 < t3) )); then
                install_napcat
            else
                log "已安装最新版本, 无需更新。"
            fi
        else
            install_napcat
        fi
    fi
}

# 函数: 安装NapCatQQ
function install_napcat() {
    log "安装NapCatQQ..."
    
    # 网络测试    
    network_test "Github"
    create_tmp_folder
    default_file="NapCat.Shell.zip"
    log "NapCatQQ下载链接: $napcat_download_url"
    sudo curl -L "$napcat_download_url" -o "$default_file"
    if [ $? -ne 0 ]; then
        log "文件下载失败, 请检查错误。"
        clean
        exit 1
    fi

    if [ -f "$default_file" ]; then
        log "$default_file 成功下载。"
    else
        ext_file=$(basename "$napcat_download_url")
        if [ -f "$ext_file" ]; then
            sudo mv "$ext_file" "$default_file"
            if [ $? -ne 0 ]; then
                log "$default_file 成功下载。"
            else
                log "文件更名失败, 请检查错误。"
                clean
                exit 1
            fi
        else
            log "文件下载失败, 请检查错误。"
            clean
            exit 1
        fi
    fi

    log "正在验证 $default_file..."
    sudo unzip -t "$default_file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log "文件验证失败, 请检查错误。"
        clean
        exit 1
    fi

    log "正在解压 $default_file..."
    sudo unzip -q -o -d ./napcattmp/NapCat.Shell NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        log "文件解压失败, 请检查错误。"
        clean
        exit 1
    fi
    
    if [ ! -d "$target_folder/napcat" ]; then
        sudo mkdir "$target_folder/napcat/"
    fi

    log "正在移动文件..."
    sudo cp -r -f ./napcattmp/NapCat.Shell/* "$target_folder/napcat/"
    if [ $? -ne 0 -a $? -ne 1 ]; then
        log "文件移动失败, 请以root身份运行。"
        clean
        exit 1
    else
        log "移动文件成功"
    fi

    sudo chmod -R 777 "$target_folder/napcat/"
    log "正在修补文件..."
    sudo echo "(async () => {await import('file:///$target_folder/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js
    if [ $? -ne 0 ]; then
        log "loadNapCat.js文件写入失败, 请以root身份运行。"
        clean
        exit 1
    else
        log "修补文件成功"
    fi

    clean

    if [ "$use_tui" = "y" ]; then
        install_cli=$(whiptail --title "Napcat Installer" --yesno "是否安装cli" 15 50 3>&1 1>&2 2>&3)
        if [ $? -eq 0 ]; then
            use_cli="y"
        else
            use_cli="n"
        fi
    fi
    if [ -z "$use_cli" ]; then
        log "是否安装cli(y/n)"
        read -r use_cli
        if [[ "$use_cli" =~ ^[Yy]?$ ]]; then
            use_cli="y"
        elif [[ "$use_cli" == "n" ]]; then
            use_cli="n"
        else
            use_cli="n"
        fi
    fi

    if [ "$use_cli" = "y" ]; then
        install_napcat_cli
    elif [ "$use_cli" = "n" ]; then
        log "跳过安装CLI。"
    else
        log "跳过安装CLI。"
    fi

    webui_config="${target_folder}/napcat/config/webui.json"
    if [ -f "$webui_config" ]; then
        log "webui配置文件已存在, 跳过"
    else
cat <<EOF > "$webui_config"
{
    "host": "0.0.0.0",
    "port": 6099,
    "prefix": "",
    "token": "napcat",
    "loginRate": 5
}
EOF
    fi
}

# 函数: 安装NapCatQQ CLI
function install_napcat_cli() {
    log "安装NapCatQQ CLI..."   
    network_test "Github"
    create_tmp_folder
    default_file="napcat"
    log "NapCatQQ CLI 下载链接: $napcat_cli_download_url"
    sudo curl -L "$napcat_cli_download_url" -o "./napcattmp/${default_file}"

    if [ $? -ne 0 ]; then
        log "文件下载失败, 请检查错误。"
        clean
        exit 1
    fi

    if [ -f "./napcattmp/${default_file}" ]; then
        log "$default_file 成功下载。"
    else
        ext_file=$(basename "$napcat_cli_download_url")
        if [ -f "$ext_file" ]; then
            mv "$ext_file" "./napcattmp/${default_file}"
            if [ $? -ne 0 ]; then
                log "$default_file 成功下载。"
            else
                log "文件更名失败, 请检查错误。"
                clean
                exit 1
            fi
        else
            log "文件下载失败, 请检查错误。"
            clean
            exit 1
        fi
    fi

    log "正在移动文件..."
    sudo cp -f ./napcattmp/napcat /usr/local/bin/napcat
    if [ $? -ne 0 -a $? -ne 1 ]; then
        log "文件移动失败, 请以root身份运行。"
        clean
        exit 1
    else
        log "移动文件成功"
    fi
    clean
    sudo chmod +x /usr/local/bin/napcat
}

function show_main_info() {
    ip=$(curl -4 ip.sb)
    web_token=$(sudo jq -r '.token' ${target_folder}/napcat/config/webui.json)
    log "\n安装完成。"
    log "WEB_UI访问密钥为 ${web_token} "
    log "WEB_UI访问链接格式为 http://$ip:6099/webui?token=${web_token} (若多开则端口按顺序+1)"
    log ""
    log "输入 xvfb-run -a qq --no-sandbox 命令启动。"
    log "保持后台运行 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox\" "
    log "后台快速登录 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\" "
    log "Napcat安装位置 $target_folder/napcat"
    log "注意, 您可以随时使用 screen -r napcat 来进入后台进程并使用 ctrl + a + d 离开(离开不会关闭后台进程)。"
    log "停止后台运行 请输入 screen -S napcat -X quit"
    if [ "$use_cli" = "y" ]; then
        show_cli_info
    fi
}

function show_cli_info() {
    log "\n新方法(未安装cli请忽略): "
    log "输入 napcat help  获取帮助。"
    log "后台快速登录 请输入 napcat start QQ账号 "
}

function shell_help() {
    help_content="命令选项(高级用法)
    您可以在 原安装命令 后面添加以下参数

    0. --tui: 使用tui可视化交互安装

    1. --docker [y/n]: --docker y 为使用docker安装反之为shell安装

    2. --qq \"123456789\": 传入docker安装时的QQ号

    3. --mode [ws|reverse_ws|reverse_http]: 传入docker安装时的运行模式

    4. --confirm: 传入docker安装时的是否确认执行安装

    5. --proxy [0|1|2|3|4|5|6]: 传入代理, 0为不使用代理, 1为使用内置的第一个,不支持自定义, docker安装可选0-7, shell安装可选0-5

    6. --cli [y/n]: shell安装时是否安装cli

    7. --force: 传入则执行shell强制重装

    使用示例: 
    0.  使用tui使用tui可视化交互安装:
        curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh --tui
    1.  运行docker安装并传入 qq\"123456789\" 模式ws 使用第一个代理 直接安装:
        curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh --docker y --qq \"123456789\" --mode ws --proxy 1 --confirm
    2.  运行shell安装并传入 不安装cli 不使用代理 强制重装:
        curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh --docker n --cli n --proxy 0 --force"
    echo "$help_content"
}

# tui函数
function main_tui() {
    OS=$(grep ^PRETTY_NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
    while true; do
        choice=$(
            whiptail --title "Napcat Installer" \
            --menu "\n当前系统为: ${OS}\n请使用方向键(鼠标滚轮)+回车键使用" 12 50 3 \
            "1" "🐚 shell安装" \
            "2" "🐋 docker安装" \
            "3" "🚪 退出" 3>&1 1>&2 2>&3
            )

        case $choice in
            "1")
                check_napcat
                whiptail --title "Napcat Installer" --msgbox "     安装完成" 8 24
                show_main_info
                ;;
            "2")
                get_qq
                whiptail --title "Napcat Installer" --msgbox "     安装完成" 8 24
                ;;
            "3")
                clean
                exit 0
                ;;
            *)  
                clean
                exit 0
                ;;
        esac
    done
}

root_check

while [[ $# -ge 1 ]]; do
    case $1 in
        --tui)
            shift
            use_tui="y"
            shift
            ;;
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
            shift
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
        --cli)
            shift
            use_cli="$1"
            shift
            ;;
        *)
            shell_help
            exit 1;
            ;;
    esac
done

if [ "$use_tui" = "y" ]; then
    main_tui
elif [ -z $use_docker ]; then
    log "是否使用shell安装(y/n)"
    read -r use_docker
    if [[ "$use_docker" =~ ^[Yy]?$ ]]; then
        use_docker="n"
    elif [[ "$use_docker" == "n" ]]; then
        use_docker="y"
    else
        log "输入错误"
        exit 1
    fi
fi

if [ "$use_docker" = "y" ]; then
    docker_install
    clean
    exit 0
elif [ "$use_docker" = "n" ]; then
    check_napcat
    clean
    show_main_info
    exit 0
fi


