import serial
import time

# 打开串口
ser = serial.Serial('/dev/ttyS3', 9600, timeout=1)

# 发送数据
ser.write(b'Hello!\n')

# 等待一会儿，确保数据发送完成
time.sleep(1)

# 读取数据
received_data = ser.read(100)  # 读取100个字节的数据

# 打印接收到的数据
print('read:' + received_data.decode())

# 关闭串口
ser.close()

