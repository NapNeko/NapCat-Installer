#!/bin/bash

MAGENTA='\033[0;1;35;95m'
RED='\033[0;1;31;91m'
YELLOW='\033[0;1;33;93m'
GREEN='\033[0;1;32;92m'
CYAN='\033[0;1;36;96m'
BLUE='\033[0;1;34;94m'
NC='\033[0m'

TARGET_FOLDER="/opt/QQ/resources/app/app_launcher"

function logo() {
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
}

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

function execute_command() {
    log "${2}中..."
    ${1}
    if [ $? -eq 0 ]; then
        log "${2} (${1})成功"
    else
        log "${2} (${1})失败"
        exit 1
    fi
}

function check_sudo() {
    if ! command -v sudo &> /dev/null; then
        log "sudo不存在, 请手动安装: \n Centos: dnf install -y sudo\n Debian/Ubuntu: apt-get install -y sudo\n"
        exit 1
    fi
}

function check_root() {
    sudo_id_output=$(sudo whoami)
    if [[ ! ${sudo_id_output} == "root" ]]; then
        log "当前用户不是root用户, 请将此用户加入sudo group后再试。"
        exit 1
    fi
}

function get_system_arch() {
    system_arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)
    if [ "${system_arch}" = "none" ]; then
        log "无法识别的系统架构, 请检查错误。"
        exit 1
    fi
    log "当前系统架构: ${system_arch}"
}

function detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        package_manager="apt-get"
    elif command -v dnf &> /dev/null; then
        package_manager="dnf"
    else
        log "高级包管理器检查失败, 目前仅支持apt-get/dnf。"
        exit 1
    fi
    log "当前高级包管理器: ${package_manager}"
}

function detect_package_installer() {
    if command -v dpkg &> /dev/null; then
        package_installer="dpkg"
    elif command -v rpm &> /dev/null; then
        package_installer="rpm"
    else
        log "基础包管理器检查失败, 目前仅支持dpkg/rpm。"
        exit 1
    fi
    log "当前基础包管理器: ${package_installer}"
}

function network_test() {
    local parm1=${1}
    local found=0
    target_proxy=""
    proxy_num=${proxy_num:-9}

    if [ "${parm1}" == "Github" ]; then
        proxy_arr=("https://ghfast.top" "https://ghp.ci" "https://gh.wuliya.xin" "https://gh-proxy.com" "https://x.haod.me")
        check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    elif [ "${parm1}" == "Docker" ]; then
        proxy_arr=("docker.rainbond.cc" "docker.1panel.dev" "dockerpull.com" "dockerproxy.cn" "docker.agsvpt.work" "hub.021212.xyz:8080" "docker.registry.cyou")
        check_url=""
    fi

    if [ ! -z "${proxy_num}" ] && [ "${proxy_num}" -ge 1 ] && [ "${proxy_num}" -le ${#proxy_arr[@]} ]; then
        log "手动指定代理: ${proxy_arr[$proxy_num-1]}"
        target_proxy="${proxy_arr[$proxy_num-1]}"
    else
        if [ "${proxy_num}" -ne 0 ]; then
            log "proxy 未指定或超出范围, 正在检查${parm1}代理可用性..."
            for proxy in "${proxy_arr[@]}"; do
                status=$(curl -o /dev/null -s -w "%{http_code}" "${proxy}/${check_url}")
                if [ "${parm1}" == "Github" ] && [ ${status} -eq 200 ]; then
                    found=1
                    target_proxy="${proxy}"
                    log "将使用${parm1}代理: ${proxy}"
                    break
                elif [ "${parm1}" == "Docker" ] && ([ ${status} -eq 200 ] || [ ${status} -eq 301 ]); then
                    found=1
                    target_proxy="${proxy}"
                    log "将使用${parm1}代理: ${proxy}"
                    break
                fi
            done

            if [ ${found} -eq 0 ]; then
                log "无法连接到${parm1}, 请检查网络。"
                exit 1
            fi
        else
            log "代理已关闭, 将直接连接${parm1}..."
        fi
    fi
}

function install_dependency() {
    log "开始更新依赖..."
    detect_package_manager

    if [ "${package_manager}" = "apt-get" ]; then
        execute_command "sudo apt-get update -y -qq" "更新软件包列表"
        execute_command "sudo apt-get install -y -qq zip unzip jq curl xvfb screen xauth procps" "安装zip unzip jq curl xvfb screen xauth procps"
    elif [ "${package_manager}" = "dnf" ]; then
        execute_command "sudo dnf install -y epel-release" "安装epel"
        execute_command "sudo dnf install --allowerasing -y zip unzip jq curl xorg-x11-server-Xvfb screen procps-ng" "安装zip unzip jq curl xorg-x11-server-Xvfb screen procps-ng"
    fi
    log "更新依赖成功..."
}

function create_tmp_folder() {
    if [ -d "./NapCat" ] && [ "$(ls -A ./NapCat)" ]; then
        log "文件夹已存在且不为空(./NapCat)，请重命名后重新执行脚本以防误删"
        exit 1
    fi
    sudo mkdir -p ./NapCat
}

function clean() {
    sudo rm -rf ./NapCat
    if [ $? -ne 0 ]; then
        log "临时目录删除失败, 请手动删除 ./NapCat。"
    fi
    sudo rm -rf ./NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        log "NapCatQQ压缩包删除失败, 请手动删除 ${DEFAULT_FILE}。"
    fi
    if [ -f "/etc/init.d/napcat" ]; then
        sudo rm -f /etc/init.d/napcat
    fi
    if [ -d "${TARGET_FOLDER}/napcat.packet" ]; then
        sudo rm -rf  "${TARGET_FOLDER}/napcat.packet"
    fi
}

function download_napcat() {
    create_tmp_folder
    default_file="NapCat.Shell.zip"
    if [ -f "${default_file}" ]; then
        log "检测到已下载NapCat安装包,跳过下载..."
    else
        log "开始下载NapCat安装包,请稍等..."
        network_test "Github"
        napcat_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/latest/download/NapCat.Shell.zip"
        
        curl -L -# "${napcat_download_url}" -o "${default_file}"
        if [ $? -ne 0 ]; then
            log "文件下载失败, 请检查错误。或者手动下载压缩包并放在脚本同目录下"
            clean
            exit 1
        fi

        if [ -f "${default_file}" ]; then
            log "${default_file} 成功下载。"
        else
            ext_file=$(basename "${napcat_download_url}")
            if [ -f "${ext_file}" ]; then
                sudo mv "${ext_file}" "${default_file}"
                if [ $? -ne 0 ]; then
                    log "文件更名失败, 请检查错误。"
                    clean
                    exit 1
                else
                    log "${default_file} 成功重命名。"
                fi
            else
                log "文件下载失败, 请检查错误。或者手动下载压缩包并放在脚本同目录下"
                clean
                exit 1
            fi
        fi
    fi

    log "正在验证 ${default_file}..."
    sudo unzip -t "${default_file}" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log "文件验证失败, 请检查错误。"
        clean
        exit 1
    fi

    log "正在解压 ${default_file}..."
    sudo unzip -q -o -d ./NapCat NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        log "文件解压失败, 请检查错误。"
        clean
        exit 1
    fi
}

function get_qq_target_version() {
    #固定 3.2.16-34231
    linuxqq_target_version="3.2.16-34231"

    #linuxqq_target_version=$(jq -r '.linuxVersion' ./NapCat/qqnt.json)
    #linuxqq_target_verhash=$(jq -r '.linuxVerHash' ./NapCat/qqnt.json)
    
}

function compare_linuxqq_versions() {
    local ver1="${1}" #当前版本
    local ver2="${2}" #目标版本

    IFS='.-' read -r -a ver1_parts <<< "${ver1}"
    IFS='.-' read -r -a ver2_parts <<< "${ver2}"

    local length=${#ver1_parts[@]}
    if [ ${#ver2_parts[@]} -lt $length ]; then
        length=${#ver2_parts[@]}
    fi

    for ((i=0; i<length; i++)); do
        if ((ver1_parts[i] > ver2_parts[i])); then
            force="n"
            return
        elif ((ver1_parts[i] < ver2_parts[i])); then
            force="y"
            return
        fi
    done

    if [ ${#ver1_parts[@]} -gt ${#ver2_parts[@]} ]; then
        force="n"
    elif [ ${#ver1_parts[@]} -lt ${#ver2_parts[@]} ]; then
        force="y"
    else
        force="n"
    fi
}

function check_linuxqq(){
    get_qq_target_version
    linuxqq_package_name="linuxqq"
    if [[ -z "${linuxqq_target_version}" || "${linuxqq_target_version}" == "null" ]]; then
        log "无法获取目标QQ版本, 请检查错误。"
        exit 1
    fi

    linuxqq_target_build=${linuxqq_target_version##*-}
    detect_package_installer

    log "最低linuxQQ版本: ${linuxqq_target_version}, 构建: ${linuxqq_target_build}"
    if [ "${force}" = "y" ]; then
        log "强制重装模式..."
        install_linuxqq
    else
        if [ "${package_installer}" = "rpm" ]; then
            if rpm -q ${linuxqq_package_name} &> /dev/null; then
                linuxqq_installed_version=$(rpm -q --queryformat '%{VERSION}' ${linuxqq_package_name})
                linuxqq_installed_build=${linuxqq_installed_version##*-}
                log "${linuxqq_package_name} 已安装, 版本: ${linuxqq_installed_version}, 构建: ${linuxqq_installed_build}"

                compare_linuxqq_versions "${linuxqq_installed_version}" "${linuxqq_target_version}"
                if [ "${force}" = "y" ]; then
                    log "版本未满足要求, 需要更新。"
                    install_linuxqq
                else
                    log "版本已满足要求, 无需更新。"
                    if [ "${use_tui}" = "y" ]; then
                        reinstall=$(whiptail --title "Napcat Installer" --yesno "版本已满足要求, 是否重装。" 15 50 3>&1 1>&2 2>&3)
                        if [ $? -eq 0 ]; then
                            force="y"
                        else
                            force="n"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        fi
                    else
                        log "是否强制重装, 10s超时跳过重装(y/n)"
                        read -t 10 -r force
                        if [[ $? -ne 0 ]]; then
                            log "超时未输入, 跳过重装"
                            force="n"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        elif [[ "${force}" =~ ^[Yy]?$ ]]; then
                            force="y"
                            log "强制重装..."
                            install_linuxqq
                        elif [[ "${force}" == "n" ]]; then
                            force="n"
                            log "跳过重装"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        else
                            force="n"
                            log "输入错误, 跳过重装"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        fi
                    fi
                fi
            else
                install_linuxqq
            fi
        elif [ "${package_installer}" = "dpkg" ]; then
            if dpkg -l | grep ${linuxqq_package_name} &> /dev/null; then
                linuxqq_installed_version=$(dpkg -l | grep "^ii" | grep "linuxqq" | awk '{print $3}')
                linuxqq_installed_build=${linuxqq_installed_version##*-}
                log "${linuxqq_package_name} 已安装, 版本: ${linuxqq_installed_version}, 构建: ${linuxqq_installed_build}"

                compare_linuxqq_versions "${linuxqq_installed_version}" "${linuxqq_target_version}"
                if [ "${force}" = "y" ]; then
                    log "版本未满足要求, 需要更新。"
                    install_linuxqq
                else
                    log "版本已满足要求, 无需更新。"
                    if [ "${use_tui}" = "y" ]; then
                        reinstall=$(whiptail --title "Napcat Installer" --yesno "版本已满足要求, 是否重装。" 15 50 3>&1 1>&2 2>&3)
                        if [ $? -eq 0 ]; then
                            force="y"
                        else
                            force="n"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        fi
                    else
                        log "是否强制重装, 10s超时跳过重装(y/n)"
                        read -t 10 -r force
                        if [[ $? -ne 0 ]]; then
                            log "超时未输入, 跳过重装"
                            force="n"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        elif [[ "${force}" =~ ^[Yy]?$ ]]; then
                            force="y"
                            log "强制重装..."
                            install_linuxqq
                        elif [[ "${force}" == "n" ]]; then
                            force="n"
                            log "跳过重装"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        else
                            force="n"
                            log "输入错误, 跳过重装"
                            update_linuxqq_config "${linuxqq_installed_version}" "${linuxqq_installed_build}"
                        fi
                    fi
                fi
            else
                install_linuxqq
            fi
        fi
    fi
}

function install_linuxqq() {
    #base_url="https://dldir1.qq.com/qqfile/qq/QQNT/${linuxqq_target_verhash}/linuxqq_${linuxqq_target_version}"
    get_system_arch
    log "安装LinuxQQ..."
    # if [ "${system_arch}" = "amd64" ]; then
    #     if [ "${package_installer}" = "rpm" ]; then
    #         qq_download_url="${base_url}_x86_64.rpm"
    #     elif [ "${package_installer}" = "dpkg" ]; then
    #         qq_download_url="${base_url}_amd64.deb"
    #     fi
    # elif [ "${system_arch}" = "arm64" ]; then
    #     if [ "${package_installer}" = "rpm" ]; then
    #         qq_download_url="${base_url}_aarch64.rpm"
    #     elif [ "${package_installer}" = "dpkg" ]; then
    #         qq_download_url="${base_url}_arm64.deb"
    #     fi
    # fi

    if [ "${system_arch}" = "amd64" ]; then
        if [ "${package_installer}" = "rpm" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/d4ef758e/linuxqq_3.2.17-34231_x86_64.rpm"
        elif [ "${package_installer}" = "dpkg" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/d4ef758e/linuxqq_3.2.17-34231_amd64.deb"
        fi
    elif [ "${system_arch}" = "arm64" ]; then
        if [ "${package_installer}" = "rpm" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/d4ef758e/linuxqq_3.2.17-34231_arm64.deb"
        elif [ "${package_installer}" = "dpkg" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/d4ef758e/linuxqq_3.2.17-34231_aarch64.rpm"
        fi
    fi

    if ! [[ -f "QQ.deb" || -f "QQ.rpm" ]]; then
        if [ "${qq_download_url}" = "" ]; then
            log "获取QQ下载链接失败, 请检查错误, 或者手动下载QQ安装包并重命名为QQ.deb或QQ.rpm(注意自己的系统架构)放到脚本同目录下。"
            exit 1
        fi
        log "QQ下载链接: ${qq_download_url}"
        log "如果无法下载请手动下载QQ安装包并重命名为QQ.deb或QQ.rpm(注意自己的系统架构)放到脚本同目录下"
    fi

    if [ "${package_manager}" = "dnf" ]; then
        if ! [ -f "QQ.rpm" ]; then
            sudo curl -L -# "${qq_download_url}" -o QQ.rpm
            if [ $? -ne 0 ]; then
                log "文件下载失败, 请检查错误。"
                exit 1
            else
                log "文件下载成功"
            fi
        else
            log "检测到当前目录下存在QQ安装包, 将使用本地安装包进行安装。"
        fi

        execute_command "sudo dnf localinstall -y ./QQ.rpm" "安装QQ"
        rm -f QQ.rpm
    elif [ "${package_manager}" = "apt-get" ]; then
        if ! [ -f "QQ.deb" ]; then
            sudo curl -L -# "${qq_download_url}" -o QQ.deb
            if [ $? -ne 0 ]; then
                log "文件下载失败, 请检查错误。"
                exit 1
            else
                log "文件下载成功"
            fi
        else
            log "检测到当前目录下存在QQ安装包, 将使用本地安装包进行安装。"
        fi

        execute_command "sudo apt-get install -f -y -qq ./QQ.deb" "安装QQ"
        execute_command "sudo apt-get install -y -qq libnss3" "安装libnss3"
        execute_command "sudo apt-get install -y -qq libgbm1" "安装libgbm1"
        log "安装libasound2中..."
        sudo apt-get install -y -qq libasound2
        if [ $? -eq 0 ]; then
            log "安装libasound2 成功"
        else
            log "安装libasound2 失败"
            log "尝试安装libasound2t64中..."
            sudo apt-get install -y -qq libasound2t64
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
    update_linuxqq_config "${linuxqq_target_version}" "${linuxqq_target_build}"
}

function update_linuxqq_config() {
    log "正在更新用户QQ配置..."

    confs=$(sudo find /home -name "config.json" -path "*/.config/QQ/versions/*" 2>/dev/null)
    if [ -f "/root/.config/QQ/versions/config.json" ]; then
        confs="/root/.config/QQ/versions/config.json ${confs}"
    fi

    for conf in ${confs}; do
        log "正在修改 ${conf}..."
        sudo jq --arg targetVer "${1}" --arg buildId "${2}" \
        '.baseVersion = $targetVer | .curVersion = $targetVer | .buildId = $buildId' "${conf}" > "${conf}.tmp" && \
        sudo mv "${conf}.tmp" "${conf}" || { log "QQ配置更新失败! "; exit 1; }
    done
    log "更新用户QQ配置成功..."
}

function check_napcat() {
    napcat_target_version=$(jq -r '.version' "./NapCat/package.json")
    if [[ -z "${napcat_target_version}" || "${napcat_target_version}" == "null" ]]; then
        log "无法获取NapCatQQ版本, 请检查错误。"
        exit 1
    else
        log "最新NapCatQQ版本: v${napcat_target_version}"
    fi

    if [ "$force" = "y" ]; then
        log "强制重装模式..."
        install_napcat
    else
        if [ -d "${TARGET_FOLDER}/napcat" ]; then
            napcat_installed_version=$(jq -r '.version' "${TARGET_FOLDER}/napcat/package.json")
            IFS='.' read -r i1 i2 i3 <<< "${napcat_installed_version}"
            IFS='.' read -r t1 t2 t3 <<< "${napcat_target_version}"
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

function install_napcat() {
    if [ ! -d "${TARGET_FOLDER}/napcat" ]; then
        sudo mkdir -p "${TARGET_FOLDER}/napcat/"
    fi

    log "正在移动文件..."
    sudo cp -r -f ./NapCat/* "${TARGET_FOLDER}/napcat/"
    if [ $? -ne 0 -a $? -ne 1 ]; then
        log "文件移动失败, 请检查错误。"
        clean
        exit 1
    else
        log "移动文件成功"
    fi

    sudo chmod -R 777 "${TARGET_FOLDER}/napcat/"
    log "正在修补文件..."
    sudo echo "(async () => {await import('file:///${TARGET_FOLDER}/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js
    if [ $? -ne 0 ]; then
        log "loadNapCat.js文件写入失败, 请检查错误。"
        clean
        exit 1
    else
        log "修补文件成功"
    fi
    modify_qq_config
    clean
}

function modify_qq_config() {
    log "正在修改QQ启动配置..."

    if sudo jq '.main = "./loadNapCat.js"' /opt/QQ/resources/app/package.json > ./package.json.tmp; then
        sudo mv ./package.json.tmp /opt/QQ/resources/app/package.json
        echo "修改QQ启动配置成功..."
    else
        echo "修改QQ启动配置失败..."
        exit 1
    fi
}

function check_napcat_cli() {
    if [ "${use_tui}" = "y" ]; then
        install_cli=$(whiptail --title "Napcat Installer" --yesno "是否安装cli" 15 50 3>&1 1>&2 2>&3)
        if [ $? -eq 0 ]; then
            use_cli="y"
        else
            use_cli="n"
        fi
    elif [ -z ${use_cli} ]; then
        log "是否安装cli, 10s超时跳过安装(y/n)"
        read -t 10 -r use_cli
        if [[ $? -ne 0 ]]; then
            log "超时未输入, 跳过安装CLI"
            use_cli="n"
        elif [[ "${use_cli}" =~ ^[Yy]?$ ]]; then
            use_cli="y"
        elif [[ "${use_cli}" == "n" ]]; then
            log "跳过安装CLI"
            use_cli="n"
        else
            log "输入错误, 跳过安装CLI"
        fi
    fi

    if [ "${use_cli}" = "y" ]; then
        install_napcat_cli
    elif [ "${use_cli}" = "n" ]; then
        if [ -f "/usr/local/bin/napcat" ]; then
            log "检测到已安装CLI, 开始更新..." 
            install_napcat_cli
            log "CLI更新成功。"
            use_cli="y"
        else
            log "跳过安装CLI。"
        fi
    fi
}

function install_napcat_cli() {
    log "安装NapCatQQ CLI..."   
    network_test "Github"
    napcat_cli_download_url="${target_proxy:+${target_proxy}/}https://raw.githubusercontent.com/NapNeko/NapCat-Installer/refs/heads/main/script/napcat"
    default_file="napcatcli"
    log "NapCatQQ CLI 下载链接: ${napcat_cli_download_url}"
    sudo curl -L -# "${napcat_cli_download_url}" -o "./${default_file}"

    if [ $? -ne 0 ]; then
        log "文件下载失败, 请检查错误。"
        clean
        exit 1
    fi

    if [ -f "./${default_file}" ]; then
        log "${default_file} 成功下载。"
    else
        ext_file=$(basename "${napcat_cli_download_url}")
        if [ -f "${ext_file}" ]; then
            mv "${ext_file}" "./${default_file}"
            if [ $? -ne 0 ]; then
                log "文件更名失败, 请检查错误。"
                clean
                exit 1
            else
                log "${default_file} 成功重命名。"
            fi
        else
            log "文件下载失败, 请检查错误。"
            clean
            exit 1
        fi
    fi

    log "正在移动文件..."
    sudo cp -f ./${default_file} /usr/local/bin/napcat
    if [ $? -ne 0 -a $? -ne 1 ]; then
        log "文件移动失败, 请以root身份运行。"
        clean
        exit 1
    else
        log "移动文件成功"
    fi
    sudo chmod +x /usr/local/bin/napcat
    rm -rf ./${default_file}
}

function generate_docker_command() {
    network_test "Docker" > /dev/null 2>&1
    local qq=${1}
    local mode=${2}
    docker_cmd1="sudo docker run -d -e ACCOUNT=${qq}"
    docker_cmd2="--name napcat --restart=always ${target_proxy:+${target_proxy}/}mlikiowa/napcat-docker:latest"
    docker_ws="${docker_cmd1} -e WS_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -p 3001:3001 -p 6099:6099 ${docker_cmd2}"
    docker_reverse_ws="${docker_cmd1} -e WSR_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -e WS_URLS='[]' -p 6099:6099 ${docker_cmd2}"
    docker_reverse_http="${docker_cmd1} -e HTTP_ENABLE=true  -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -e HTTP_POST_ENABLE=true -e HTTP_URLS='[]' -p 3000:3000 -p 6099:6099 ${docker_cmd2}"
    if [ "${mode}" = "ws" ]; then
        echo "${docker_ws}"
    elif [ "${mode}" = "reverse_ws" ]; then
        echo "${docker_reverse_ws}"
    elif [ "${mode}" = "reverse_http" ]; then
        echo "${docker_reverse_http}"
    else
        exit 1
    fi
}

function get_qq() {
    while true; do
        qq=$(whiptail --title "Napcat Installer" --inputbox "请输入您的 QQ 号:" 10 50 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            if [ -z "${qq}" ]; then
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

function get_mode() {
    while true; do
        mode=$(whiptail --title "选择模式" --menu "请选择运行模式:" 15 50 3 \
            "ws" "WebSocket 模式" \
            "reverse_ws" "反向 WebSocket 模式" \
            "reverse_http" "反向 HTTP 模式" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            if [ -z "${mode}" ]; then
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
    if (whiptail --title "确认" --yesno "您输入的 QQ 号是: ${qq}\n您选择的模式是: ${mode}\n\n是否继续下一步?" 15 50); then
        confirm="y"
        docker_install
    else
        return
    fi
}

function docker_install() {
    if ! command -v docker &> /dev/null; then
        detect_package_manager
        if [ "${package_manager}" = "apt-get" ]; then
            execute_command "sudo apt-get update -y -qq" "更新软件包列表"
            execute_command "sudo apt-get install -y -qq curl" "安装 curl"
        elif [ "${package_manager}" = "dnf" ]; then
            execute_command "sudo dnf install -y epel-release" "安装epel"
            execute_command "sudo dnf install --allowerasing -y curl" "安装 curl"
        fi
        execute_command "sudo curl -fsSL https://get.docker.com -o get-docker.sh" "下载docker安装脚本"
        sudo chmod +x get-docker.sh
        execute_command "sudo sh get-docker.sh" "安装docker"
    else
        log "Docker已安装"
    fi

    while true; do
        if [[ -z ${qq} ]]; then
            log "请输入QQ号: "
            read -r qq
        fi
        if [[ -z ${mode} ]]; then
            log "请选择模式 (ws/reverse_ws/reverse_http) "
            read -r mode
        fi
        docker_command=$(generate_docker_command "${qq}" "${mode}")
        if [[ -z ${docker_command} ]]; then
            log "模式错误, 无法生成命令"
            confirm="n"
        else
            log "即将执行以下命令: ${docker_command}\n"
        fi
        if [[ -z ${confirm} ]]; then
            log "是否继续? (y/n) "
            read confirm
        fi
        case ${confirm} in
            y|Y ) break;;
            * )
                confirm=""
                mode=""
                qq=""
                ;;
        esac
    done
    eval "${docker_command}"
    if [ $? -ne 0 ]; then
        log "Docker启动失败, 请检查错误。"
        exit 1
    fi
    log "安装成功"
}

function show_main_info() {
    log "\n安装完成。"
    log ""
    log "输入 xvfb-run -a qq --no-sandbox 命令启动。"
    log "保持后台运行 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox\" "
    log "后台快速登录 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\" "
    log "Napcat安装位置 ${TARGET_FOLDER}/napcat"
    log "WEBUI_TOKEN 请自行查看${TARGET_FOLDER}/napcat/config/webui.json文件获取"
    log "注意, 您可以随时使用 screen -r napcat 来进入后台进程并使用 ctrl + a + d 离开(离开不会关闭后台进程)。"
    log "停止后台运行 请输入 screen -S napcat -X quit"
    if [ "${use_cli}" = "y" ]; then
        show_cli_info
    fi
}

function show_cli_info() {
    log "\n新方法(未安装cli请忽略): "
    log "输入 napcat help  获取帮助。"
    log "后台快速登录 请输入 napcat start QQ账号 "
    log "建议非root用户使用sudo执行命令以防止出现一些奇奇怪怪的bug, 例如 sudo napcat help"
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

    下载脚本 (依次尝试 ghfast.top、ghproxy.net 和 GitHub 直连):
        curl -fsSL -o napcat.sh https://ghfast.top/https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.sh || curl -fsSL -o napcat.sh https://ghproxy.net/https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.sh || curl -fsSL -o napcat.sh https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.sh

    使用示例:
    0.  使用tui使用tui可视化交互安装:
        sudo bash napcat.sh --tui
    1.  运行docker安装并传入 qq\"123456789\" 模式ws 使用第一个代理 直接安装:
        sudo bash napcat.sh --docker y --qq \"123456789\" --mode ws --proxy 1 --confirm
    2.  运行shell安装并传入 不安装cli 不使用代理 强制重装:
        sudo bash napcat.sh --docker n --cli n --proxy 0 --force"
    echo "${help_content}"
}

function chekc_whiptail() {
    if [[ "${TERM}" != "xterm" && "${TERM}" != "xterm-256color" ]]; then
        log "错误, 当前终端不支持 whiptail。请使用普通方式或使用支持 whiptail 的终端，例如 xterm 或 xterm-256color。查看当前终端类型请使用echo \$TERM"
        exit 1
    fi

    if ! command -v whiptail &> /dev/null; then
        log "未发现whiptail, 开始安装..."
        detect_package_manager

        if [ "${package_manager}" = "apt-get" ]; then
            execute_command "sudo apt-get update -y -qq" "更新软件包列表"
            execute_command "sudo apt-get install -y -qq whiptail" "安装whiptail"
        elif [ "${package_manager}" = "dnf" ]; then
            execute_command "sudo dnf install -y epel-release" "安装epel"
            execute_command "sudo dnf install --allowerasing -y whiptail" "安装whiptail"
        fi
    fi
}

function main_tui() {
    chekc_whiptail
    while true; do
        choice=$(
            whiptail --title "Napcat Installer" \
            --menu "\n欢迎使用Napcat安装脚本\n请使用方向键(鼠标滚轮)+回车键使用" 12 50 3 \
            "1" "🐚 shell安装" \
            "2" "🐋 docker安装" \
            "3" "🚪 退出" 3>&1 1>&2 2>&3
            )

        case $choice in
            "1")
                install_dependency
                download_napcat
                check_linuxqq
                check_napcat
                check_napcat_cli
                whiptail --title "Napcat Installer" --msgbox "     安装完成" 8 24
                show_main_info
                clean
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

clear
logo
check_sudo
check_root

if [ "${use_tui}" = "y" ]; then
    main_tui
elif [ -z ${use_docker} ]; then
    log "是否使用shell安装, 10s超时使用shell安装(y/n)"
    read -t 10 -r use_shell
    if [[ $? -ne 0 ]]; then
        log "超时未输入, 默认使用shell安装"
        use_docker="n"
    elif [[ "${use_shell}" =~ ^[Yy]?$ ]]; then
        use_docker="n"
    elif [[ "${use_shell}" == "n" ]]; then
        use_docker="y"
    else
        log "输入错误"
        exit 1
    fi
fi

if [ "${use_docker}" = "y" ]; then
    docker_install
    exit 0
elif [ "${use_docker}" = "n" ]; then
    install_dependency
    download_napcat
    check_linuxqq
    check_napcat
    check_napcat_cli
    show_main_info
    clean
    exit 0
fi
