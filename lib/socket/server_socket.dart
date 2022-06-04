import 'dart:io';
import 'dart:convert';

late ServerSocket mysocket;

bool isContinueSendSteam = false; //是否可以发送Steam

Future<void> socketBind(String ip, int port) async {
  print('Socket绑定IP $ip : $port');
  mysocket = await ServerSocket.bind(ip, port);

  mysocket.listen((socket) {
    var tmpData = "";
    print('连接socket');
    socket.cast<List<int>>().transform(utf8.decoder).listen((s) {
      // tmpData = doParseResultJson(socket, tmpData, s);
      print(s);
      socket.write("test");
    });
  });
}
