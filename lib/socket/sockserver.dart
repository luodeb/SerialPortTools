import 'dart:io';
import 'dart:convert';
/**
 * Author: Jonny Zheng 13316098767@qq.com
 * 
 * 启动Socket服务，我们假设传输的协议都是JSON，所以解析时以JSON进行解析
 * 本例子仅用于演示目标，实际应用中，需考虑：
 * 1、端口占用
 * 2、传输超时重置、客户端不正常造成数据混乱重置等
 */
void startServer(String ip,int port){
  ServerSocket
  .bind(ip, port) //绑定端口4041，根据需要自行修改，建议用动态，防止端口占用
  .then((serverSocket) {
      serverSocket.listen((socket) {//第一个监听监听套接字是否连接，第二个监听监听数据？
          var tmpData="";
          print("成功连接套接字");         //旧版用这行 2021-12-31 更新
          //socket.transform(utf8.decoder).listen((s) {
 
          //新版用这行 2021-12-31 更新
          socket.cast<List<int>>().transform(utf8.decoder).listen((s) {
           
            tmpData = doParseResultJson(socket, tmpData, s);
            tmpData = '';
            s = '';
          });
        }
      );
    }
  );
 
  print(DateTime.now().toString() + " Socket服务启动，正在监听端口 "+port.toString()+"....");
}
 
/*ge
 * 按JSON格式进行解析收到的结果，无论是否粘包，都是可进行解析
 * sData：为已经收到的临时数据
 * s：为当前收到的数据
 * 返回结果为未处理的所有数据。
 */
String doParseResultJson(Socket socket, String sData, String s){
  var tmpData = sData + s; 
 
  //log(socket, "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
  log(socket, s);
  log(socket, "-----------------------------------------");
  log(socket, tmpData);
  log(socket, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  // 找这个串里有没有相应的JSON符号
  // 没有的话，将数据返回等下一个包
  var bHasJSON = tmpData.contains("{") && tmpData.contains("}"); 
  // var bHasJSON = tmpData.contains("COM") ; 
  if (!bHasJSON) {
    return tmpData;
  }
  
  //找有类似JSON串，看"{"是否在"}"的前面，
  //在前面，则解析，解析失败，则继续找下一个"}"
  //解析成功，则进行业务处理
  //处理完成，则对剩余部分递归解析，直到全部解析完成（此项一般用不到，仅适用于一次发两个以上的JSON串才需要，
  //每次只传一个JSON串的情况下，是不需要的）
  int idxStart = tmpData.indexOf("{");
  int idxEnd = 0;
  while (tmpData.contains("}", idxEnd)) {
    idxEnd = tmpData.indexOf("}", idxEnd) + 1; 
    log(socket, '{}=>' + idxStart.toString() + "--" + idxEnd.toString());
    if (idxStart >= idxEnd) {
      continue;// 找下一个 "}"
    }  
    var sJSON = tmpData.substring(idxStart, idxEnd);//提取 {指令} 
    log(socket, "解析 JSON ...." + sJSON);
    try{
      var jsondata = jsonDecode(sJSON); //解析成功，则说明结束，否则抛出异常，继续接收
      log(socket, "解析 JSON OK :" + jsondata.toString());
 
      ///指令解析
      doCommand(socket, jsondata);
      

      tmpData = tmpData.substring(idxEnd); //剩余未解析部分
      idxEnd = 0; //复位
     
      if (tmpData.contains("{") && tmpData.contains("}")) {
        tmpData = doParseResultJson(socket, tmpData, "");
        break;
      }
      return tmpData;
    } catch(err) {
      log(socket, "解析 JSON 出错:" + err.toString() + ' waiting for next "}"....'); //抛出异常，继续接收，等下一个}
     
    }
  }
  return tmpData;
}
 
/**
 与上层client协议
 */
void doCommand(Socket clientsocket, jsonData) {

  var command = jsonData['func'].toString().toUpperCase();
  switch (command) {
    case 'scan':
       var L = {
                "func":"scan",
                "comNum":2,
                "com":{
                    "comName":"COM10",
                    "comMess":"虚拟串口COM10->COM11",
                      },
                "com":{
                    "comName":"COM11",
                    "comMess":"虚拟串口COM10->COM11",
                },
              };
       clientsocket.write (L);

  }
   
}
 
void log(Socket socket, logdata) {
  print(DateTime.now().toString() + "[" + socket.remoteAddress.address.toString() + ":" + socket.remotePort.toString() + "]" + logdata);
}
 
/**
 * 主方法入口
 */
void main(){
  startServer('127.0.0.1',4041);
}
