import requests
import socket
import json

# Moonraker 的 API 地址
moonraker_api = "http://localhost:7125"

# 构造请求的数据
data = {
    "command": "printer.gcode.script",
    "script": f"firmware_restart"
}

# 发送请求
response = requests.post(f"{moonraker_api}/printer/gcode/script", json=data)

# 检查响应
if response.status_code == 200:
    print("firmware_restart successfully")
else:
    print(f"Failed to firmware_restart")

