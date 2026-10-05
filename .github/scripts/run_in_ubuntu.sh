#!/bin/bash
# 当任何命令失败时立即退出
set -e

echo " [ROOT] Installing dependencies inside Ubuntu container "
# 设置为非交互模式，避免 apt-get 卡住
export DEBIAN_FRONTEND=noninteractive
apt-get update
# 安装 CI 流程所需的基础工具
apt-get install -y git sudo procps findutils passwd screen

echo " [ROOT] Creating test user 'testuser' "
useradd -m -s /bin/bash testuser

echo " [ROOT] Configuring passwordless sudo for 'testuser' "
echo 'testuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/testuser
chmod 440 /etc/sudoers.d/testuser

echo " [ROOT] Changing repository ownership to 'testuser' "
# 容器内的工作目录是 /repo，我们直接修改它的所有权
chown -R testuser:testuser .

echo " [ROOT] Switching to 'testuser' to run installation and verification "
# 将当前工作目录 ($PWD) 作为参数传递给 testuser 的 shell
sudo -u testuser -i bash -s "$PWD" <<'EOF'
set -e

# 第一个参数 ($1) 是从父 shell 传递过来的仓库路径
REPO_PATH="$1"
echo " [testuser] Changing to repository directory: ${REPO_PATH}"
cd "${REPO_PATH}"

echo " [testuser] Running installation script as $(whoami) "


# 将 install.sh 的调用包裹在子 shell '()' 中，以防它仍然包含 exit 命令
(bash script/install.sh --docker n --cli n --proxy 0)



echo " [testuser] DEBUG: Reached after install.sh, continuing..."



QQ_EXECUTABLE="$HOME/Napcat/opt/QQ/qq"
if [ ! -f "$QQ_EXECUTABLE" ]; then
    echo "Verification failed: QQ executable not found: $QQ_EXECUTABLE"
    exit 1
fi

echo " [testuser] DEBUG: QQ executable found, starting screen session... "
# 日志放在用户目录下：/tmp 有 protected_regular 限制，换用户后写不进别人建的同名文件
QQ_LOG="$HOME/qq.log"
screen -dmS napcat bash -c "xvfb-run -a \"$QQ_EXECUTABLE\" --no-sandbox > \"$QQ_LOG\" 2>&1"

# 等 NapCat 打出 WebUI 地址，说明 QQ 启动并成功加载了 NapCat
echo " [testuser] Waiting up to 60s for NapCat WebUI address in log "
found=0
for i in $(seq 1 60); do
    if grep -q 'http://127.0.0.1:6099' "$QQ_LOG" 2>/dev/null; then
        found=1
        echo " [testuser] NapCat WebUI address found after ${i}s "
        break
    fi
    sleep 1
done

echo "--- QQ Log Output (Last 50 lines) ---"
tail -n 50 "$QQ_LOG" 2>/dev/null || echo "Log file $QQ_LOG not found."
echo "-------------------------------------"

screen -S napcat -X quit || true
sleep 3
pkill -f "Xvfb" || true

if [ "$found" != 1 ]; then
    echo " [testuser] Ubuntu CI test failed: NapCat server address not found."
    exit 1
fi
EOF

echo " [ROOT] Ubuntu CI test successful: NapCat server started. "
