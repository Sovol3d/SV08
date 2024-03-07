#!/bin/bash

# 获取 IP 地址
#IP_ADDRESS=$(hostname -I | cut -d' ' -f1)

# 定义文件路径
#FILE_PATH="/home/sovol/printer_data/gcodes/$IP_ADDRESS"

# 创建或更新文件
#touch "$FILE_PATH"

python3 /home/sovol/send_ip.py

