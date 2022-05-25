# 串口调试助手

## 说明

厦门大学高级编程技术课程大作业 使用Dart实现的跨平台串口调试助手应用。

## 运行前提

 - 需要按照网上配置好dart环境
 - 安装好[git](https://git-scm.com/)
 - 安装好MX虚拟串口软件，使用里面的注册机激活
 - 使用```git clone https://gitee.com/luodeb/serial-port-tools.git```克隆项目

## 运行

查看bin文件夹下的serial_port_tools.dart文件，这里我使用的COM10，所以我们创建串口对COM10-COM11

![README-2022-05-25-17-25-44](https://imgfiles-debin.oss-cn-hangzhou.aliyuncs.com/md_imgfiles/README-2022-05-25-17-25-44.png)

打开串口调试助手，打开COM11
![README-2022-05-25-17-27-01](https://imgfiles-debin.oss-cn-hangzhou.aliyuncs.com/md_imgfiles/README-2022-05-25-17-27-01.png)

然后在项目的根目录运行```dart run```就可以了。

## 需求（后端部分）

### serialPort类编写

名称：class serialPort 
功能：
 - .comName 端口号
 - .comBind 波特率
 - ...其他参数待定
 - .send(data) 向串口发送uint8List数据
 - .connect(comName) 连接串口
 - .disconnect() 断开当前串口
 - .check() return portList 返回串口列表
 - .recive() return data 接收uint8List数据

### socket类编写

名称：class serialSocket
功能：
 - .address IP地址，默认为localhost
 - .localPort 本地端口号
 - .remotePort 远程端口号
 - .initSocket() 初始化socket
 - .send(jsonData) 发送json数据
 - .recive() return jsonData接收数据

### 通讯协议

名称：class serialProtocol()
功能：
 - .pack(data) return jsonData将uint8List数据打包成socket发送的json数据
 - .unpack(jsonData) 根据接收到的数据解析socket需要发送的数据
设计：
需要设计相应的通讯协议。例如
``` json
// 扫描串口
{
    "function":"scan",
    "type":{
        "comName":"COM10",
        "comMess":"ELTIMA Virtual Serial Port",
    },
    "type":{
        "comName":"COM11",
        "comMess":"ELTIMA Virtual Serial Port",
    },
}

// 连接串口COM10
{
    "function":"connect",
    "type":{
        "comName":"COM10",
        "comBind":115200,
    },
}

// 向串口10发送数据1415926
{
    "function":"send",
    "type":{
        "comName":"COM10",
        "comBind":115200,
    },
    "data":"1415926",
}
```
