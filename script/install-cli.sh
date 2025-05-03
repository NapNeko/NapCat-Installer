#!/bin/bash



MAGENTA='\033[0;1;35;95m'
RED='\033[0;1;31;91m'
YELLOW='\033[0;1;33;93m'
GREEN='\033[0;1;32;92m'
CYAN='\033[0;1;36;96m'
BLUE='\033[0;1;34;94m'
NC='\033[0m'

function log() {
    time=$(date +"%Y-%m-%d %H:%M:%S")
    message="[${time} CLI]: $1 " # Add CLI prefix to logs
    case "$1" in
    *"失败"* | *"错误"*)
        echo -e "${RED}${message}${NC}"
        ;;
    *"成功"*)
        echo -e "${GREEN}${message}${NC}"
        ;;
    *"警告"*)
        echo -e "${YELLOW}${message}${NC}"
        ;;
    *)
        echo -e "${BLUE}${message}${NC}"
        ;;
    esac
}

# --- Minimal Network Test (Adapted) ---
target_proxy="" # Global variable for proxy URL

function network_test() {
    # $1 is now the proxy number argument
    local proxy_num_arg=${1:-9} # Get proxy number from argument, default 9 (auto)
    local parm1="Github" # Hardcode service to Github for this script
    local found=0
    target_proxy="" # Reset target_proxy

    # Define Github proxy array and check URL
    local proxy_arr=("https://ghfast.top" "https://ghp.ci" "https://gh.wuliya.xin" "https://gh-proxy.com" "https://x.haod.me")
    local check_url="https://raw.githubusercontent.com/lux-QAQ/NapCat-Installer/refs/heads/main/script/install-cli.sh" # Updated check URL

    # Check if a specific proxy number is requested and valid
    if [[ "${proxy_num_arg}" =~ ^[1-9][0-9]*$ ]] && [ "${proxy_num_arg}" -le ${#proxy_arr[@]} ]; then
        log "手动指定代理序号: ${proxy_num_arg}"
        target_proxy="${proxy_arr[$proxy_num_arg - 1]}"
        log "将使用${parm1}代理: ${target_proxy}"
        # Test the specified proxy (optional but good practice)
        status=$(curl --connect-timeout 5 -o /dev/null -s -w "%{http_code}" "${target_proxy}/${check_url}")
        if [ ${status} -ne 200 ]; then
             log "警告: 手动指定的代理 ${target_proxy} 测试失败 (状态码: ${status})，但仍将尝试使用。"
             # Keep target_proxy set, maybe it works for download but not check_url
        fi
    # Check if proxy is disabled
    elif [ "${proxy_num_arg}" -eq 0 ]; then
        log "代理已关闭 (--proxy 0), 将直接连接 ${parm1}..."
        target_proxy=""
    # Auto-detect proxy if not specified, disabled, or out of range
    else
        log "proxy 未指定或超出范围 (${proxy_num_arg}), 正在检查 ${parm1} 代理可用性..."
        for proxy in "${proxy_arr[@]}"; do
            log "测试代理: ${proxy}"
            status=$(curl --connect-timeout 5 -o /dev/null -s -w "%{http_code}" "${proxy}/${check_url}")
            if [ ${status} -eq 200 ]; then
                found=1
                target_proxy="${proxy}"
                log "将使用 ${parm1} 代理: ${target_proxy}"
                break
            else
                log "代理 ${proxy} 测试失败 (状态码: ${status})"
            fi
        done

        if [ ${found} -eq 0 ]; then
            log "错误: 无法通过任何代理或直连访问 ${parm1} (${check_url})。"
            log "请检查网络连接或尝试手动指定有效代理 (--proxy 1-N)。"
            # Return error instead of exiting, let caller handle it
            return 1
        fi
    fi
    return 0 # Return success
}


function check_and_install_dependencies() {
    local missing_deps=()
    local package_manager=""
    local install_cmd=""
    local update_cmd=""
    local needs_update=false

    # Detect package manager
    if command -v apt-get &>/dev/null; then
        package_manager="apt-get"
        install_cmd="sudo apt-get install -y -qq"
        update_cmd="sudo apt-get update -y -qq"
    elif command -v dnf &>/dev/null; then
        package_manager="dnf"
        install_cmd="sudo dnf install -y"
        update_cmd="sudo dnf check-update" # dnf usually doesn't need explicit update like apt
    else
        log "错误: 无法检测到 apt-get 或 dnf 包管理器。"
        return 1
    fi
    log "检测到包管理器: ${package_manager}"

    # Check for dialog
    if ! command -v dialog &>/dev/null; then
        log "依赖 'dialog' 未安装。"
        missing_deps+=("dialog")
        needs_update=true # apt needs update before install
    else
        log "依赖 'dialog' 已安装。"
    fi

    # Check for ffmpeg
    if ! command -v ffmpeg &>/dev/null; then
        log "依赖 'ffmpeg' 未安装。"
        # On RHEL/CentOS, ffmpeg might be in EPEL or RPM Fusion
        if [[ "$package_manager" == "dnf" ]]; then
             # Recommend enabling RPM Fusion if ffmpeg is missing
             log "警告: 'ffmpeg' 可能需要启用 EPEL 或 RPM Fusion 仓库。"
             log "尝试从标准仓库安装..."
             missing_deps+=("ffmpeg")
        else
             missing_deps+=("ffmpeg")
        fi
        needs_update=true # apt needs update before install
    else
        log "依赖 'ffmpeg' 已安装。"
    fi

    # Install missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log "开始安装缺失的依赖: ${missing_deps[*]}"
        if [[ "$package_manager" == "apt-get" && "$needs_update" == true ]]; then
            log "更新软件包列表 (${package_manager})..."
            ${update_cmd}
            if [ $? -ne 0 ]; then
                 log "错误: 更新软件包列表失败。"
                 # Continue trying to install anyway? Or return error? Let's try installing.
            fi
        fi

        ${install_cmd} "${missing_deps[@]}"
        if [ $? -ne 0 ]; then
            log "错误: 安装部分或全部依赖 (${missing_deps[*]}) 失败。"
            log "请尝试手动安装: ${install_cmd} ${missing_deps[*]}"
            return 1
        else
            log "依赖安装成功。"
        fi
    else
        log "所有 TUI-CLI 依赖已满足。"
    fi
    return 0
}

# --- 主要的安装逻辑 ---
function install_cli_components() {
    log "准备安装/更新 NapCatQQ TUI-CLI 及其组件..."

    # 1. Check and install dependencies (dialog, ffmpeg)
    if ! check_and_install_dependencies; then
        log "错误: 依赖检查或安装失败，无法继续安装 TUI-CLI。"
        return 1
    fi

    # 2. Run network test based on passed argument
    network_test "$1"
    local network_status=$?
    if [ $network_status -ne 0 ] && [ -z "$target_proxy" ] && [ "$1" -ne 0 ]; then
         log "网络测试失败且未使用代理, 无法下载 CLI 文件。"
         # Allow continuing? Maybe user has files locally? For now, fail.
         return 1
    fi

    # 3. Define files, URLs, and targets
    # Updated base_url
    local base_url="https://raw.githubusercontent.com/lux-QAQ/NapCat-Installer/main/script/tui-cli"
    local target_dir="/usr/local/bin"
    local files_to_download=("napcat" "_napcat_Boot" "_napcat_Config")
    local download_failed=false

    # Ensure target directory exists (though /usr/local/bin usually does)
    sudo mkdir -p "${target_dir}"

    # 4. Download and install loop
    for file_name in "${files_to_download[@]}"; do
        local download_url="${target_proxy:+${target_proxy}/}${base_url}/${file_name}"
        local temp_file=$(mktemp) # Create temp file as current user
        local target_path="${target_dir}/${file_name}"

        log "下载 ${file_name} 从 ${download_url}..."
        # Download to the temporary file (no sudo needed for curl)
        curl -L -# "${download_url}" -o "${temp_file}"

        if [ $? -ne 0 ]; then
            log "${file_name} 文件下载失败, 请检查网络或链接 (${download_url})。"
            rm -f "${temp_file}" # Clean up failed download (no sudo needed)
            download_failed=true
            continue # Try downloading the next file
        fi
        log "${file_name} 文件下载成功: ${temp_file}"

        # Move the file to the target location first (needs sudo)
        log "移动 ${file_name} 文件到 ${target_path}..."
        sudo mv "${temp_file}" "${target_path}"
        if [ $? -ne 0 ]; then
            log "移动 ${file_name} 文件到 ${target_path} 失败, 请检查权限或目标目录。"
            # Attempt to clean up downloaded file if move failed (no sudo needed)
            if [ -f "${temp_file}" ]; then # Check if temp file still exists
                rm -f "${temp_file}"
            fi
            download_failed=true
            continue
        fi
        # temp_file is removed by mv on success

        # Set execute permissions AFTER moving (needs sudo)
        log "设置 ${file_name} 文件权限: ${target_path}..."
        sudo chmod 755 "${target_path}"
        if [ $? -ne 0 ]; then
            log "设置 ${file_name} 文件执行权限失败: ${target_path}"
            # File is already moved, but permissions failed. Mark as failure.
            download_failed=true
            continue
        else
            log "${file_name} 文件安装并设置权限成功。"
        fi
    done

    # 5. Final status
    if ${download_failed}; then
        log "警告: 部分或全部 TUI-CLI 组件下载或安装失败。"
        return 1 # Indicate partial or complete failure
    else
        log "所有 TUI-CLI 组件安装/更新成功。"
        return 0 # Indicate success
    fi
}

# --- Script Entry Point ---
# Pass the first argument (proxy number) to the function
install_cli_components "$1"
exit $? # Exit with the return code of the function