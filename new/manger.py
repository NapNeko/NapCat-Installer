import os
import zipfile
import requests
import threading

# 下载镜像列表
GH_DOWNLOAD_MIRROR_NAPCAT = [
    "https://github.moeyy.xyz/https://github.com/NapNeko/NapCatQQ/releases/latest/download/NapCat.Shell.zip",
    "https://ghp.ci/https://github.com/NapNeko/NapCatQQ/releases/latest/download/NapCat.Shell.zip",
    "https://gh.api.99988866.xyz/https://github.com/NapNeko/NapCatQQ/releases/latest/download/NapCat.Shell.zip"
]

GH_DOWNLOAD_MIRROR_PACKET = [
    "https://github.moeyy.xyz/https://github.com/NapNeko/NapCatQQ/releases/latest/download/napcat.packet.production.py",
    "https://ghp.ci/https://github.com/NapNeko/NapCatQQ/releases/latest/download/napcat.packet.production.py",
    "https://gh.api.99988866.xyz/https://github.com/NapNeko/NapCatQQ/releases/latest/download/napcat.packet.production.py"
]

class MultiThreadDownloader:
    def __init__(self, url, dest_folder, filename=None, num_threads=4):
        self.url = url
        self.dest_folder = dest_folder
        self.num_threads = num_threads
        self.local_filename = os.path.join(dest_folder, filename if filename else url.split('/')[-1])
        self.progress = [False] * num_threads
        self.chunks = [None] * num_threads
        self.total_downloaded = 0
        self.total_length = 0
        self.lock = threading.Lock()

    def download_chunk(self, start, end, index):
        """
        下载文件的一个块
        """
        headers = {'Range': f'bytes={start}-{end}'}
        response = requests.get(self.url, headers=headers, stream=True)
        self.chunks[index] = response.content
        with self.lock:
            self.total_downloaded += len(response.content)
            self.print_progress()
        self.progress[index] = True

    def get_file_size(self):
        """
        获取文件大小
        """
        response = requests.head(self.url, allow_redirects=True)
        if response.status_code != 200:
            print("[Download] 无法获取文件大小，无法下载")
            return None
        return int(response.headers.get('content-length'))

    def create_download_threads(self):
        """
        创建下载线程
        """
        chunk_size = self.total_length // self.num_threads
        threads = []
        for i in range(self.num_threads):
            start = i * chunk_size
            end = start + chunk_size - 1 if i < self.num_threads - 1 else self.total_length - 1
            thread = threading.Thread(target=self.download_chunk, args=(start, end, i))
            threads.append(thread)
            thread.start()
        return threads

    def print_progress(self):
        """
        打印下载进度
        """
        percent = (self.total_downloaded / self.total_length) * 100
        print(f"[Download] 下载进度: {percent:.2f}%")

    def download_file(self):
        """
        多线程下载文件
        """
        try:
            self.total_length = self.get_file_size()
            if self.total_length is None:
                return False
            
            threads = self.create_download_threads()
            
            for thread in threads:
                thread.join()
            
            # 检查所有块是否下载完成
            if all(self.progress):
                # 合并所有块
                with open(self.local_filename, 'wb') as f:
                    for chunk in self.chunks:
                        f.write(chunk)
                print(f"[Download] 文件下载并合并完成: {self.local_filename}")
                return True
            else:
                print("[Download] 下载过程中有块未完成")
                return False
        except Exception as e:
            print(f"[Download] 下载过程中出现错误: {e}")
            return False

def is_zipfile(filename):
    """
    检查文件是否为ZIP文件
    """
    return zipfile.is_zipfile(filename)

def extract_zipfile(filename, extract_to):
    """
    解压ZIP文件到指定目录
    """
    with zipfile.ZipFile(filename, 'r') as zip_ref:
        zip_ref.extractall(extract_to)

def try_download_zip_from_mirrors(mirror_list, filename, dest_folder):
    """
    尝试从多个镜像下载文件
    """
    for url in mirror_list:
        print(f"[Mirror] 尝试下载: {url}")
        try:
            downloader = MultiThreadDownloader(url, dest_folder, filename)
            if downloader.download_file():
                local_filename = downloader.local_filename
                print(f"[Mirror] 成功下载: {local_filename}")
                
                if is_zipfile(local_filename):
                    print(f"[Mirror] 文件 {local_filename} 是一个有效的压缩文件")
                    extract_zipfile(local_filename, dest_folder)
                    print(f"[Mirror] 文件已成功解压到: {dest_folder}")
                    return True
                else:
                    print(f"[Mirror] 文件 {local_filename} 不是一个有效的压缩文件")
            else:
                print(f"[Mirror] 下载失败: {url}")
        except Exception as e:
            print(f"[Mirror] 下载 {url} 时出现错误: {e}")
            continue  # 尝试下一个镜像
    return False

def try_download_normal_from_mirrors(mirror_list, filename, dest_folder):
    """
    尝试从多个镜像下载普通文件
    """
    for url in mirror_list:
        print(f"[Mirror] 尝试下载: {url}")
        try:
            downloader = MultiThreadDownloader(url, dest_folder, filename)
            if downloader.download_file():
                local_filename = downloader.local_filename
                print(f"[Mirror] 成功下载: {local_filename}")
                return True
            else:
                print(f"[Mirror] 下载失败: {url}")
        except Exception as e:
            print(f"[Mirror] 下载 {url} 时出现错误: {e}")
            continue  # 尝试下一个镜像
    return False

def print_napcat():
    print("===== NapCatQQ =====")
    print("0. 一键安装到本机")
    print("1. 修复QQ无法引导NapCat")
    print("2. 安装NapCatQQ Packet")
    print("3. 强制写入 NT QQ版本")
    print("4. 退出")
    print("====================")

def install_pip_packet(packet_name):
    os.system(f"pip install {packet_name}")

def handler():
    while True:
        choice = input("请输入你的选择: ")
        if choice == '0':
            print("[Main] NapCatQQ 安装失败")
        elif choice == '1':
            print("[Main] 修复QQ无法引导NapCat功能尚未实现")
        elif choice == '2':
            print("[Main] NapCatQQ Packet 安装失败")
        elif choice == '3':
            print("[Main] 强制写入 NT QQ版本功能尚未实现")
        elif choice == '4':
            print("[Main] 退出")
            break
        else:
            print("[Main] 无效的选择，请重新输入")

if __name__ == "__main__":
    print_napcat()
    handler()