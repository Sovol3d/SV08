import requests
import socket
import json

def get_ip_address():
    """获取本机的 IP 地址"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # 不需要实际发送数据
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

# Moonraker 的 API 地址
moonraker_api = "http://localhost:7125"

# 获取 IP 地址
ip_address = get_ip_address()

# 构造请求的数据
data = {
    "command": "printer.gcode.script",
    "script": f"M117 {ip_address}"
}

# 发送请求
response = requests.post(f"{moonraker_api}/printer/gcode/script", json=data)

# 检查响应
if response.status_code == 200:
    print("IP address sent successfully")
else:
    print(f"Failed to send IP address: {response.text}")

