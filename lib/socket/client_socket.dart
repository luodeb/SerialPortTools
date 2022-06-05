import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'socket_data.dart';
import 'socket_event.dart';

late Socket mysocket;
ClientSocket myclient = ClientSocket();

class ClientSocket {
  Future<void> connect(String ip, int port) async {
    try {
      mysocket = await Socket.connect(ip, port);
      mysocket.cast<List<int>>().transform(utf8.decoder).listen((s) async {
        var tmpData = "";
        tmpData = doParseResultJson(mysocket, tmpData, s);
        print(s);
      });

      sendMessage('{"func":"scan"}');
    } catch (e) {
      print("连接socket出现异常,e=${e.toString()}");
    }
  }

  static void sendMessage(String message) {
    mysocket.write(message);
  }

  void scanPorts() {
    // 扫描串口
    var jsonData = '{"func":"scan"}';
    sendMessage(jsonData);
  }

  static void sendData(SerialPortData myport, String data) {
    var jsonData =
        '{"func":"send","com":{"name":"${myport.name}"},"data":"$data"}';
    sendMessage(jsonData);
  }

  static void connectPorts(SerialPortData myport) {
    var jsonData = '{"func":"connect","com":{"name":"${myport.name}"}}';
    sendMessage(jsonData);
  }

  static void disconnectPorts(SerialPortData myport) {
    // var jsonData = '{"func":"disconnect","com":{"name":"${myport.name}"}}';
    var jsonData = '{"func":"disconnect"}';
    sendMessage(jsonData);
  }
}

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

void doCommand(Socket mysocket, jsonData) {
  var command = jsonData['func'].toString().toUpperCase();
  switch (command) {
    case "SEND":
      {
        SocketEvent.event.fire(MessageEvent(jsonData['data']));
        print("收到串口数据${jsonData['data']}");
      }
      break;
    case "SCAN":
      {
        myportdataList = [];
        for (var i = 0; i < jsonData['com'].length; i++) {
          myportdataList.add(SerialPortData(
            name: jsonData['com'][i]['name'],
            description: jsonData['com'][i]['mess'],
            baud: 115200,
            stopBit: 8,
            parity: 0,
            check: 0,
            status: false,
          ));
        }
        SocketEvent.event.fire(ScanFlush());
      }
      break;
    // default:
    //   print("不认识:command $command");
  }
}
