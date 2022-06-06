import json
import time
from typing import final
import serial
import serial.tools.list_ports
import socket
from threading import Thread

from sympy import E

class SerialPort(object):
    def __init__(self): 
        self.ser = serial.Serial()

    # 串口检测
    def portCheck(self):
        port_list = list(serial.tools.list_ports.comports())
        comscan_str = ''
        for i in range(len(port_list)):
            comscan_str += ',{' if i else '{'
            comscan_str += '"name":"%s","mess":"%s"}' % (port_list[i][0],{port_list[i][1]})
        return '{"func":"scan","comNum":%s,"com":[%s]}' % (len(port_list),comscan_str)

    def openSer(self,json_data):
        self.ser.port = json_data['com']['name']
        # self.ser.baudrate = int(json_data['com']['baud'])
        # self.ser.stopbits = int(json_data['com']['stopBit'])
        # self.ser.parity = int(json_data['com']['parity'])
        # self.ser.bytesize = int(json_data['com']['check'])

        try:
            self.ser.open()
            print("打开串口成功")
            return '{"func":"connect","status":"true"}'
        except:
            print("打开串口失败")
            return '{"func":"connect","status":"false"}'

    def closeSer(self):
        if self.ser.isOpen():
            try:
                self.ser.close()
                print("关闭串口成功")
                return '{"func":"disconnect","status":"true"}'
            except:
                print("关闭串口失败")
                return '{"func":"disconnect","status":"false"}'
        else:
            return '{"func":"disconnect","status":"true"}'

    def sendMessage(self,json_data):
        if self.ser.is_open:
            self.ser.write(json_data['data'].encode('iso-8859-1'))

    def recvData(self):
        try:
            num = self.ser.inWaiting()
        except:
            num = 0
            self.ser.close()
        if num > 0:
            self.recv_data = self.ser.read(num)
            return True
        else:
            return False
            
def recvDataLoop(sp,conn):
    while True:
        if sp.ser.isOpen():
            if sp.recvData():
                send_json = '{"func":"send","com":[{"name":"%s"}],"data":"%s"}' % (sp.ser.port,sp.recv_data.decode('iso-8859-1'))
                conn.send(send_json.encode('iso-8859-1'))

def main():
    sk = socket.socket()
    sk.bind(('127.0.0.1', 4049))
    print("启动程序  127.0.0.1:4049")
    sk.listen()
    try:
        while True:
            conn, addr = sk.accept()
            sp = SerialPort()
            th = Thread(target = recvDataLoop,args=(sp,conn))
            th.start()

            # try:
            while True:
                recv = conn.recv(1024).decode()
                data_map = json.loads(recv)
                print(data_map)
                if data_map['func']=='scan':
                    conn.send(sp.portCheck().encode('iso-8859-1'))
                elif data_map['func']=='connect':
                    conn.send(sp.openSer(data_map).encode('iso-8859-1'))
                elif data_map['func']=='disconnect':
                    conn.send(sp.closeSer().encode('iso-8859-1'))
                elif data_map['func']=='send':
                    sp.sendMessage(data_map)
            # except:
            #     print("连接丢失")
            #     conn.close()
    finally:
        sk.close() 

if __name__ == '__main__':
    main()