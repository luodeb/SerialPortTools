// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:typed_data';

late ServerSocket mysocket;
late SerialPort myport;
bool isContinueSendSteam = false; //是否可以发送Steam

Future<void> socketBind(String ip, int port) async {
  print('Socket绑定IP $ip : $port');
  mysocket = await ServerSocket.bind(ip, port);

  mysocket.listen((socket) {
    var tmpData = "";
    print('连接socket');
    socket.cast<List<int>>().transform(utf8.decoder).listen((s) {
      tmpData = doParseResultJson(socket, tmpData, s);
      print(s);
      // socket.write("test");
    });
  });
}

/// 按JSON格式进行解析收到的结果，无论是否粘包，都是可进行解析
/// sData：为已经收到的临时数据
/// s：为当前收到的数据
/// 返回结果为未处理的所有数据。
//接收串口数据超过一个字节会出错
String doParseResultJson(Socket socket, String sData, String s) {
  var tmpData = sData + s;

  //log(socket, "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
  // log(socket, s);
  // log(socket, "-----------------------------------------");
  // log(socket, tmpData);
  // log(socket, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
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
    // ignore: prefer_interpolation_to_compose_strings
    // log(socket, '{}=>' + idxStart.toString() + "--" + idxEnd.toString());
    // log(socket, "解析 JSON ....$sJSON");
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
      log(
          socket,
          // ignore: prefer_interpolation_to_compose_strings
          "解析 JSON 出错:" +
              err.toString() +
              ' waiting for next "}"....'); //抛出异常，继续接收，等下一个}
      tmpData = " "; //解析出错，需清空缓存区数据，若不清除则后续的JASON指令接收会出错，解析的数据一直是粘包的状态
    }
  }
  return tmpData;
}

void log(Socket socket, logdata) {
  // ignore: prefer_interpolation_to_compose_strings
  print(
      // ignore: prefer_interpolation_to_compose_strings
      "${DateTime.now()}[${socket.remoteAddress.address}:${socket.remotePort}]" +
          logdata);
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
          var comJson = '';
          if (comNum != 1) {
            comJson += ',{';
          } else {
            comJson += '{';
          }
          comJson += '"name":"$name",';
          comJson += '"mess":"${sp.description}"}';
          comJsonTotal += comJson;
          sp.dispose();
        }
        log(
          clientsocket,
          '{"func":"scan","comNum":$comNum,"com":[$comJsonTotal]}'
        );
        clientsocket
            .write('{"func":"scan","comNum":$comNum,"com":[$comJsonTotal]}');
      }
      break;
    case "CONNECT":
      {
        var name = jsonData["com"]["name"].toString();
        myport = SerialPort(name);
        var baudRate = jsonData["com"]["baud"] ?? "115200";
        myport.config.baudRate = int.parse(baudRate.toString());
        var stopBit = jsonData["com"]["stopBit"] ?? "1";
        myport.config.stopBits = int.parse(stopBit.toString());
        var parity = jsonData["com"]["parity"] ?? "0";
        myport.config.parity = int.parse(parity.toString());
        if (!myport.openReadWrite()) {
          print(SerialPort.lastError);
          clientsocket
              .write('{"func":"connect","name":"$name","status":"false"}');
        }
        clientsocket.write('{"func":"connect","name":"$name","status":"true"}');
        final reader = SerialPortReader(myport);

        reader.stream.listen((data) {
          try {
            final String str = String.fromCharCodes(data);
            clientsocket.write('{"func":"send","name":"$name","data":"$str"}');
            print('port received: $str');
          } catch (e) {
            print("error: $data");
          }
        });
      }
      break;
    case "SEND":
      {
        // var name = jsonData["name"].toString();
        var comData = jsonData["data"].toString();
        print(comData);
        myport.write(Uint8List.fromList(comData.codeUnits));
      }
      break;
    case "DISCONNECT":
      {
        // myport.close();
        myport.dispose();
      }
      break;
    default:
      clientsocket.write("不认识:command $command");
  }
}
