import 'dart:async';
import 'dart:io';
import 'dart:convert';
 
/**
 * Author: Jonny Zheng 270406@qq.com
 * 
 * 测试客户端，发送一个JSON串到服务器，为模拟真实环境，采用分步发送的方式进行
 * 每隔1秒就发送一小段代码
 */
void connectserver() {
  Socket.connect('127.0.0.1', 4041).then((socket) async{
 
    //旧版用这行 2021-12-31 更新 
    //socket.transform(utf8.decoder).listen(print);
 
    //新版用这行 2021-12-31 更新 参考：https://blog.csdn.net/yangshuaionline/article/details/96002764
    socket.cast<List<int>>().transform(utf8.decoder).listen(print);
 
    // socket.transform(utf8.decoder).listen(print);
    socket.write('{"cmd":"current time"');
    await Future.delayed(const Duration(seconds: 1));
    socket.write(',"params":{"region":"北京"}}');
    await Future.delayed(const Duration(seconds: 1));
    socket.write('{"cmd":"current time"');
    await Future.delayed(const Duration(seconds: 1));
    socket.write(',"params":{"region":"伦敦"}}{"cmd":"XX"}');
    await Future.delayed(const Duration(seconds: 1));
    socket.write('{}}{');
    await Future.delayed(const Duration(seconds: 1));
    socket.write('"cmd":"天气"}');
  });
}
 
void main(){
  connectserver();
}