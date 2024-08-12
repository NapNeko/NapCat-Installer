#!/bin/bash

echo "正在准备proot-distro环境..."
apt update -y
apt install -y proot-distro screen
if [ $? -ne 0 ]; then
    echo "proot-distro环境准备失败。"
    exit 1
fi

echo "正在安装napcat容器..."
proot-distro install debian --override-alias napcat
if [ $? -ne 0 ]; then
    echo "napcat容器安装失败。"
    exit 1
fi

echo "正在初始化napcat容器..."
init_cmd="apt update -y && \
apt install -y sudo curl && \
curl -o napcat.sh https://cdn.jsdelivr.net/gh/NapNeko/NapCat-Installer@main/script/install.sh && \
sudo bash napcat.sh --docker n && \
apt autoremove -y && \
apt clean && \
rm -rf /tmp/* /var/lib/apt/lists"
proot-distro sh napcat -- bash -c "$init_cmd"
if [ $? -ne 0 ]; then
    proot-distro remove napcat
    echo "napcat容器初始化失败。"
    exit 1
fi
echo "napcat容器安装成功, 上方无效信息无需关注, 请参考下方说明⬇"

echo -e "\n安装完成，请输入 proot-distro sh napcat -- bash -c \"xvfb-run -a qq --no-sandbox\" 命令启动。"
echo "保持后台运行 请输入 screen -dmS napcat bash -c 'proot-distro sh napcat -- bash -c \"xvfb-run -a qq --no-sandbox\"'"
echo "后台快速登录 请输入 screen -dmS napcat bash -c 'proot-distro sh napcat -- bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\"'"
echo "进入容器内部 请输入 proot-distro login napcat"
echo "容器数据位置 /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/napcat"
echo "Napcat安装位置(容器外真实路径) /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/napcat/opt/QQ/resources/app/app_launcher/napcat"
echo "注意，您可以随时使用screen -r napcat来进入后台进程并使用ctrl + a + d离开(离开不会关闭后台进程)。"
