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
    if [[ $EUID -ne 0 ]] && ! command -v sudo &>/dev/null; then
        log "sudo不存在, 请手动安装: \n Centos: dnf install -y sudo\n Debian/Ubuntu: apt-get install -y sudo\n"
        exit 1
    fi
}

function run_as_root() {
    if [[ $EUID -eq 0 ]]; then
        "$@"
    else
        check_sudo
        sudo --preserve-env=http_proxy,https_proxy,all_proxy,no_proxy,HTTP_PROXY,HTTPS_PROXY,ALL_PROXY,NO_PROXY,CURL_CA_BUNDLE,SSL_CERT_FILE "$@"
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
    if [[ "${system_arch}" != "amd64" && "${system_arch}" != "arm64" ]]; then
        log "不支持的系统架构: ${system_arch}，仅支持 amd64/arm64。"
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

function format_speed() {
    local speed_bps=$1
    if (( speed_bps > 1048576 )); then
        # MB/s
        local speed_mbs=$((speed_bps / 1048576))
        echo "${speed_mbs} MB/s"
    elif (( speed_bps > 1024 )); then
        # KB/s
        local speed_kbs=$((speed_bps / 1024))
        echo "${speed_kbs} KB/s"
    else
        # B/s
        echo "${speed_bps} B/s"
    fi
}

# GitHub 加速节点，来源 https://github.akams.cn/ ，失效了就从那里换新的
github_proxy_arr=("https://ghfast.top" "https://ghproxy.net" "https://github.dpik.top" "https://ghm.078465.xyz" "https://gh.monlor.com" "https://ghproxy.imciel.com" "https://git.669966.xyz" "https://gh.acmsz.top" "https://gitproxy.mrhjx.cn" "https://gh-proxy.com")

function curl_download() {
    local source="$1" destination="$2" partial status
    partial=$(mktemp "${destination}.XXXXXX") || return 1
    if curl -fL --connect-timeout "${NAPCAT_CONNECT_TIMEOUT:-20}" \
        --max-time "${NAPCAT_DOWNLOAD_TIMEOUT:-1800}" \
        --proto '=http,https' --proto-redir '=http,https' "$source" -o "$partial"; then
        mv -- "$partial" "$destination"
    else
        status=$?
        rm -f -- "$partial"
        return "$status"
    fi
}

function network_test() {
    local service="$1" setting="${proxy_num_arg:-auto}"
    local candidates=("") check_url
    target_proxy=""
    case "$service" in
        Github)
            if [ -n "${github_proxy_arg+x}" ]; then
                case "$github_proxy_arg" in
                    0|"") return 0 ;;
                    http://*|https://*) target_proxy="${github_proxy_arg%/}"; return 0 ;;
                    *) log "错误: --github-proxy 需要 HTTP(S) URL 或 0。"; return 1 ;;
                esac
            fi
            candidates+=("${github_proxy_arr[@]}")
            check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
            ;;
        Docker)
            if [ -n "${docker_image_arg:-}" ]; then return 0; fi
            candidates+=("docker.1ms.run" "docker.xuanyuan.me" "docker.mybacc.com" "dytt.online" "lispy.org")
            ;;
        *) log "错误: 未知网络目标 $service"; return 1 ;;
    esac
    if [ "$setting" = 0 ]; then
        return 0
    elif [[ "$setting" =~ ^[1-9][0-9]*$ ]] && [ "$setting" -lt "${#candidates[@]}" ]; then
        target_proxy="${candidates[$setting]}"
        return 0
    elif [ "$setting" != auto ]; then
        log "错误: 无效的 $service 代理参数 '$setting'。"
        return 1
    fi
    log "并行检测 $service 下载线路..."
    local temporary_dir index probe_url selected
    temporary_dir=$(mktemp -d) || return 1
    for index in "${!candidates[@]}"; do
        (
            if [ "$service" = Github ]; then
                probe_url="${candidates[$index]:+${candidates[$index]}/}${check_url}"
            elif [ "$index" = 0 ]; then
                probe_url="https://registry-1.docker.io/v2/"
            else
                probe_url="https://${candidates[$index]}/v2/"
            fi
            if curl -sSL --connect-timeout 4 --max-time 8 --max-filesize 65536 \
                --proto '=http,https' --proto-redir '=http,https' \
                -D "$temporary_dir/$index.headers" -o "$temporary_dir/$index.body" \
                -w '%{http_code} %{time_total}' "$probe_url" > "$temporary_dir/$index.result" 2>/dev/null; then
                read -r status elapsed < "$temporary_dir/$index.result"
                if { [ "$service" = Github ] && [ "$status" = 200 ] &&
                     jq -e '.name == "napcat"' "$temporary_dir/$index.body" >/dev/null 2>&1; } ||
                   { [ "$service" = Docker ] && [[ "$status" = 200 || "$status" = 401 ]] &&
                     grep -qi '^docker-distribution-api-version: *registry/2.0' "$temporary_dir/$index.headers"; }; then
                    printf '%s %s\n' "$elapsed" "$index" > "$temporary_dir/$index.ok"
                fi
            fi
        ) &
    done
    wait
    selected=$(
        for result in "$temporary_dir"/*.ok; do
            if [ -f "$result" ]; then cat "$result"; fi
        done | sort -n | head -n 1
    )
    rm -rf -- "$temporary_dir"
    if [ -z "$selected" ]; then
        log "错误: $service 直连和候选线路均不可用，请指定网络参数或使用本地安装包。"
        return 1
    fi
    read -r elapsed index <<< "$selected"
    target_proxy="${candidates[$index]}"
    log "$service 下载线路: ${target_proxy:-直连}"
}

function install_el_repo() {
    # 检查是否为 OpenCloudOS 9+
    if [ -f "/etc/opencloudos-release" ]; then
        # 提取主版本号
        os_version=$(grep -oE '[0-9]+' /etc/opencloudos-release | head -n 1)
        if [[ -n "$os_version" && "$os_version" -ge 9 ]]; then
            log "检测到 OpenCloudOS 9+, 安装 epol-release..."
            execute_command "run_as_root dnf install -y epol-release" "安装epol"
        else
            # 低于 9 或无法确定版本，回退到 epel
            log "OpenCloudOS 版本低于 9 或无法确定版本, 安装 epel-release..."
            execute_command "run_as_root dnf install -y epel-release" "安装epel"
        fi
    else
        # 其他 EL 系统，安装 epel
        log "非 OpenCloudOS 的 EL 系统, 安装 epel-release..."
        execute_command "run_as_root dnf install -y epel-release" "安装epel"
    fi
}

function enable_dnf_repos_and_cache() {
    log "检查并配置 dnf 仓库..."
    # 确保 config-manager 工具可用
    if ! rpm -q dnf-plugins-core >/dev/null 2>&1; then
        execute_command "run_as_root dnf install -y dnf-plugins-core" "安装 dnf-plugins-core"
    fi

    # 检查 appstream 仓库是否存在且被禁用
    if dnf repolist all | grep -q '^appstream\s'; then
        if dnf repolist disabled | grep -q '^appstream\s'; then
            execute_command "run_as_root dnf config-manager --set-enabled appstream" "启用 AppStream 仓库"
        else
            log "AppStream 仓库已启用。"
        fi
    else
        log "警告: 未检测到 appstream 仓库，依赖安装可能不完整。"
    fi

    # 刷新缓存以确保更改生效
    execute_command "run_as_root dnf makecache --refresh" "刷新 dnf 缓存"
}


function check_root_for_shell_install() {
    if [[ $EUID -eq 0 ]]; then
        log "警告: 您正在使用root权限执行本脚本（不推荐），脚本会在适当的地方向您申请sudo。"
        echo -e "${YELLOW}[$(date +"%Y-%m-%d %H:%M:%S")]: 如果您正在使用旧版本的tui执行升级，那么会持续导致这个问题。请使用您首次安装 napcat 时的指令重新安装并且重装 tui${NC}"
    fi
}

function install_dependency() {
    if [ "${skip_dependencies:-n}" = y ]; then
        detect_package_manager
        log "使用已安装的系统依赖。"
        return 0
    fi
    log "开始安装系统依赖 (此步骤需要 sudo 权限)..."
    detect_package_manager

    if [ "${package_manager}" = "apt-get" ]; then
        log "更新软件包列表中..."
        run_as_root apt-get update -y -qq || return 1
        log "更新软件包列表成功"

        # 静态依赖包列表
        local static_pkgs="zip unzip jq curl xvfb screen xauth procps rpm2cpio cpio libnss3 libgbm1 libgssapi-krb5-2"
        
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
        execute_command "run_as_root apt-get install -y -qq ${all_pkgs_to_install}" "安装依赖"

    elif [ "${package_manager}" = "dnf" ]; then
        if [ "${dnf_host}" = "el" ]; then
            install_el_repo
        fi
        enable_dnf_repos_and_cache
        #  Added cpio for extracting .rpm 
        base_pkgs="zip unzip jq curl screen procps-ng cpio rpm-build nss mesa-libgbm atk at-spi2-atk gtk3 alsa-lib pango cairo libdrm libXcursor libXrandr libXdamage libXcomposite libXfixes libXrender libXi libXtst libXScrnSaver cups-libs libxkbcommon krb5-libs xorg-x11-xauth"
        x_extra="libX11-xcb"
        mesa_extra="mesa-dri-drivers mesa-libEGL mesa-libGL"
        xcb_utils="xcb-util xcb-util-image xcb-util-wm xcb-util-keysyms xcb-util-renderutil"
        fonts="fontconfig dejavu-sans-fonts"
        xvfb_pkg="xorg-x11-server-Xvfb"
        all_pkgs="${base_pkgs} ${x_extra} ${mesa_extra} ${xcb_utils} ${fonts} ${xvfb_pkg}"

        execute_command "run_as_root dnf install -y ${all_pkgs}" "安装依赖"
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
    local default_file="NapCat.Shell.zip"
    if [ -f "$default_file" ]; then
        log "使用本地 NapCat 安装包。"
    else
        network_test Github || return 1
        local download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/latest/download/NapCat.Shell.zip"
        if ! curl_download "$download_url" "$default_file"; then
            log "NapCat 下载失败，已有安装和本地文件保持不变。"
            return 1
        fi
    fi
    if ! unzip -t "$default_file" >/dev/null 2>&1; then
        log "安装包验证失败，请检查 NapCat.Shell.zip。"
        return 1
    fi
    unzip -q -o -d ./NapCat "$default_file"
}

function get_qq_target_version() {
    linuxqq_target_version="3.2.34-53644"
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

    if [[ -z "${linuxqq_target_version}" || "${linuxqq_target_version}" == "null" ]]; then
        log "无法获取目标QQ版本, 请检查错误。"
        exit 1
    fi

    log "目标LinuxQQ版本: ${linuxqq_target_version}"

    # 核心检测逻辑：检查 package.json 文件是否存在
    if [ -f "${QQ_PACKAGE_JSON_PATH}" ]; then
        linuxqq_installed_version=$(jq -r '.version' "${QQ_PACKAGE_JSON_PATH}")
        log "检测到已安装的QQ, 版本: ${linuxqq_installed_version}"
        if [ "${force}" != "y" ]; then
            compare_linuxqq_versions "${linuxqq_installed_version}" "${linuxqq_target_version}"
        fi
    else
        log "未在 ${INSTALL_BASE_DIR} 检测到已安装的QQ。"
        force="y" # 未安装，强制执行安装
    fi

    if [ "${force}" = "y" ]; then
        log "安装或更新 LinuxQQ，保留现有 NapCat 配置和插件..."
        install_linuxqq_rootless
    else
        log "版本已满足要求, 无需更新。"
        update_linuxqq_config "${linuxqq_installed_version}"
    fi
}

#  REWRITTEN: install_linuxqq_rootless for rootless 
function install_linuxqq_rootless() (
    set -e
    get_system_arch
    log "开始以用户模式安装 LinuxQQ 到 ${INSTALL_BASE_DIR}..."

    local qq_download_url=""
    local qq_package_file=""
    local qq_remote_file=""

    if [ "${system_arch}" = "amd64" ]; then
        if [ "${package_installer}" = "rpm" ]; then
            qq_remote_file="linuxqq_3.2.34-53644_x86_64.rpm"
            qq_package_file="QQ.rpm"
        elif [ "${package_installer}" = "dpkg" ]; then
            qq_remote_file="linuxqq_3.2.34-53644_amd64.deb"
            qq_package_file="QQ.deb"
        fi
    elif [ "${system_arch}" = "arm64" ]; then
        if [ "${package_installer}" = "rpm" ]; then
            qq_remote_file="linuxqq_3.2.34-53644_aarch64.rpm"
            qq_package_file="QQ.rpm"
        elif [ "${package_installer}" = "dpkg" ]; then
            qq_remote_file="linuxqq_3.2.34-53644_arm64.deb"
            qq_package_file="QQ.deb"
        fi
    fi

    if [ -z "${qq_remote_file}" ]; then
        log "获取QQ下载链接失败, 架构不支持。"
        exit 1
    fi

    qq_download_url="https://qqdl.gtimg.cn/qqfile/QQNT/9.9.36/beta/9ee04bef/${qq_remote_file}"

    if ! [ -f "${qq_package_file}" ]; then
        log "QQ下载链接: ${qq_download_url}"
        if ! curl_download "${qq_download_url}" "${qq_package_file}"; then
            rm -f "${qq_package_file}"
            log "QQ 下载失败，请检查网络，或将安装包放在当前目录后重试。"
            exit 1
        fi
    else
        log "检测到当前目录下存在QQ安装包, 将使用本地安装包进行安装。"
    fi

    log "正在创建安装目录: ${INSTALL_BASE_DIR}"
    mkdir -p "${INSTALL_BASE_DIR}"
    local staging
    staging=$(mktemp -d "$INSTALL_BASE_DIR/.qq.XXXXXX")
    trap 'if [ ! -d "$staging/previous-QQ" ]; then rm -rf -- "$staging"; fi' EXIT

    log "正在解压QQ文件..."
    if [ "${package_installer}" = "dpkg" ]; then
        dpkg -x "./${qq_package_file}" "$staging" || exit 1
    elif [ "${package_installer}" = "rpm" ]; then
        # 切换到目标目录再执行解压，以确保文件路径正确
        (set -o pipefail; rpm2cpio "${PWD}/${qq_package_file}" | (cd "$staging" && cpio -idmu))
        if [ $? -eq 0 ]; then
            log "解压QQ (.rpm)成功"
        else
            log "解压QQ (.rpm)失败"
            exit 1
        fi
    fi

    local staged_qq="$staging/opt/QQ"
    if [ ! -x "$staged_qq/qq" ] || ! jq -e --arg expected "$linuxqq_target_version" \
        '.version == $expected' "$staged_qq/resources/app/package.json" >/dev/null; then
        log "QQ 安装包内容或版本不正确，需要 ${linuxqq_target_version}。"
        exit 1
    fi
    if [ -d "$TARGET_FOLDER/napcat" ]; then
        mkdir -p "$staged_qq/resources/app/app_launcher"
        cp -a -- "$TARGET_FOLDER/napcat" "$staged_qq/resources/app/app_launcher/" || exit 1
    fi
    mkdir -p "${QQ_BASE_PATH%/*}"
    if [ -d "$QQ_BASE_PATH" ]; then
        mv -- "$QQ_BASE_PATH" "$staging/previous-QQ" || exit 1
    fi
    if ! mv -- "$staged_qq" "$QQ_BASE_PATH"; then
        if [ -d "$staging/previous-QQ" ]; then
            mv -- "$staging/previous-QQ" "$QQ_BASE_PATH" || log "恢复旧 QQ 失败，备份保留在 $staging/previous-QQ。"
        fi
        exit 1
    fi
    rm -rf -- "$staging/previous-QQ"

    # 清理下载的安装包
    rm -f "${qq_package_file}"
    update_linuxqq_config "${linuxqq_target_version}"
)

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
                return 1
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
    log "直接安装/覆盖最新NapCat..."
    install_napcat
}

function install_napcat() {
    #  Removed sudo, updated paths 
    if [ ! -d "${TARGET_FOLDER}/napcat" ]; then
        mkdir -p "${TARGET_FOLDER}/napcat/"
    fi

    log "正在更新 NapCat 文件..."
    local item
    for item in ./NapCat/*; do
        case "$(basename "$item")" in
            config|plugins)
                mkdir -p "${TARGET_FOLDER}/napcat/$(basename "$item")" || exit 1
                cp -rn "$item/." "${TARGET_FOLDER}/napcat/$(basename "$item")/" || exit 1
                ;;
            *) cp -rf "$item" "${TARGET_FOLDER}/napcat/" || exit 1 ;;
        esac
    done

    log "正在修补文件..."
    cat > "${QQ_BASE_PATH}/resources/app/loadNapCat.js" <<'EOF'
const path = require('node:path');
const { pathToFileURL } = require('node:url');
import(pathToFileURL(path.join(__dirname, 'app_launcher/napcat/napcat.mjs')).href);
EOF
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
    if jq '.main = "./loadNapCat.js"' "${QQ_PACKAGE_JSON_PATH}" >"${QQ_PACKAGE_JSON_PATH}.tmp"; then
        mv "${QQ_PACKAGE_JSON_PATH}.tmp" "${QQ_PACKAGE_JSON_PATH}" || exit 1
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
            install_napcat_cli || return 1
            log "TUI-CLI 更新成功。"
        else
            log "开始安装 TUI-CLI..."
            install_napcat_cli || return 1
            log "TUI-CLI 安装成功。"
        fi
    else
        log "跳过安装/更新 TUI-CLI (用户未选择或使用 --cli n)。"
    fi
}

# TUI-CLI 安装到 /usr/local/bin，保留 sudo 是合理的
function install_napcat_cli() (
    set -e
    network_test Github || exit 1
    local script first_line
    script=$(mktemp)
    trap 'rm -f -- "$script"' EXIT
    local download_url="${target_proxy:+${target_proxy}/}https://raw.githubusercontent.com/NapNeko/NapCat-TUI-CLI/main/script/install-cli.sh"
    curl_download "$download_url" "$script" || exit 1
    read -r first_line < "$script"
    if [[ "$first_line" != '#!'* ]]; then
        log "错误: 下载的 TUI-CLI 安装器不是 Shell 脚本。"
        exit 1
    fi
    bash -n "$script" || exit 1
    bash "$script" "${target_proxy:-0}"
)

function generate_docker_command() {
    local qq=${1}
    local mode=${2}

    if [[ "${mode}" != "ws" && "${mode}" != "reverse_ws" && "${mode}" != "reverse_http" ]]; then
        log "错误: 无效的运行模式 '${mode}', 请选择 ws, reverse_ws 或 reverse_http"
        return 1
    fi

    local docker_args=(docker run -d -e "ACCOUNT=${qq}" -e "MODE=${mode}"
        -e "NAPCAT_GID=$(id -g)" -e "NAPCAT_UID=$(id -u)" -p 6099:6099
        --mount type=volume,source=napcat_config,target=/app/napcat/config
        --mount type=volume,source=napcat_qq,target=/app/.config/QQ
        --name napcat --restart=always)
    if [ "${mode}" = "ws" ]; then
        docker_args+=(-p 3001:3001)
    else
        if [ -z "${onebot_url}" ]; then
            log "反向连接需要使用 --url 指定 OneBot 客户端地址。" >&2
            return 1
        fi
        docker_args+=(-e "ONEBOT_URL=${onebot_url}")
    fi
    docker_args+=("${docker_image_arg:-${target_proxy:+${target_proxy}/}mlikiowa/napcat-docker:latest}")
    printf '%q ' "${docker_args[@]}"
    printf '\n'
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
                if [[ "${mode}" == reverse_* ]]; then
                    onebot_url=$(whiptail --title "反向连接地址" --inputbox "请输入 OneBot 客户端的完整 URL:" 10 60 3>&1 1>&2 2>&3) || return 1
                fi
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
            execute_command "run_as_root apt-get update -y -qq" "更新软件包列表"
            execute_command "run_as_root apt-get install -y -qq curl" "安装 curl"
        elif [ "${package_manager}" = "dnf" ]; then
            if [ "${dnf_host}" = "el" ]; then
                execute_command "run_as_root dnf install -y epel-release" "安装epel"
            fi
            execute_command "run_as_root dnf install -y curl" "安装 curl"
        fi
        curl_download https://get.docker.com get-docker.sh || return 1
        run_as_root chmod +x get-docker.sh
        execute_command "run_as_root sh get-docker.sh" "安装docker"
    else
        log "Docker已安装"
    fi

    while true; do
        if [[ -z ${qq} ]]; then
            log "请输入QQ号: "
            read -r qq || return 1
            if [[ -z ${qq} ]]; then
                log "QQ号不能为空，请重新输入。"
                continue
            fi
        fi

        if [[ -z ${mode} ]]; then
            log "请选择模式 (ws/reverse_ws/reverse_http): "
            read -r mode || return 1
            if [[ "${mode}" != "ws" && "${mode}" != "reverse_ws" && "${mode}" != "reverse_http" ]]; then
                log "错误: 无效的运行模式 '${mode}', 请选择 ws, reverse_ws 或 reverse_http"
                mode=""
                continue
            fi
        fi

        if [[ "${mode}" == reverse_* && -z "${onebot_url}" ]]; then
            log "请输入 OneBot 客户端的完整 URL: "
            read -r onebot_url || return 1
        fi

        log "生成Docker命令..."
        network_test "Docker" || return 1
        docker_command=$(generate_docker_command "${qq}" "${mode}")
        cmd_status=$?

        if [[ $cmd_status -ne 0 || -z ${docker_command} ]]; then
            log "模式错误或命令生成失败, 无法生成命令"
            return 1
        else
            log "即将执行以下命令: "
            log "${docker_command}"
        fi

        if [[ -z ${confirm} ]]; then
            log "是否继续? (y/n) "
            read -r confirm || return 1
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
    local quoted_executable
    printf -v quoted_executable '%q' "$QQ_EXECUTABLE"
    log "\n- Shell (Rootless) 安装完成 -"
    log ""
    log "${GREEN}安装位置:${NC}"
    log "  ${CYAN}${INSTALL_BASE_DIR}${NC}"
    log ""
    log "${GREEN}启动 Napcat (无需 sudo):${NC}"
    log "  ${CYAN}xvfb-run -a ${quoted_executable} --no-sandbox ${NC}"
    log ""
    log "${GREEN}后台运行 Napcat (使用 screen, 无需 sudo):${NC}"
    log "  启动: ${CYAN}screen -dmS napcat xvfb-run -a ${quoted_executable} --no-sandbox${NC}"
    log "  带账号启动: ${CYAN}screen -dmS napcat xvfb-run -a ${quoted_executable} --no-sandbox -q QQ号码${NC}"
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
    echo "离线准备: 将 NapCat.Shell.zip 和 QQ.deb/QQ.rpm 放在当前目录；依赖已预装时可用 --skip-deps。"
    echo "网络参数: --proxy auto|0|序号，--github-proxy HTTP(S)前缀或0，--docker-image 完整镜像名"
    echo "curl 使用 HTTPS_PROXY/ALL_PROXY/NO_PROXY/CURL_CA_BUNDLE；超时可设置 NAPCAT_CONNECT_TIMEOUT/NAPCAT_DOWNLOAD_TIMEOUT。"
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
    echo -e "  ${CYAN}--url${NC} \"<URL>\"              (反向连接时) OneBot 客户端的完整地址"
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
            execute_command "run_as_root apt-get update -y -qq" "更新软件包列表"
            execute_command "run_as_root apt-get install -y -qq whiptail" "安装whiptail"
        elif [ "${package_manager}" = "dnf" ]; then
            if [ "${dnf_host}" = "el" ]; then
                execute_command "run_as_root dnf install -y epel-release" "安装epel"
            fi
            execute_command "run_as_root dnf install -y newt" "安装whiptail"
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
            install_dependency || return 1
            download_napcat || return 1
            check_linuxqq || return 1
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
    case "$1" in
    --docker|--qq|--mode|--url|--proxy|--cli|--github-proxy|--docker-image)
        if [[ $# -lt 2 || "$2" == --* ]]; then
            log "参数 $1 缺少值。"
            exit 1
        fi
        ;;
    esac
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
    --url)
        onebot_url="$2"
        shift 2
        ;;
    --confirm)
        confirm="y"
        shift
        if [[ "${1:-}" =~ ^[YyNn]$ ]]; then
            confirm="${1,,}"
            shift
        fi
        ;;
    --force)
        force="y"
        shift
        ;;
    --skip-deps)
        skip_dependencies=y
        shift
        ;;
    --proxy)
        proxy_num_arg="$2"
        shift 2
        ;;
    --github-proxy)
        github_proxy_arg="$2"
        shift 2
        ;;
    --docker-image)
        docker_image_arg="$2"
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
    check_root_for_shell_install
    log "开始 Shell (Rootless) 安装流程..."
    install_dependency || exit 1
    download_napcat || exit 1
    check_linuxqq || exit 1
    check_napcat
    check_napcat_cli || exit 1
    show_main_info
    clean
    log "Shell (Rootless) 安装流程完成。"
else
    log "错误: 无效的安装选项 (use_docker=${use_docker})。"
    exit 1
fi
