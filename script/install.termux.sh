#!/bin/bash

clear

MAGENTA='\033[0;1;35;95m'
RED='\033[0;1;31;91m'
GREEN='\033[0;1;32;92m'
NC='\033[0m'

execute_command() {
    echo -e "${2}中...${NC}"
    $1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$2 成功${NC}"
    else
        echo -e "${RED}$2 失败${NC}"
        exit 1
    fi
}

execute_command "pkg update -y && pkg install -y proot-distro screen" "准备proot-distro环境"
execute_command "proot-distro install debian --override-alias napcat" "安装napcat容器"

echo -e "${GREEN}正在初始化napcat容器...${NC}"
init_cmd="apt update -y && \
apt install -y sudo curl && \
curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && \
sudo bash napcat.sh --docker n --proot y && \
apt autoremove -y && \
apt clean && \
rm -rf /tmp/* /var/lib/apt/lists"
proot-distro sh napcat -- bash -c "$init_cmd"
if [ $? -ne 0 ]; then
    proot-distro remove napcat
    echo -e "${RED}napcat容器初始化失败。${NC}"
    exit 1
fi
echo -e "${RED}napcat容器安装成功, 上方无效信息无需关注, 请参考下方说明⬇${NC}"

echo -e "\n安装完成, 请输入${GREEN} proot-distro sh napcat -- bash -c \"xvfb-run -a qq --no-sandbox\" ${NC}命令启动。"
echo -e "保持后台运行 请输入${GREEN} screen -dmS napcat bash -c 'proot-distro sh napcat -- bash -c \"xvfb-run -a qq --no-sandbox\"'${NC}"
echo -e "后台快速登录 请输入${GREEN} screen -dmS napcat bash -c 'proot-distro sh napcat -- bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\"'${NC}"
echo -e "进入容器内部 请输入${GREEN} proot-distro login napcat ${NC}"
echo -e "容器数据位置${MAGENTA} /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/napcat${NC}"
echo -e "Napcat安装位置(容器外真实路径)${MAGENTA} /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/napcat/opt/QQ/resources/app/app_launcher/napcat${NC}"
echo -e "注意, 您可以随时使用${GREEN}screen -r napcat${NC}来进入后台进程并使用${GREEN}ctrl + a + d${NC}离开(离开不会关闭后台进程)。"
echo -e "${GREEN}WEB_UI访问密钥在上方信息中${NC}"