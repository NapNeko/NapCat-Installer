#! /bin/bash
export QQ_PATH='/opt/QQ/resources/app'

detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
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
    proxy_num=${proxy_num:-9}
    proxy_arr=("https://github.moeyy.xyz" "https://mirror.ghproxy.com" "https://gh-proxy.com" "https://x.haod.me")
    check_url="https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    if [ ! -z "$proxy_num" ] && [ "$proxy_num" -ge 1 ] && [ "$proxy_num" -le ${#proxy_arr[@]} ]; then
        echo "手动指定代理：${proxy_arr[$proxy_num-1]}"
        target_proxy="${proxy_arr[$proxy_num-1]}"
    else
        if [ "$proxy_num" -ne 0 ]; then
            echo "proxy 未指定或超出范围，正在检查${parm1}代理可用性..."
            for proxy in "${proxy_arr[@]}"; do
                status=$(curl -o /dev/null -s -w "%{http_code}" "$proxy/$check_url")
                if [ $status -eq 200 ]; then
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
    napcat_download_url="${target_proxy:+${target_proxy}/}https://github.com/NapNeko/NapCatQQ/releases/download/$napcat_version/NapCat.Framework.zip"
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
else
    echo "包管理器检查失败，目前仅支持apt/yum。"
    exit 1
fi

# 判断LITELOADERQQNT_PROFILE是否存在
if [ ! $LITELOADERQQNT_PROFILE ]
    network_test
    curl -o ./NapCat.zip $napcat_download_url
    sudo unzip -d $LITELOADERQQNT_PROFILE/plugins/ ./NapCat.zip
    echo '安装结束，请重启QQ'
else
    # 获取LiteLoaderQQNT路径
    LITELOADERQQNT=${${$(cat ${QQ_PATH}/app_launcher/${$(jq '.main' ${QQ_PATH}/package.json)#*/})#*`}%`*}
    network_test
    curl -o ./NapCat.zip $napcat_download_url
    sudo unzip -d $LITELOADERQQNT/plugins/ ./NapCat.zip
    echo '安装结束，请重启QQ'


