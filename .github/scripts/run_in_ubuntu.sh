#!/bin/bash
set -eu

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git sudo procps findutils passwd
useradd -m -s /bin/bash testuser
printf '%s\n' 'testuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/testuser
chmod 440 /etc/sudoers.d/testuser
mkdir -p /home/testuser/napcat-ci
cp -a script /home/testuser/napcat-ci/
chown -R testuser:testuser /home/testuser/napcat-ci

sudo -u testuser -i bash -s <<'EOF'
set -eu
cd /home/testuser/napcat-ci
bash script/install.sh --docker n --cli n --github-proxy 0
qq_executable="$HOME/Napcat/opt/QQ/qq"
test -x "$qq_executable"
ulimit -c 0
set +e
timeout --kill-after=5s 30s xvfb-run -a "$qq_executable" --no-sandbox > "$HOME/qq.log" 2>&1
status=$?
set -e
test "$status" -eq 124
grep -F 'NapCat.Core Version:' "$HOME/qq.log"
grep -F '[PacketHandler] 初始化成功' "$HOME/qq.log"
grep -F '[Napi2NativeLoader] 加载成功' "$HOME/qq.log"
grep -F '使用 Native Addon 适配器' "$HOME/qq.log"
EOF

printf 'Ubuntu installation and native runtime: passed\n'
