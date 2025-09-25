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
# 使用 screen 后台运行，并写入统一日志
screen -dmS napcat bash -c "xvfb-run -a \"$QQ_EXECUTABLE\" --no-sandbox > /tmp/qq.log 2>&1"

# 轮询等待进程或失败
echo " [testuser] Waiting up to 25s for process to come up "
for i in $(seq 1 25); do
    if pgrep -u "$(whoami)" -f "$QQ_EXECUTABLE" >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

echo "--- QQ Log Output (Last 50 lines) ---"
if [ -f /tmp/qq.log ]; then
    tail -n 50 /tmp/qq.log
else
    echo "Log file /tmp/qq.log not found."
fi
echo "-------------------------------------"

echo " [testuser] Verifying if the 'qq' process is running "
if pgrep -u "$(whoami)" -f "$QQ_EXECUTABLE" >/dev/null 2>&1; then
    echo "Verification successful: QQ process is running."
    echo " [testuser] Cleaning up (terminate screen session) "
    screen -S napcat -X quit || true
    sleep 3
    pkill -f "Xvfb" || true
else
    echo "Verification failed: QQ process is NOT running."
    echo "--- Final QQ Log (Last 100 lines) ---"
    [ -f /tmp/qq.log ] && tail -n 100 /tmp/qq.log || echo "No log."
    screen -S napcat -X quit || true
    pkill -f "Xvfb" || true
    exit 1
fi
EOF

echo " [ROOT] Ubuntu CI test successful "
echo " [ROOT] Ubuntu CI test successful "
screen -dmS napcat bash -c "xvfb-run -a /home/testuser/Napcat/opt/QQ/qq --no-sandbox > /tmp/qq.log 2>&1"

echo " [testuser] Waiting for QQ to start (15s)..."
sleep 15

echo " [testuser] Checking for NapCat server address in logs..."
if grep -q 'http://127.0.0.1:6099' /tmp/qq.log; then
    echo " [testuser] Ubuntu CI test successful: NapCat server started."
else
    echo " [testuser] Ubuntu CI test failed: NapCat server address not found."
    echo " [testuser] Displaying logs:"
    cat /tmp/qq.log
    exit 1
fi