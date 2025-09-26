#!/bin/bash
# 当任何命令失败时立即退出
set -e

echo " [ROOT] Installing dependencies inside AlmaLinux container "
dnf install -y git sudo procps-ng findutils shadow-utils

echo " [ROOT] Creating test user 'testuser' "
useradd -m -s /bin/bash testuser

echo " [ROOT] Configuring passwordless sudo for 'testuser' "
echo 'testuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/testuser
chmod 440 /etc/sudoers.d/testuser

echo " [ROOT] Changing repository ownership to 'testuser' "
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

(bash script/install.sh --docker n --cli n --proxy 0)

QQ_EXECUTABLE="$HOME/Napcat/opt/QQ/qq"
echo " [testuser] Verifying installation by running the application "

if [ ! -f "$QQ_EXECUTABLE" ]; then
    echo "Verification failed: QQ executable not found at $QQ_EXECUTABLE"
    exit 1
fi

echo " [testuser] Starting QQ with xvfb-run in the background "
# 添加 --no-sandbox 参数
xvfb-run -a "$QQ_EXECUTABLE" --no-sandbox > /tmp/qq.log 2>&1 &

echo " [testuser] Waiting 20 seconds for application to stabilize or crash "
sleep 20

echo " [testuser] Verifying if the 'qq' process is running "
if pgrep -u "$(whoami)" -f "$QQ_EXECUTABLE"; then
    echo "Verification successful: QQ process is running."
    echo " [testuser] Cleaning up running processes "
    pkill -u "$(whoami)" -f "$QQ_EXECUTABLE"
    sleep 5
    pkill -f "Xvfb" || true
else
    echo "Verification failed: QQ process is NOT running. It may have crashed."
    echo " QQ Log Output "
    cat /tmp/qq.log || echo "Log file not found."
    pkill -f "Xvfb" || true
    exit 1
fi
EOF

echo " [ROOT] AlmaLinux CI test successful "