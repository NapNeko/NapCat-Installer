#! /bin/bash
export QQ_PATH='/opt/QQ/resources/app'

detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "none"
    fi
}

# 函数：检查当前系统是amd64还是x86_64 读取失败返回none
get_system_arch() {
    echo $(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)
}

# 函数：代理连通性测试
network_test() {
    local found=0
    target_proxy=""
    proxy_num=${proxy_num:-99} # 超出范围表示自动选择
    # GitHub 加速节点，来源 https://github.akams.cn/ ，失效了就从那里换新的
    proxy_arr=("https://ghfast.top" "https://ghproxy.net" "https://github.dpik.top" "https://ghm.078465.xyz" "https://gh.monlor.com" "https://ghproxy.imciel.com" "https://git.669966.xyz" "https://gh.acmsz.top" "https://gitproxy.mrhjx.cn" "https://gh-proxy.com")
    check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    if [ ! -z "$proxy_num" ] && [ "$proxy_num" -ge 1 ] && [ "$proxy_num" -le ${#proxy_arr[@]} ]; then
        echo "手动指定代理：${proxy_arr[$proxy_num-1]}"
        target_proxy="${proxy_arr[$proxy_num-1]}"
    else
        if [ "$proxy_num" -ne 0 ]; then
            echo "proxy 未指定或超出范围，正在检查${parm1}代理可用性..."
            # 代理都不通时最后试一次直连；有的代理拿不到文件也返回 200 和网页，所以要看内容是不是 JSON
            for proxy in "${proxy_arr[@]}" ""; do
                if [ "$(curl -k -s -m 15 "${proxy:+${proxy}/}$check_url" | head -c1)" = "{" ]; then
                    found=1
                    target_proxy="$proxy"
                    echo "将使用${parm1}代理：${proxy:-直连}"
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
    napcat_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.Framework.zip"
}

# 函数：获取最新 NapCat 版本号。读 GitHub releases/latest 跳转到的 tag，不占 API 次数，直连不通时换代理
get_latest_napcat_version() {
    local proxy tag
    for proxy in "" "https://ghfast.top" "https://ghproxy.net" "https://github.dpik.top" "https://gh.monlor.com"; do
        tag=$(curl -k -s -m 10 -o /dev/null -w '%{redirect_url}' "${proxy:+${proxy}/}https://github.com/NapNeko/NapCatQQ/releases/latest" | sed -n 's|.*/releases/tag/\([^/?#[:space:]]*\).*|\1|p')
        if [ -n "$tag" ]; then
            echo "$tag"
            return 0
        fi
    done
    return 1
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

system_arch=$(get_system_arch)
if [ "$system_arch" = "none" ]; then
    echo "无法识别的系统架构，请检查错误。"
    exit 1
fi
echo "当前系统架构：$system_arch"

# 获取最新最热NapCat版本号
napcat_version=$(get_latest_napcat_version)
if [ -z "$napcat_version" ]; then
    echo "无法获取NapCatQQ版本，请检查错误。"
    exit 1
fi

echo "最新NapCatQQ版本：$napcat_version"
# 保证 curl/wget apt/rpm 基础环境
echo "正在更新依赖..."
package_manager=$(detect_package_manager)
# 开始安装基础依赖
if [ "$package_manager" = "apt" ]; then
    sudo apt update -y
    sudo apt install -y zip unzip jq curl
elif [ "$package_manager" = "yum" ]; then
    # 安装epel, 因为某些包在自带源里缺失
    sudo yum install -y epel-release
    sudo yum install -y zip unzip jq curl
elif [ "$package_manager" = "pacman" ]; then
    sudo pacman -S zip unzip jq curl
else
    echo "包管理器检查失败，目前仅支持apt/yum。"
    exit 1
fi

# 判断LITELOADERQQNT_PROFILE是否存在
if [ $LITELOADERQQNT_PROFILE ]; then
    network_test
    curl -o ./NapCat.zip $napcat_download_url
    sudo unzip -d $LITELOADERQQNT_PROFILE/plugins/ ./NapCat.zip
    echo '安装结束，请重启QQ'
else
    # 获取LiteLoaderQQNT路径
    package_main1=$(jq '.main' $QQ_PATH/package.json)
    package_main=${package_main1#*/}
    liteloaderjs_path=${QQ_PATH}'/app_launcher/'${package_main%\"*}
    liteloader_path=$(cat liteloaderjs_path)
    liteloaderqqnt1=${liteloader_path#*\`}
    liteloaderqqnt=${liteloaderqqnt1%*\`}
    network_test
    curl -o ./NapCat.zip $napcat_download_url
    sudo unzip -d $liteloaderqqnt/plugins/ ./NapCat.zip
    echo '安装结束，请重启QQ'
fi

