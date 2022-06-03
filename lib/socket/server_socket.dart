// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';
// import 'package:serial_port_tools/serial_port_tools.dart';

class GlobalSerialPort {
  static late SerialPort port;
}

void serverMain() async{
  startServer("192.168.255.1", 4041);
}

void startServer(String ip, int socketPort) {
  ServerSocket.bind(ip, socketPort) //绑定端口4041，根据需要自行修改，建议用动态，防止端口占用
      .then((serverSocket) {
    serverSocket.listen((socket) {
      //第一个监听监听套接字是否连接，第二个监听监听数据？
      var tmpData = "";
      print("成功连接套接字");

      socket.cast<List<int>>().transform(utf8.decoder).listen((s) {
        tmpData = doParseResultJson(socket, tmpData, s);
      });
    });
  });

  print("${DateTime.now()} Socket服务启动,正在监听端口$socketPort....");
}

/// 按JSON格式进行解析收到的结果，无论是否粘包，都是可进行解析
/// sData：为已经收到的临时数据
/// s：为当前收到的数据
/// 返回结果为未处理的所有数据。
//接收串口数据超过一个字节会出错
String doParseResultJson(Socket socket, String sData, String s) {
  var tmpData = sData + s;

  log(socket, s);
  log(socket, "-----------------------------------------");
  log(socket, tmpData);
  log(socket, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  // 找这个串里有没有相应的JSON符号
  // 没有的话，将数据返回等下一个包
  var bHasJSON = tmpData.contains("{") && tmpData.contains("}");
  if (!bHasJSON) {
    return tmpData;
  }

  //找有类似JSON串，看"{"是否在"}"的前面，
  //在前面，则解析，解析失败，则继续找下一个"}"
  //解析成功，则进行业务处理
  //处理完成，则对剩余部分递归解析，直到全部解析完成（此项一般用不到，仅适用于一次发两个以上的JSON串才需要，
  //每次只传一个JSON串的情况下，是不需要的）
  int idxStart = tmpData.indexOf("{");
  int tempIndex = idxStart + 1;
  int idxEnd = 0;
  while (tmpData.contains("}", idxEnd)) {
    idxEnd = tmpData.indexOf("}", idxEnd) + 1;

    if (idxStart >= idxEnd) {
      continue; // 找下一个 "}"
    }

    var sJSON = tmpData.substring(idxStart, idxEnd);
    if (sJSON.contains("{", tempIndex)) //子字符串中仍包含{，则继续检索，解决连续两个{}报错的情况
    {
      tempIndex = sJSON.indexOf("{", tempIndex) + 1;
      continue;
    }
    log(socket, "{}=>$idxStart -- $idxEnd;");
    log(socket, "解析 JSON ....$sJSON");
    try {
      var jsondata = jsonDecode(sJSON); //解析成功，则说明结束，否则抛出异常，继续接收
      log(socket, "解析 JSON OK :$jsondata");

      ///此处加入你要处理的业务方法，一般调用另外一个方法进行下一步处理
      doCommand(socket, jsondata);

      tmpData = tmpData.substring(idxEnd); //剩余未解析部分
      idxEnd = 0; //复位

      if (tmpData.contains("{") && tmpData.contains("}")) {
        tmpData = doParseResultJson(socket, tmpData, "");
        break;
      }
    } catch (err) {
      log(socket, "解析 JSON 出错:$err waiting for next '}'...."); //抛出异常，继续接收，等下一个}
      tmpData = " "; //解析出错，需清空缓存区数据，若不清除则后续的JASON指令接收会出错，解析的数据一直是粘包的状态
    }
  }
  return tmpData;
}

void log(Socket socket, logdata) {
  print("${DateTime.now()}[${socket.remoteAddress.address}:${socket.remotePort}] $logdata");
}

void doCommand(Socket clientsocket, jsonData) {
  var command = jsonData['func'].toString().toUpperCase();
  switch (command) {
    case "SCAN": //扫描端口
      {
        var comJsonTotal = '';
        var comNum = 0;
        for (final name in SerialPort.availablePorts) {
          comNum += 1;
          final sp = SerialPort(name);
          var comJson = '"com":{';
          comJson += '"comName":"$name",';
          comJson += '"comMess":"${sp.description}"},';
          // print('\tDescription: ${sp.description}');
          comJsonTotal += comJson;
          sp.dispose();
        }
        clientsocket
            .write('{"func":"scan","comNum":$comNum,$comJsonTotal}');
      }
      break;
    case "CONNECT":
      {
        var comName = jsonData["com"]["name"].toString();
        GlobalSerialPort.port = SerialPort(comName);
        var baudrate = jsonData["com"]["baud"].toString();
        GlobalSerialPort.port.config.baudRate = int.parse(baudrate);
        var stopBit = jsonData["com"]["stopBit"].toString();
        GlobalSerialPort.port.config.stopBits = int.parse(stopBit);
        var parity = jsonData["com"]["parity"].toString();
        GlobalSerialPort.port.config.parity = int.parse(parity);
        if (!GlobalSerialPort.port.openReadWrite()) {
          print(SerialPort.lastError);
          clientsocket.write(
              '{"func":"connect","comName":"$comName","status":"false"}');
        }
        // GlobalSerialPort.port.config.baudRate = 115200;
        clientsocket
            .write('{"func":"connect","comName":"$comName","status":"true"}');
        final reader = SerialPortReader(GlobalSerialPort.port);

        reader.stream.listen((data) {
          try {
            final String strData = String.fromCharCodes(data);
            clientsocket.write(
                '{"func":"send","comName":"$comName","data":"$strData"}');
            print('received: $strData');
          } catch (e) {
            print("error: $data");
          }
        });
      }
      break;
    case "SEND":
      {
        // var comName = jsonData["comName"].toString();
        var comData = jsonData["data"].toString();
        print(comData);
        GlobalSerialPort.port.write(Uint8List.fromList(comData.codeUnits));
      }
      break;
    case "DISCONNECT":
      {
        GlobalSerialPort.port.dispose();
      }
      break;
    default:
      clientsocket.write("不认识:command $command");
  }
}
