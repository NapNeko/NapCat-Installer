import os
import subprocess
import sys
import json
import requests

def get_system_arch():
    arch = subprocess.check_output(['uname', '-m']).decode().strip()
    return arch.replace('aarch64', 'arm64').replace('x86_64', 'amd64')

def network_test(parm1, proxy_num=9):
    proxy_arr = []
    check_url = ""
    if parm1 == "Github":
        proxy_arr = ["https://github.moeyy.xyz", "https://mirror.ghproxy.com", "https://gh-proxy.com", "https://x.haod.me"]
        check_url = "https://raw.githubusercontent.com/NapNeko/NapCatQQ/main/package.json"
    else:
        proxy_arr = ["docker.1panel.dev", "dockerpull.com", "dockerproxy.cn", "docker.agsvpt.work", "docker.agsv.top", "docker.registry.cyou"]
    
    target_proxy = ""
    if 1 <= proxy_num <= len(proxy_arr):
        target_proxy = proxy_arr[proxy_num - 1]
    else:
        for proxy in proxy_arr:
            status = requests.head(f"{proxy}/{check_url}").status_code
            if parm1 == "Github" and status == 200:
                target_proxy = proxy
                break
            elif parm1 == "Docker" and (status == 200 or status == 301):
                target_proxy = proxy
                break
        if not target_proxy:
            print(f"无法连接到{parm1}，请检查网络。")
            sys.exit(1)
    return target_proxy

def generate_docker_command(qq, mode, target_proxy):
    docker_cmd1 = f"sudo docker run -d -e ACCOUNT={qq}"
    docker_cmd2 = f"--privileged --name napcat --restart=always {target_proxy}/mlikiowa/napcat-docker:latest"
    docker_ws = f"{docker_cmd1} -e WS_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -p 3001:3001 -p 6099:6099 {docker_cmd2}"
    docker_reverse_ws = f"{docker_cmd1} -e WSR_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -e WS_URLS='[]' -p 6099:6099 {docker_cmd2}"
    docker_reverse_http = f"{docker_cmd1} -e HTTP_ENABLE=true -e NAPCAT_GID=$(id -g) -e NAPCAT_UID=$(id -u) -e HTTP_POST_ENABLE=true -e HTTP_URLS='[]' -p 3000:3000 -p 6099:6099 {docker_cmd2}"
    if mode == "ws":
        return docker_ws
    elif mode == "reverse_ws":
        return docker_reverse_ws
    elif mode == "reverse_http":
        return docker_reverse_http
    else:
        sys.exit(1)

def detect_package_manager():
    if subprocess.call(['which', 'apt'], stdout=subprocess.DEVNULL) == 0:
        return "apt"
    elif subprocess.call(['which', 'yum'], stdout=subprocess.DEVNULL) == 0:
        return "yum"
    else:
        return "none"

def detect_package_installer():
    if subprocess.call(['which', 'dpkg'], stdout=subprocess.DEVNULL) == 0:
        return "dpkg"
    elif subprocess.call(['which', 'rpm'], stdout=subprocess.DEVNULL) == 0:
        return "rpm"
    else:
        return "none"

def check_docker():
    return subprocess.call(['which', 'docker'], stdout=subprocess.DEVNULL) == 0

def install_docker():
    subprocess.run(['sudo', 'apt', 'update', '-y'])
    subprocess.run(['sudo', 'apt', 'install', '-y', 'curl'])
    subprocess.run(['sudo', 'curl', '-fsSL', 'https://nclatest.znin.net/docker_install_script', '-o', 'get-docker.sh'])
    subprocess.run(['sudo', 'chmod', '+x', 'get-docker.sh'])
    subprocess.run(['sudo', 'sh', 'get-docker.sh'])

def update_linuxqq_config(target_ver, build_id):
    confs = subprocess.check_output(['sudo', 'find', '/home', '-name', 'config.json', '-path', '*/.config/QQ/versions/*']).decode().split()
    if os.path.exists('/root/.config/QQ/versions/config.json'):
        confs.append('/root/.config/QQ/versions/config.json')
    for conf in confs:
        with open(conf, 'r+') as f:
            data = json.load(f)
            data['baseVersion'] = target_ver
            data['curVersion'] = target_ver
            data['buildId'] = build_id
            f.seek(0)
            json.dump(data, f, indent=4)
            f.truncate()

def modify_qq_config():
    index_path = "./loadNapCat.js"
    package_path = "/opt/QQ/resources/app/package.json"
    with open(package_path, 'r+') as f:
        data = json.load(f)
        data['main'] = index_path
        f.seek(0)
        json.dump(data, f, indent=4)
        f.truncate()

def get_qq_target_version():
    response = requests.get("https://nclatest.znin.net/get_qq_ver").json()
    return response['linuxVersion'], response['linuxVerHash']

def install_linuxqq(package_target_ver, package_target_ver_hash, system_arch, package_installer):
    base_url = f"https://dldir1.qq.com/qqfile/qq/QQNT/{package_target_ver_hash}/linuxqq_{package_target_ver}"
    qq_download_url = ""
    if system_arch == "amd64":
        if package_installer == "rpm":
            qq_download_url = f"{base_url}_x86_64.rpm"
        elif package_installer == "dpkg":
            qq_download_url = f"{base_url}_amd64.deb"
    elif system_arch == "arm64":
        if package_installer == "rpm":
            qq_download_url = f"{base_url}_aarch64.rpm"
        elif package_installer == "dpkg":
            qq_download_url = f"{base_url}_arm64.deb"
    
    if not qq_download_url:
        print("无法下载QQ，请检查错误。")
        sys.exit(1)
    
    if package_installer == "yum":
        subprocess.run(['sudo', 'curl', '-L', qq_download_url, '-o', 'QQ.rpm'])
        subprocess.run(['sudo', 'yum', 'localinstall', '-y', './QQ.rpm'])
        os.remove('QQ.rpm')
    elif package_installer == "apt":
        subprocess.run(['sudo', 'curl', '-L', qq_download_url, '-o', 'QQ.deb'])
        subprocess.run(['sudo', 'apt', 'install', '-f', '-y', './QQ.deb'])
        subprocess.run(['sudo', 'apt', 'install', '-y', 'libnss3', 'libgbm1', 'libasound2'])
        os.remove('QQ.deb')
    
    update_linuxqq_config(package_target_ver, package_target_ver_hash)

def clean():
    subprocess.run(['rm', '-rf', './NapCat/', './tmp/', './NapCat.Shell.zip'])

def install_napcat(napcat_download_url, target_folder):
    subprocess.run(['sudo', 'curl', '-L', napcat_download_url, '-o', 'NapCat.Shell.zip'])
    subprocess.run(['mkdir', './NapCat/', './tmp/'])
    subprocess.run(['unzip', '-q', '-o', '-d', './tmp/NapCat.Shell', 'NapCat.Shell.zip'])
    if not os.path.exists(f"{target_folder}/napcat"):
        os.makedirs(f"{target_folder}/napcat")
    subprocess.run(['sudo', 'cp', '-r', '-f', './tmp/NapCat.Shell/*', f"{target_folder}/napcat/"])
    subprocess.run(['sudo', 'chmod', '-R', '777', f"{target_folder}/napcat/"])
    with open('/opt/QQ/resources/app/loadNapCat.js', 'w') as f:
        f.write(f"(async () => {{await import('file:///{target_folder}/napcat/napcat.mjs');}})();")
    clean()

def main():
    if not subprocess.call(['which', 'sudo'], stdout=subprocess.DEVNULL) == 0:
        print("sudo不存在, 请手动安装: \n Centos: yum install -y sudo\n Debian/Ubuntu: apt install -y sudo\n")
        sys.exit(1)
    
    sudo_id_output = subprocess.check_output(['sudo', 'whoami']).decode().strip()
    if sudo_id_output != "root":
        print("当前用户不是root用户，请将此用户加入sudo group后再试。")
        sys.exit(1)
    
    use_docker = input("是否使用Docker安装？(y/n): ").strip()
    if use_docker == "y":
        if not check_docker():
            install_docker()
        if check_docker():
            print("Docker已安装")
        else:
            print("Docker安装失败")
            sys.exit(1)
        
        qq = input("请输入QQ号：").strip()
        mode = input("请选择模式（ws/reverse_ws/reverse_http）: ").strip()
        target_proxy = network_test("Docker")
        docker_command = generate_docker_command(qq, mode, target_proxy)
        confirm = input(f"即将执行以下命令：{docker_command}\n是否继续？(y/n): ").strip()
        if confirm.lower() == 'y':
            subprocess.run(docker_command, shell=True)
            print("安装成功")
        else:
            print("安装取消")
        sys.exit(0)
    elif use_docker == "n":
        print("不使用Docker安装")
    else:
        print("输入错误，请重新安装")
        sys.exit(1)
    
    system_arch = get_system_arch()
    if system_arch == "none":
        print("无法识别的系统架构，请检查错误。")
        sys.exit(1)
    print(f"当前系统架构：{system_arch}")
    
    package_manager = detect_package_manager()
    if package_manager == "apt":
        subprocess.run(['sudo', 'apt', 'update', '-y'])
        subprocess.run(['sudo', 'apt', 'install', '-y', 'zip', 'unzip', 'jq', 'curl', 'xvfb', 'screen'])
    elif package_manager == "yum":
        subprocess.run(['sudo', 'yum', 'install', '-y', 'epel-release'])
        subprocess.run(['sudo', 'yum', 'install', '-y', 'zip', 'unzip', 'jq', 'curl', 'xorg-x11-server-Xvfb', 'screen'])
    else:
        print("包管理器检查失败，目前仅支持apt/yum。")
        sys.exit(1)
    
    remote_qq_info = get_qq_target_version()
    package_target_ver, package_target_ver_hash = remote_qq_info
    target_build = package_target_ver.split('-')[-1]
    package_installer = detect_package_installer()
    
    if package_installer == "rpm":
        if subprocess.call(['rpm', '-q', 'linuxqq'], stdout=subprocess.DEVNULL) == 0:
            version = subprocess.check_output(['rpm', '-q', '--queryformat', '%{VERSION}', 'linuxqq']).decode().strip()
            installed_build = version.split('-')[-1]
            if int(installed_build) < int(target_build):
                install_linuxqq(package_target_ver, package_target_ver_hash, system_arch, package_installer)
            else:
                update_linuxqq_config(version, installed_build)
        else:
            install_linuxqq(package_target_ver, package_target_ver_hash, system_arch, package_installer)
    elif package_installer == "dpkg":
        if subprocess.call(['dpkg', '-l', 'linuxqq'], stdout=subprocess.DEVNULL) == 0:
            version = subprocess.check_output(['dpkg', '-l', 'linuxqq']).decode().strip().split()[-1]
            installed_build = version.split('-')[-1]
            if int(installed_build) < int(target_build):
                install_linuxqq(package_target_ver, package_target_ver_hash, system_arch, package_installer)
            else:
                update_linuxqq_config(version, installed_build)
        else:
            install_linuxqq(package_target_ver, package_target_ver_hash, system_arch, package_installer)
    
    modify_qq_config()
    
    napcat_version = requests.get("https://nclatest.znin.net/").json()['tag_name']
    target_folder = "/opt/QQ/resources/app/app_launcher"
    napcat_download_url = f"https://github.com/NapNeko/NapCatQQ/releases/download/{napcat_version}/NapCat.Shell.zip"
    
    if os.path.exists(f"{target_folder}/napcat"):
        current_version = json.load(open(f"{target_folder}/napcat/package.json"))['version']
        target_version = napcat_version.lstrip('v')
        if tuple(map(int, current_version.split('.'))) < tuple(map(int, target_version.split('.'))):
            install_napcat(napcat_download_url, target_folder)
        else:
            print("已安装最新版本，无需更新。")
    else:
        install_napcat(napcat_download_url, target_folder)
    
    print("\n安装完成，请输入 xvfb-run -a qq --no-sandbox 命令启动。")
    print("保持后台运行 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox\"")
    print("后台快速登录 请输入 screen -dmS napcat bash -c \"xvfb-run -a qq --no-sandbox -q QQ号码\"")
    print(f"Napcat安装位置 {target_folder}/napcat")
    print("注意，您可以随时使用screen -r napcat来进入后台进程并使用ctrl + a + d离开(离开不会关闭后台进程)。")

if __name__ == "__main__":
    main()