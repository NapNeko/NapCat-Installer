#!/bin/bash

MAGENTA='\033[0;1;35;95m'
RED='\033[0;1;31;91m'
YELLOW='\033[0;1;33;93m'
GREEN='\033[0;1;32;92m'
CYAN='\033[0;1;36;96m'
BLUE='\033[0;1;34;94m'
NC='\033[0m'

#  Rootless Installation Paths 
# 主安装目录，位于用户主目录下
INSTALL_BASE_DIR="$HOME/Napcat"
# QQ 解压后的实际基础路径
QQ_BASE_PATH="$INSTALL_BASE_DIR/opt/QQ"
# NapCat 注入的目标文件夹
TARGET_FOLDER="$QQ_BASE_PATH/resources/app/app_launcher"
# QQ 可执行文件路径
QQ_EXECUTABLE="$QQ_BASE_PATH/qq"
# QQ package.json 路径
QQ_PACKAGE_JSON_PATH="$QQ_BASE_PATH/resources/app/package.json"

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
    *"失败"* | *"错误"* | *"sudo不存在"* | *"当前用户不是root用户"* | *"无法连接"*)
        echo -e "${RED}${message}${NC}"
        ;;
    *"成功"*)
        echo -e "${GREEN}${message}${NC}"
        ;;
    *"忽略"* | *"跳过"* | *"默认"* | *"警告"*)
        echo -e "${YELLOW}${message}${NC}"
        ;;
    *)
        echo -e "${BLUE}${message}${NC}"
        ;;
    esac
}

function print_introduction() {
    echo -e "${BLUE}下面是 NapCat 安装脚本的功能简介！${NC}😋"
    echo -e "${BLUE}--${NC}"
    echo -e "${BLUE}接下来，您可以选择安装方式:${NC}"
    echo -e "  1. ${GREEN}Docker 安装${NC}: ${BLUE}通过容器运行 (需要 root 或 docker 用户组权限)。${NC}"
    echo -e "  2. ${GREEN}本地安装 (Rootless)${NC}: ${BLUE}直接在本系统当前用户下安装，无需 root 权限。${NC}(${YELLOW}默认${NC})${NC}"
    echo -e "  	 - ${GREEN}可视化安装${NC}: ${BLUE}通过交互式界面来引导你安装。${NC}"
    echo -e "  	 - ${GREEN}Shell 安装${NC}: ${BLUE}直接在当前Shell会话执行安装。${NC}(${YELLOW}默认${NC})${NC}"
    echo ""
    echo -e "${BLUE}您可以选择安装的组件方式:${NC}"
    echo -e "  - ${CYAN}NapCat TUI-CLI${NC}: ${BLUE}允许你在 ssh、没有桌面、WebUI 难以使用的情况下可视化交互配置 Napcat${NC}"
    echo ""
    echo -e "${BLUE}使用 --help 来获取更多功能介绍${NC}"
    echo -e "${BLUE}--${NC}"
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
    if ! command -v sudo &>/dev/null; then
        log "sudo不存在, 请手动安装: \n Centos: dnf install -y sudo\n Debian/Ubuntu: apt-get install -y sudo\n"
        exit 1
    fi
}

function check_root() {
    # 检查是否为ID为0的用户
    if [[ $EUID -ne 0 ]]; then
        log "错误: 此操作需要以 root 权限运行。"
        log "请尝试使用 'sudo bash ${0}' 或切换到 root 用户后运行。"
        exit 1
    fi
    # 显示当前ROOT用户
    log "脚本正在以 root 权限运行。"
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
    if command -v apt-get &>/dev/null; then
        package_manager="apt-get"
        package_installer="dpkg" # 确定为 dpkg
    elif command -v dnf &>/dev/null; then
        package_manager="dnf"
        package_installer="rpm" # 确定为 rpm
        dnf_is_el_or_fedora
    else
        log "高级包管理器检查失败, 目前仅支持apt-get/dnf。"
        exit 1
    fi
    log "当前高级包管理器: ${package_manager}"
    log "当前基础包管理器: ${package_installer}"
}

function dnf_is_el_or_fedora() {
    if [ -f "/etc/fedora-release" ]; then
        dnf_host="fedora"
    else
        dnf_host="el"
    fi
}

function network_test() {
    local parm1=${1}
    local found=0
    local timeout=10 # 设置超时秒数
    local status=0
    target_proxy=""

    local current_proxy_setting="${proxy_num_arg:-9}"

    log "开始网络测试: ${parm1}..."
    # 观察实际使用的代理设置
    log "命令行传入代理参数 (proxy_num_arg): '${proxy_num_arg}', 本次测试生效设置: '${current_proxy_setting}'"

    if [ "${parm1}" == "Github" ]; then
        proxy_arr=("https://ghfast.top" "https://git.yylx.win/" "https://gh-proxy.com" "https://ghfile.geekertao.top" "https://gh-proxy.net" "https://j.1win.ggff.net" "https://ghm.078465.xyz" "https://gitproxy.127731.xyz" "https://jiashu.1win.eu.org" "https://github.tbedu.top")
        check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    elif [ "${parm1}" == "Docker" ]; then
        proxy_arr=("docker.1ms.run" "docker.xuanyuan.me" "docker.mybacc.com" "dytt.online" "lispy.org")
        check_url="" # 当前代码会测试代理服务器的根路径
    else
        log "错误: 未知的网络测试目标 '${parm1}', 默认测试 Github"
        parm1="Github" # 确保 parm1 被重置以便后续逻辑正确执行
        # 为 Github 重置 proxy_arr 和 check_url
        proxy_arr=("https://ghfast.top" "https://git.yylx.win/" "https://gh-proxy.com" "https://ghfile.geekertao.top" "https://gh-proxy.net" "https://j.1win.ggff.net" "https://ghm.078465.xyz" "https://gitproxy.127731.xyz" "https://jiashu.1win.eu.org" "https://github.tbedu.top")
        check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    fi

    # 后续逻辑中使用 current_proxy_setting
    # 1: 指定了有效的代理服务器序号 (1 到 N)
    if [[ "${current_proxy_setting}" -ge 1 && "${current_proxy_setting}" -le ${#proxy_arr[@]} ]]; then
        log "手动指定代理: ${proxy_arr[$((current_proxy_setting - 1))]}" # 数组索引从0开始
        target_proxy="${proxy_arr[$((current_proxy_setting - 1))]}"
    # 2: 指定了 0 (禁用代理), 或未指定 (默认为9, 自动测试), 或指定了无效序号
    else
        # current_proxy_setting 不是 0, 则表示需要自动测试代理 (例如为9) 或指定了无效序号
        if [ "${current_proxy_setting}" -ne 0 ]; then
            log "代理设置为自动测试或指定无效 ('${current_proxy_setting}'), 正在检查 ${parm1} 代理可用性..."

            # 仅当存在 check_url 或测试目标是 Docker (它会测试代理根路径)
            if [ -n "${check_url}" ] || [ "${parm1}" == "Docker" ]; then
                for proxy_candidate in "${proxy_arr[@]}"; do
                    local test_target_url
                    if [ -n "${check_url}" ]; then
                        test_target_url="${proxy_candidate}/${check_url}"
                    else                                      # Docker 且 check_url 为空的情况
                        test_target_url="${proxy_candidate}/" # 测试代理的根路径
                    fi

                    log "测试代理: ${proxy_candidate} (目标URL: ${test_target_url})"
                    # 从 curl 命令获取 HTTP 状态码和退出码
                    status_and_exit_code=$(curl -k -L --connect-timeout ${timeout} --max-time $((timeout * 2)) -o /dev/null -s -w "%{http_code}:%{exitcode}" "${test_target_url}")
                    status=$(echo "${status_and_exit_code}" | cut -d: -f1)
                    curl_exit_code=$(echo "${status_and_exit_code}" | cut -d: -f2)

                    if [ "${curl_exit_code}" -ne 0 ]; then
                        log "代理 ${proxy_candidate} 测试失败或超时 (curl 退出码: ${curl_exit_code})"
                        continue
                    fi

                    # HTTP 状态码
                    if ([ "${parm1}" == "Github" ] && [ "${status}" -eq 200 ]) ||
                        ([ "${parm1}" == "Docker" ] && ([ "${status}" -eq 200 ] || [ "${status}" -eq 301 ] || [ "${status}" -eq 302 ])); then # 302重定向
                        found=1
                        target_proxy="${proxy_candidate}"
                        log "将使用 ${parm1} 代理: ${target_proxy}"
                        break
                    else
                        log "代理 ${proxy_candidate} 返回 HTTP 状态 ${status}, 不适用。"
                    fi
                done
            else
                log "警告: ${parm1} 代理测试缺少有效的检查URL, 无法自动选择代理。"
                # target_proxy 保持为空
            fi

            if [ ${found} -eq 0 ]; then
                log "警告: 无法找到可用的 ${parm1} 代理。"
                if [ -n "${check_url}" ]; then # 仅当有检查URL时才尝试直连
                    log "将尝试直连 ${check_url}..."
                    status_and_exit_code=$(curl -k --connect-timeout ${timeout} --max-time $((timeout * 2)) -o /dev/null -s -w "%{http_code}:%{exitcode}" "${check_url}")
                    status=$(echo "${status_and_exit_code}" | cut -d: -f1)
                    curl_exit_code=$(echo "${status_and_exit_code}" | cut -d: -f2)

                    if [ "${curl_exit_code}" -eq 0 ] && [ "${status}" -eq 200 ]; then
                        log "直连 ${parm1} 成功，将不使用代理。"
                        target_proxy="" # 清空代理
                    else
                        log "警告: 无法直连到 ${parm1} (${check_url}) (HTTP状态: ${status}, curl退出码: ${curl_exit_code})，请检查网络。将继续尝试安装，但可能会失败。"
                        target_proxy="" # 清空代理
                    fi
                else
                    log "无检查URL, 无法尝试直连。不使用代理。"
                    target_proxy="" # 清空代理
                fi
            fi
        else
            # 此 else 块对应 current_proxy_setting 为 0 (通过参数明确禁用代理)
            log "代理已通过参数关闭 (序号 0), 将直接连接 ${parm1}..."
            target_proxy="" # 确保没有设置代理
            if [ -n "${check_url}" ]; then
                status_and_exit_code=$(curl -k --connect-timeout ${timeout} --max-time $((timeout * 2)) -o /dev/null -s -w "%{http_code}:%{exitcode}" "${check_url}")
                status=$(echo "${status_and_exit_code}" | cut -d: -f1)
                curl_exit_code=$(echo "${status_and_exit_code}" | cut -d: -f2)
                if [ "${curl_exit_code}" -eq 0 ] && [ "${status}" -eq 200 ]; then
                    log "直连 ${parm1} (${check_url}) 测试成功。"
                else
                    log "警告: 直连 ${parm1} (${check_url}) 测试失败 (HTTP状态: ${status}, curl退出码: ${curl_exit_code}) 或网络不通。"
                fi
            else
                log "无检查URL (${parm1}), 代理关闭状态下不执行网络测试。"
            fi
        fi
    fi
}
function install_el_repo() {
    # 检查是否为 OpenCloudOS 9+
    if [ -f "/etc/opencloudos-release" ]; then
        # 提取主版本号
        os_version=$(grep -oE '[0-9]+' /etc/opencloudos-release | head -n 1)
        if [[ -n "$os_version" && "$os_version" -ge 9 ]]; then
            log "检测到 OpenCloudOS 9+, 安装 epol-release..."
            execute_command "sudo dnf install -y epol-release" "安装epol"
        else
            # 低于 9 或无法确定版本，回退到 epel
            log "OpenCloudOS 版本低于 9 或无法确定版本, 安装 epel-release..."
            execute_command "sudo dnf install -y epel-release" "安装epel"
        fi
    else
        # 其他 EL 系统，安装 epel
        log "非 OpenCloudOS 的 EL 系统, 安装 epel-release..."
        execute_command "sudo dnf install -y epel-release" "安装epel"
    fi
}

function enable_dnf_repos_and_cache() {
    log "检查并配置 dnf 仓库..."
    # 确保 config-manager 工具可用
    if ! rpm -q dnf-plugins-core >/dev/null 2>&1; then
        execute_command "sudo dnf install -y dnf-plugins-core" "安装 dnf-plugins-core"
    fi

    # 检查 appstream 仓库是否存在且被禁用
    if dnf repolist all | grep -q '^appstream\s'; then
        if dnf repolist disabled | grep -q '^appstream\s'; then
            execute_command "sudo dnf config-manager --set-enabled appstream" "启用 AppStream 仓库"
        else
            log "AppStream 仓库已启用。"
        fi
    else
        log "警告: 未检测到 appstream 仓库，依赖安装可能不完整。"
    fi

    # 刷新缓存以确保更改生效
    execute_command "sudo dnf makecache --refresh" "刷新 dnf 缓存"
}


function install_dependency() {
    log "开始安装系统依赖 (此步骤需要 sudo 权限)..."
    detect_package_manager

    if [ "${package_manager}" = "apt-get" ]; then
        log "更新软件包列表中..."
        if ! sudo apt-get update -y -qq; then
            log "更新软件包列表失败, 是否继续安装(如果您是全新的系统请选择N)"
            read -p "是否继续? (Y/n): " continue_install
            case "${continue_install}" in
            [nN] | [nN][oO])
                log "用户选择停止安装。"
                exit 1
                ;;
            *)
                log "警告: 跳过软件源更新, 继续安装..."
                ;;
            esac
        else
            log "更新软件包列表成功"
        fi

        # 静态依赖包列表
        local static_pkgs="zip unzip jq curl xvfb screen xauth procps rpm2cpio cpio libnss3 libgbm1"
        
        # 需要检查是否存在 t64 版本的动态依赖包列表
        local pkgs_to_check=(
            "libglib2.0-0"
            "libatk1.0-0"
            "libatspi2.0-0"
            "libgtk-3-0"
            "libasound2"
        )
        
        local resolved_pkgs=()
        log "正在检测系统库版本 (t64)..."
        for pkg_base in "${pkgs_to_check[@]}"; do
            local t64_variant="${pkg_base}t64"
            # 使用 apt-cache show 检查 t64 版本的包是否存在
            if apt-cache show "${t64_variant}" >/dev/null 2>&1; then
                log "检测到 ${t64_variant}，将使用此版本。"
                resolved_pkgs+=("${t64_variant}")
            else
                log "未检测到 ${t64_variant}，将使用标准版本 ${pkg_base}。"
                resolved_pkgs+=("${pkg_base}")
            fi
        done

        # 将所有需要安装的包合并到一个命令中执行
        local all_pkgs_to_install="${static_pkgs} ${resolved_pkgs[*]}"
        execute_command "sudo apt-get install -y -qq ${all_pkgs_to_install}" "安装依赖"

    elif [ "${package_manager}" = "dnf" ]; then
        if [ "${dnf_host}" = "el" ]; then
            install_el_repo
        fi
        enable_dnf_repos_and_cache
        #  Added cpio for extracting .rpm 
        base_pkgs="zip unzip jq curl screen procps-ng cpio nss mesa-libgbm atk at-spi2-atk gtk3 alsa-lib pango cairo libdrm libXcursor libXrandr libXdamage libXcomposite libXfixes libXrender libXi libXtst libXScrnSaver cups-libs libxkbcommon"
        x_extra="libX11-xcb"
        mesa_extra="mesa-dri-drivers mesa-libEGL mesa-libGL"
        xcb_utils="xcb-util xcb-util-image xcb-util-wm xcb-util-keysyms xcb-util-renderutil"
        fonts="fontconfig dejavu-sans-fonts"
        xvfb_pkg="xorg-x11-server-Xvfb"
        all_pkgs="${base_pkgs} ${x_extra} ${mesa_extra} ${xcb_utils} ${fonts} ${xvfb_pkg}"

        execute_command "sudo dnf install --allowerasing -y ${all_pkgs}" "安装依赖"
    fi
    log "更新依赖成功..."
}

function create_tmp_folder() {
    if [ -d "./NapCat" ] && [ "$(ls -A ./NapCat)" ]; then
        log "文件夹已存在且不为空(./NapCat)，请重命名后重新执行脚本以防误删"
        exit 1
    fi
    #  Removed sudo 
    mkdir -p ./NapCat
}

function clean() {
    #  Removed sudo 
    rm -rf ./NapCat
    if [ $? -ne 0 ]; then
        log "临时目录删除失败, 请手动删除 ./NapCat。"
    fi
    rm -rf ./NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        log "NapCatQQ压缩包删除失败, 请手动删除 NapCat.Shell.zip。"
    fi
    #  Clean up downloaded QQ package 
    rm -f ./QQ.deb ./QQ.rpm
    if [ -d "${TARGET_FOLDER}/napcat.packet" ]; then
        rm -rf "${TARGET_FOLDER}/napcat.packet"
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

        #  Removed sudo from curl and mv 
        curl -k -L -# "${napcat_download_url}" -o "${default_file}"
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
                mv "${ext_file}" "${default_file}"
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
    #  Removed sudo 
    unzip -t "${default_file}" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        log "文件验证失败, 请检查错误。"
        clean
        exit 1
    fi

    log "正在解压 ${default_file}..."
    #  Removed sudo 
    unzip -q -o -d ./NapCat NapCat.Shell.zip
    if [ $? -ne 0 ]; then
        log "文件解压失败, 请检查错误。"
        clean
        exit 1
    fi
}

function get_qq_target_version() {
    #固定 3.2.19-39038
    linuxqq_target_version="3.2.19-39038"
}

function compare_linuxqq_versions() {
    local ver1="${1}" #当前版本
    local ver2="${2}" #目标版本

    IFS='.-' read -r -a ver1_parts <<<"${ver1}"
    IFS='.-' read -r -a ver2_parts <<<"${ver2}"

    local length=${#ver1_parts[@]}
    if [ ${#ver2_parts[@]} -lt $length ]; then
        length=${#ver2_parts[@]}
    fi

    for ((i = 0; i < length; i++)); do
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

#  REWRITTEN: check_linuxqq for rootless 
function check_linuxqq() {
    get_qq_target_version
    # 使用 rootless 路径
    local napcat_config_path="${TARGET_FOLDER}/napcat/config"
    local backup_path="/tmp/napcat_config_backup_$(date +%s)"

    if [[ -z "${linuxqq_target_version}" || "${linuxqq_target_version}" == "null" ]]; then
        log "无法获取目标QQ版本, 请检查错误。"
        exit 1
    fi

    log "目标LinuxQQ版本: ${linuxqq_target_version}"

    local qq_installed=false
    # 核心检测逻辑：检查 package.json 文件是否存在
    if [ -f "${QQ_PACKAGE_JSON_PATH}" ]; then
        qq_installed=true
        linuxqq_installed_version=$(jq -r '.version' "${QQ_PACKAGE_JSON_PATH}")
        log "检测到已安装的QQ, 版本: ${linuxqq_installed_version}"
        compare_linuxqq_versions "${linuxqq_installed_version}" "${linuxqq_target_version}"
    else
        log "未在 ${INSTALL_BASE_DIR} 检测到已安装的QQ。"
        force="y" # 未安装，强制执行安装
    fi

    if [ "${force}" = "y" ]; then
        log "将执行全新安装或强制重装..."
        local backup_created=false

        # 如果QQ已安装且存在Napcat配置，则备份
        if [ "${qq_installed}" = true ] && [ -d "${napcat_config_path}" ]; then
            log "检测到现有 Napcat 配置 (${napcat_config_path}), 准备备份..."
            if mkdir -p "${backup_path}"; then
                log "创建备份目录: ${backup_path}"
                if cp -a "${napcat_config_path}/." "${backup_path}/"; then
                    log "Napcat 配置备份成功到 ${backup_path}"
                    backup_created=true
                else
                    log "警告: Napcat 配置备份失败。"
                fi
            else
                log "严重警告: 无法创建备份目录 ${backup_path}。"
            fi
        fi

        # “卸载”操作现在只是简单地删除旧的安装目录
        if [ -d "${INSTALL_BASE_DIR}" ]; then
            log "正在移除旧的安装目录: ${INSTALL_BASE_DIR}"
            rm -rf "${INSTALL_BASE_DIR}"
        fi

        # 执行新的 rootless 安装函数
        install_linuxqq_rootless

        # 如果创建了备份，则恢复
        if [ "${backup_created}" = true ]; then
            log "准备恢复 Napcat 配置从 ${backup_path}..."
            if ! mkdir -p "${napcat_config_path}"; then
                log "严重警告: 无法创建目标配置目录 (${napcat_config_path}) 进行恢复。"
            else
                if cp -a "${backup_path}/." "${napcat_config_path}/"; then
                    log "Napcat 配置恢复成功到 ${napcat_config_path}"
                else
                    log "警告: Napcat 配置恢复失败。"
                fi
            fi
            log "清理备份目录 ${backup_path}..."
            rm -rf "${backup_path}"
        fi
    else
        log "版本已满足要求, 无需更新。"
        update_linuxqq_config "${linuxqq_installed_version}"
    fi
}

#  REWRITTEN: install_linuxqq_rootless for rootless 
function install_linuxqq_rootless() {
    get_system_arch
    log "开始以用户模式安装 LinuxQQ 到 ${INSTALL_BASE_DIR}..."

    local qq_download_url=""
    local qq_package_file=""

    if [ "${system_arch}" = "amd64" ]; then
        if [ "${package_installer}" = "rpm" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/c773cdf7/linuxqq_3.2.19-39038_x86_64.rpm"
            qq_package_file="QQ.rpm"
        elif [ "${package_installer}" = "dpkg" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/c773cdf7/linuxqq_3.2.19-39038_amd64.deb"
            qq_package_file="QQ.deb"
        fi
    elif [ "${system_arch}" = "arm64" ]; then
        if [ "${package_installer}" = "rpm" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/c773cdf7/linuxqq_3.2.19-39038_aarch64.rpm"
            qq_package_file="QQ.rpm"
        elif [ "${package_installer}" = "dpkg" ]; then
            qq_download_url="https://dldir1.qq.com/qqfile/qq/QQNT/c773cdf7/linuxqq_3.2.19-39038_arm64.deb"
            qq_package_file="QQ.deb"
        fi
    fi

    if [ -z "${qq_download_url}" ]; then
        log "获取QQ下载链接失败, 架构不支持。"
        exit 1
    fi

    if ! [ -f "${qq_package_file}" ]; then
        log "QQ下载链接: ${qq_download_url}"
        curl -k -L -# "${qq_download_url}" -o "${qq_package_file}"
        if [ $? -ne 0 ]; then
            log "文件下载失败, 请检查错误。"
            exit 1
        fi
    else
        log "检测到当前目录下存在QQ安装包, 将使用本地安装包进行安装。"
    fi

    log "正在创建安装目录: ${INSTALL_BASE_DIR}"
    mkdir -p "${INSTALL_BASE_DIR}"

    log "正在解压QQ文件..."
    if [ "${package_installer}" = "dpkg" ]; then
        execute_command "dpkg -x ./${qq_package_file} ${INSTALL_BASE_DIR}" "解压QQ (.deb)"
    elif [ "${package_installer}" = "rpm" ]; then
        # 切换到目标目录再执行解压，以确保文件路径正确
        rpm2cpio "${PWD}/${qq_package_file}" | (cd "${INSTALL_BASE_DIR}" && cpio -idmv)
        if [ $? -eq 0 ]; then
            log "解压QQ (.rpm)成功"
        else
            log "解压QQ (.rpm)失败"
            exit 1
        fi
    fi

    # 清理下载的安装包
    rm -f "${qq_package_file}"
    update_linuxqq_config "${linuxqq_target_version}"
}

#  REWRITTEN: update_linuxqq_config for rootless 
function update_linuxqq_config() {
    log "正在更新用户QQ配置..."
    local target_ver="${1}"
    local build_id="${target_ver##*-}"
    # 直接定位到当前用户的配置文件
    local user_config_dir="$HOME/.config/QQ/versions"
    local user_config_file="${user_config_dir}/config.json"

    if [ -d "${user_config_dir}" ]; then
        if [ -f "${user_config_file}" ]; then
            log "正在修改 ${user_config_file}..."
            # 无需 sudo，直接操作用户文件
            jq --arg targetVer "${target_ver}" --arg buildId "${build_id}" \
                '.baseVersion = $targetVer | .curVersion = $targetVer | .buildId = $buildId' "${user_config_file}" >"${user_config_file}.tmp" &&
                mv "${user_config_file}.tmp" "${user_config_file}" || {
                log "QQ配置更新失败!"
            }
        else
            log "未找到用户配置文件 ${user_config_file}, QQ首次启动时会自动创建。"
        fi
    else
        log "未找到用户配置目录 ${user_config_dir}, QQ首次启动时会自动创建。"
    fi
    log "更新用户QQ配置完成。"
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
            IFS='.' read -r i1 i2 i3 <<<"${napcat_installed_version}"
            IFS='.' read -r t1 t2 t3 <<<"${napcat_target_version}"
            if ((i1 < t1 || (i1 == t1 && i2 < t2) || (i1 == t1 && i2 == t2 && i3 < t3))); then
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
    #  Removed sudo, updated paths 
    if [ ! -d "${TARGET_FOLDER}/napcat" ]; then
        mkdir -p "${TARGET_FOLDER}/napcat/"
    fi

    log "正在移动文件..."
    cp -r -f ./NapCat/* "${TARGET_FOLDER}/napcat/"
    if [ $? -ne 0 -a $? -ne 1 ]; then
        log "文件移动失败, 请检查错误。"
        clean
        exit 1
    else
        log "移动文件成功"
    fi

    chmod -R +x "${TARGET_FOLDER}/napcat/"
    log "正在修补文件..."
    echo "(async () => {await import('file:///${TARGET_FOLDER}/napcat/napcat.mjs');})();" > "${QQ_BASE_PATH}/resources/app/loadNapCat.js"
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
    #  Removed sudo, updated paths 
    if jq '.main = "./loadNapCat.js"' "${QQ_PACKAGE_JSON_PATH}" >./package.json.tmp; then
        mv ./package.json.tmp "${QQ_PACKAGE_JSON_PATH}"
        log "修改QQ启动配置成功..."
    else
        log "修改QQ启动配置失败..."
        exit 1
    fi
}

# 当use_cli为y时, 检测是否安装过napcat-cli。
function check_napcat_cli() {
    if [ "${use_cli}" = "y" ]; then
        if [ -f "/usr/local/bin/napcat" ]; then
            log "检测到已安装的 TUI-CLI, 开始更新..."
            install_napcat_cli
            log "TUI-CLI 更新成功。"
        else
            log "开始安装 TUI-CLI..."
            install_napcat_cli
            log "TUI-CLI 安装成功。"
        fi
    else
        log "跳过安装/更新 TUI-CLI (用户未选择或使用 --cli n)。"
    fi
}

# TUI-CLI 安装到 /usr/local/bin，保留 sudo 是合理的
function install_napcat_cli() {
    local cli_script_url_base="https://raw.githubusercontent.com/NapNeko/NapCat-TUI-CLI/main/script"
    local cli_script_name="install-cli.sh"
    local cli_script_local_path="./${cli_script_name}.download" # Download to a temporary name
    local cli_script_url="${target_proxy:+${target_proxy}/}${cli_script_url_base}/${cli_script_name}"
    local exit_status=1 # Default to failure

    if [ -z "${target_proxy+x}" ]; then
        log "运行 TUI-CLI 安装的网络测试..."
        network_test "Github"
    fi

    log "下载外部 TUI-CLI 安装脚本从 ${cli_script_url}..."
    # 使用 sudo 下载到当前目录，因为后续执行也需要 sudo
    sudo curl -k -L -# "${cli_script_url}" -o "${cli_script_local_path}"

    if [ $? -ne 0 ]; then
        log "错误: TUI-CLI 安装脚本 ${cli_script_name} 下载失败。"
        sudo rm -f "${cli_script_local_path}"
        return 1
    fi

    log "设置 TUI-CLI 安装脚本权限..."
    sudo chmod +x "${cli_script_local_path}"
    if [ $? -ne 0 ]; then
        log "错误: 设置 TUI-CLI 安装脚本 (${cli_script_local_path}) 执行权限失败。"
        sudo rm -f "${cli_script_local_path}"
        return 1
    fi

    log "执行外部 TUI-CLI 安装脚本 (${cli_script_local_path})..."
    sudo "${cli_script_local_path}" "${proxy_num_arg:-9}"

    exit_status=$?
    if [ ${exit_status} -ne 0 ]; then
        log "外部 TUI-CLI 安装脚本执行失败 (退出码: ${exit_status})。"
    else
        log "外部 TUI-CLI 安装脚本执行成功。"
    fi

    log "清理 TUI-CLI 安装脚本 (${cli_script_local_path})..."
    sudo rm -f "${cli_script_local_path}"

    return ${exit_status}
}

function generate_docker_command() {
    local qq=${1}
    local mode=${2}

    if [[ "${mode}" != "ws" && "${mode}" != "reverse_ws" && "${mode}" != "reverse_http" ]]; then
        log "错误: 无效的运行模式 '${mode}', 请选择 ws, reverse_ws 或 reverse_http"
        return 1
    fi

    docker_cmd1="sudo docker run -d -e ACCOUNT=${qq}"
    docker_cmd2="--name napcat --restart=always ${target_proxy:+${target_proxy}/}mlikiowa/napcat-docker:latest"
    docker_ws="${docker_cmd1} -e WS_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -p 3001:3001 -p 6099:6099 ${docker_cmd2}"
    docker_reverse_ws="${docker_cmd1} -e WSR_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -p 6099:6099 ${docker_cmd2}"
    docker_reverse_http="${docker_cmd1} -e HTTP_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -p 3000:3000 -p 6099:6099 ${docker_cmd2}"

    if [ "${mode}" = "ws" ]; then
        echo "${docker_ws}"
        return 0
    elif [ "${mode}" = "reverse_ws" ]; then
        echo "${docker_reverse_ws}"
        return 0
    elif [ "${mode}" = "reverse_http" ]; then
        echo "${docker_reverse_http}"
        return 0
    else
        return 1
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
    if ! command -v docker &>/dev/null; then
        detect_package_manager
        if [ "${package_manager}" = "apt-get" ]; then
            execute_command "sudo apt-get update -y -qq" "更新软件包列表"
            execute_command "sudo apt-get install -y -qq curl" "安装 curl"
        elif [ "${package_manager}" = "dnf" ]; then
            if [ "${dnf_host}" = "el" ]; then
                execute_command "sudo dnf install -y epel-release" "安装epel"
            fi
            execute_command "sudo dnf install --allowerasing -y curl" "安装 curl"
        fi
        execute_command "sudo curl -k -fsSL https://get.docker.com -o get-docker.sh" "下载docker安装脚本"
        sudo chmod +x get-docker.sh
        execute_command "sudo sh get-docker.sh" "安装docker"
    else
        log "Docker已安装"
    fi

    while true; do
        if [[ -z ${qq} ]]; then
            log "请输入QQ号: "
            read -r qq
            if [[ -z ${qq} ]]; then
                log "QQ号不能为空，请重新输入。"
                continue
            fi
        fi

        if [[ -z ${mode} ]]; then
            log "请选择模式 (ws/reverse_ws/reverse_http): "
            read -r mode
            if [[ "${mode}" != "ws" && "${mode}" != "reverse_ws" && "${mode}" != "reverse_http" ]]; then
                log "错误: 无效的运行模式 '${mode}', 请选择 ws, reverse_ws 或 reverse_http"
                mode=""
                continue
            fi
        fi

        log "生成Docker命令..."
        network_test "Docker"
        docker_command=$(generate_docker_command "${qq}" "${mode}")
        cmd_status=$?

        if [[ $cmd_status -ne 0 || -z ${docker_command} ]]; then
            log "模式错误或命令生成失败, 无法生成命令"
            mode=""
            confirm="n"
            continue
        else
            log "即将执行以下命令: "
            log "${docker_command}"
        fi

        if [[ -z ${confirm} ]]; then
            log "是否继续? (y/n) "
            read -r confirm
        fi

        case ${confirm} in
        y | Y) break ;;
        *)
            confirm=""
            mode=""
            qq=""
            ;;
        esac
    done

    log "执行Docker命令..."
    eval "${docker_command}"
    if [ $? -ne 0 ]; then
        log "Docker启动失败, 请检查错误。"
        exit 1
    fi
    log "安装成功"
}

#  REWRITTEN: show_main_info for rootless 
function show_main_info() {
    log "\n- Shell (Rootless) 安装完成 -"
    log ""
    log "${GREEN}安装位置:${NC}"
    log "  ${CYAN}${INSTALL_BASE_DIR}${NC}"
    log ""
    log "${GREEN}启动 Napcat (无需 sudo):${NC}"
    log "  ${CYAN}xvfb-run -a ${QQ_EXECUTABLE} --no-sandbox ${NC}"
    log ""
    log "${GREEN}后台运行 Napcat (使用 screen, 无需 sudo):${NC}"
    log "  启动: ${CYAN}screen -dmS napcat bash -c \"xvfb-run -a ${QQ_EXECUTABLE} --no-sandbox \"${NC}"
    log "  带账号启动: ${CYAN}screen -dmS napcat bash -c \"xvfb-run -a ${QQ_EXECUTABLE} --no-sandbox  -q QQ号码\"${NC}"
    log "  附加到会话: ${CYAN}screen -r napcat${NC} (按 Ctrl+A 然后按 D 分离)"
    log "  停止会话: ${CYAN}screen -S napcat -X quit${NC}"
    log ""
    log "${GREEN}Napcat 相关信息:${NC}"
    log "  插件位置: ${TARGET_FOLDER}/napcat"
    log "  WebUI Token: 查看 ${TARGET_FOLDER}/napcat/config/webui.json 文件获取"
    log ""
    if [ "${use_cli}" = "y" ]; then
        show_cli_info
    else
        log "${YELLOW}未安装 TUI-CLI 工具。如需使用便捷命令管理, 请重新运行安装脚本并选择安装 TUI-CLI (--cli y)。${NC}"
    fi
    log "--"
}

function show_cli_info() {
    log "${GREEN}TUI-CLI 工具用法 (napcat):${NC}"
    # CLI 工具安装在系统路径，可能需要 sudo
    log "  启动: ${CYAN}napcat${NC}"
}

function shell_help() {
    echo -e "${YELLOW}命令选项 (高级用法):${NC}"
    echo "您可以在 原安装命令 后面添加以下参数:"
    echo ""
    echo -e "  ${CYAN}--tui${NC}                     使用 TUI 可视化交互安装"
    echo -e "  ${CYAN}--docker${NC} [${GREEN}y${NC}/${RED}n${NC}]            选择安装方式 (${GREEN}y${NC}: Docker, ${RED}n${NC}: Shell)"
    echo -e "  ${CYAN}--cli${NC} [${GREEN}y${NC}/${RED}n${NC}]               (Shell安装时) 是否安装 TUI-CLI 工具 (${YELLOW}推荐${NC})"
    echo -e "  ${CYAN}--force${NC}                   (Shell安装时) 强制重装 LinuxQQ 和 NapCat"
    echo -e "  ${CYAN}--proxy${NC} [${BLUE}0-n${NC}]             指定下载代理序号 (${BLUE}0${NC}: 不使用, ${BLUE}1-n${NC}: 内置列表)"
    echo -e "  ${CYAN}--qq${NC} \"<号码>\"             (Docker安装时) 指定 QQ 号码"
    echo -e "  ${CYAN}--mode${NC} [${BLUE}ws${NC}|${BLUE}reverse_ws${NC}|...] (Docker安装时) 指定运行模式"
    echo -e "  ${CYAN}--confirm${NC} [${GREEN}y${NC}]             (Docker安装时) 跳过最终确认直接执行"
    echo ""
    echo -e "${YELLOW}使用示例:${NC}"
    echo -e "  ${BLUE}# 使用 TUI 进行 Shell (Rootless) 安装:${NC}"
    echo -e "  ${CYAN}bash napcat.sh --tui${NC}"
    echo ""
    echo -e "  ${BLUE}# Docker 安装 (指定 QQ, 模式, 代理, 并跳过确认):${NC}"
    echo -e "  ${CYAN}bash napcat.sh --docker y --qq \"123456789\" --mode ws --proxy 1 --confirm y${NC}"
    echo ""
    echo -e "  ${BLUE}# Shell (Rootless) 安装 (不装 TUI-CLI, 不用代理, 强制重装):${NC}"
    echo -e "  ${CYAN}bash napcat.sh --docker n --cli n --proxy 0 --force${NC}"
    echo ""
}

function chekc_whiptail() {
    if [[ "${TERM}" != "xterm" && "${TERM}" != "xterm-256color" ]]; then
        log "错误, 当前终端不支持 whiptail。请使用普通方式或使用支持 whiptail 的终端，例如 xterm 或 xterm-256color。查看当前终端类型请使用echo \$TERM"
        exit 1
    fi

    if ! command -v whiptail &>/dev/null; then
        log "未发现whiptail, 开始安装..."
        detect_package_manager

        if [ "${package_manager}" = "apt-get" ]; then
            execute_command "sudo apt-get update -y -qq" "更新软件包列表"
            execute_command "sudo apt-get install -y -qq whiptail" "安装whiptail"
        elif [ "${package_manager}" = "dnf" ]; then
            if [ "${dnf_host}" = "el" ]; then
                execute_command "sudo dnf install -y epel-release" "安装epel"
            fi
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
                "1" "🐚 Shell 安装 (Rootless)" \
                "2" "🐋 Docker 安装" \
                "3" "🚪 退出" 3>&1 1>&2 2>&3
        )

        case $choice in
        "1")
            #  TUI Shell install flow 
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
            #  Docker install requires root 
            check_root
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

#  脚本主逻辑开始 

# 1. 分析参数
while [[ $# -gt 0 ]]; do
    case $1 in
    --tui)
        use_tui="y"
        shift
        ;;
    --docker)
        use_docker="$2"
        shift 2
        ;;
    --qq)
        qq="$2"
        shift 2
        ;;
    --mode)
        mode="$2"
        shift 2
        ;;
    --confirm)
        if [[ "$2" =~ ^[Yy]$ ]] || [[ $# -eq 1 ]]; then
            confirm="y"
            shift
            if [[ "$2" =~ ^[Yy]$ ]]; then
                shift
            fi
        else
            confirm="n"
            shift 2
        fi
        ;;
    --force)
        force="y"
        shift
        ;;
    --proxy)
        proxy_num_arg="$2"
        shift 2
        ;;
    --cli)
        use_cli="$2"
        shift 2
        ;;
    --help | -h)
        logo
        shell_help
        exit 0
        ;;
    *)
        echo "未知参数: $1"
        shell_help
        exit 1
        ;;
    esac
done

# 2. 初始化
clear
logo
print_introduction
check_sudo
#  Root check is moved to be conditional 

# 3. 首先处理TUI安装
if [ "${use_tui}" = "y" ]; then
    main_tui
    exit $?
fi

# 4. 非TUI模式，处理没有被设置的arg
if [ -z "${use_docker}" ]; then
    log "选择安装方式: Docker (容器化) 或 Shell (直接安装)?"
    log "输入 'y' 使用 Docker, 输入 'n' 使用 Shell。"
    read -t 10 -p "[y/N] (10秒后默认 N): " use_docker_input
    echo ""

    if [[ $? -ne 0 ]]; then
        log "超时未输入, 默认使用 Shell 安装。"
        use_docker="n"
    elif [[ "${use_docker_input}" =~ ^[Yy]$ ]]; then
        log "选择使用 Docker 安装。"
        use_docker="y"
    elif [[ "${use_docker_input}" =~ ^[Nn]$ ]] || [ -z "${use_docker_input}" ]; then
        log "选择使用 Shell 安装。"
        use_docker="n"
    else
        log "输入无效 ('${use_docker_input}'), 默认使用 Shell 安装。"
        use_docker="n"
    fi
fi

if [ "${use_docker}" = "n" ] && [ -z "${use_cli}" ]; then
    log "是否安装 NapCat TUI-CLI (命令行工具)?"
    log "输入 'y' 安装, 输入 'n' 跳过。"
    read -t 10 -p "[Y/n] (10秒后默认 Y): " use_cli_input
    echo ""

    if [[ $? -ne 0 ]]; then
        log "超时未输入, 默认安装 CLI。"
        use_cli="y"
    elif [[ "${use_cli_input}" =~ ^[Nn]$ ]]; then
        log "选择不安装 CLI。"
        use_cli="n"
    else
        log "选择或超时默认为安装 CLI。"
        use_cli="y"
    fi
fi

# 5. 执行安装
if [ "${use_docker}" = "y" ]; then
    #  Check for root only when Docker is selected 
    check_root
    docker_install
    exit_status=$?
    if [ ${exit_status} -eq 0 ]; then
        log "Docker 安装流程完成。"
    else
        log "Docker 安装流程失败。"
    fi
    exit ${exit_status}
elif [ "${use_docker}" = "n" ]; then
    log "开始 Shell (Rootless) 安装流程..."
    install_dependency
    download_napcat
    check_linuxqq
    check_napcat
    check_napcat_cli
    show_main_info
    clean
    log "Shell (Rootless) 安装流程完成。"
else
    log "错误: 无效的安装选项 (use_docker=${use_docker})。"
    exit 1
fi
