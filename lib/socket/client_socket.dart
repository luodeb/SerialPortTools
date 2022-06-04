import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'socket_data.dart';

late Socket mysocket;
ClientSocket myclient=ClientSocket();

class ClientSocket {
  Future<void> connect(String ip, int port) async {
    try {
      mysocket = await Socket.connect(ip, port);
      mysocket.cast<List<int>>().transform(utf8.decoder).listen((s) async {
        print(s);
      });

      sendMessage('{"func":"scan"}');
    } catch (e) {
      print("连接socket出现异常,e=${e.toString()}");
    }
  }

  void sendMessage(String message) {
    mysocket.write(message);
  }

  void clientScan() {
    // 扫描串口
    var jsonData = jsonDecode('{"func":"scan"}');
    sendMessage(jsonEncode(jsonData));
  }

  void clientSendData(String comName, String data) {

  }
}
