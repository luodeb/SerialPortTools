import 'dart:convert';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../socket/socket_data.dart';
import 'COMData.dart';

const Widget spacerH = SizedBox(height: 5.0);
const Widget spacerW = SizedBox(width: 5.0);
const Widget spacerHL = SizedBox(height: 15.0);
const Widget spacerWL = SizedBox(width: 30.0);

class COM extends StatefulWidget {
  int i;

  COM(this.i, {Key? key}) : super(key: key);

  @override
  State createState() {
    return _COMState(i);
  }
}

class _COMState extends State<COM> {
  int i;

  _COMState(this.i);

  final sendDataAreaController = TextEditingController();
  final dataDisplayAreaController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    sendDataAreaController.dispose();
    dataDisplayAreaController.dispose();
  }

  String _doParseResultJson(Socket socket, String tmpData, COMData comData) {
    //log(socket, "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    _log(socket, tmpData);
    _log(socket, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
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
      _log(socket, '{}=>' + idxStart.toString() + "--" + idxEnd.toString());
      _log(socket, "解析 JSON ....$sJSON");
      try {
        var jsondata = jsonDecode(sJSON); //解析成功，则说明结束，否则抛出异常，继续接收
        _log(socket, "解析 JSON OK :$jsondata");

        ///此处加入你要处理的业务方法，一般调用另外一个方法进行下一步处理
        _doCommand(socket, jsondata, comData);

        tmpData = tmpData.substring(idxEnd); //剩余未解析部分
        idxEnd = 0; //复位

        if (tmpData.contains("{") && tmpData.contains("}")) {
          tmpData = _doParseResultJson(socket, tmpData, comData);
          break;
        }
      } catch (err) {
        _log(
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

  void _log(Socket socket, logdata) {
    // ignore: prefer_interpolation_to_compose_strings
    print(
        // ignore: prefer_interpolation_to_compose_strings
        "${DateTime.now()}[${socket.remoteAddress.address}:${socket.remotePort}]" +
            logdata);
  }

  void _doCommand(Socket socket, jsonData, COMData comData) {
    var command = jsonData['func'].toString().toUpperCase();
    switch (command) {
      case "CONNECT":
        {
          var name = jsonData["name"].toString();
          var status = jsonData["status"].toString();
          if (status == "true") {
            setState(() => comData.isOn[i] = true);
            dataDisplayAreaController.text += "$name connection succeeded.\n";
          }
          if (status == "false") {
            setState(() => comData.isOn[i] = false);
            dataDisplayAreaController.text += "$name connection failed.\n";
          }
        }
        break;
      case "SEND":
        {
          var name = jsonData["name"].toString();
          var data = jsonData["data"].toString();
          dataDisplayAreaController.text +=
              "$name receives $data successfully.\n";
        }
    }
  }

  void _isOnChanged(COMData comData, bool v) {
    setState(() => comData.isOn[i] = v);
    if (comData.isOn[i] == true) {
      Socket.connect('127.0.0.1', 4041).then((socket) async {
        socket.write(
            '{"func":"connect","com":{"name":"COM${i + 1}","baud":${comData.baudRateText[i]},"stopBit":${comData.stopBitText[i]},"parity":${comData.parityBitTex[i]}}}');
        socket.listen((tmpData) {
          _doParseResultJson(socket, String.fromCharCodes(tmpData), comData);
        });
      });
    }
    if (comData.isOn[i] == false) {
      Socket.connect('127.0.0.1', 4041).then((socket) async {
        socket.write('{"func":"disconnect"}');
        dataDisplayAreaController.text += "COM${i + 1} disconnected.\n";
      });
    }
  }

  void _sendPressed(COMData comData) {
    if (comData.isOn[i] == true) {
      Socket.connect('127.0.0.1', 4041).then((socket) async {
        socket.write('{"func":"send","data":"${sendDataAreaController.text}"}');
        dataDisplayAreaController.text +=
            "COM${i + 1} sent ${sendDataAreaController.text} successfully.\n";
        sendDataAreaController.text = "";
      });
    } else {
      dataDisplayAreaController.text +=
          "Please open the serial port and try again.\n";
    }
  }

  @override
  Widget build(BuildContext context) {
    final comData = context.watch<COMData>();
    return ScaffoldPage(
      header: PageHeader(
        title: Text("COM${i + 1}"),
        commandBar: ToggleSwitch(
          checked: comData.isOn[i],
          onChanged: (v) => _isOnChanged(comData, v),
          content: comData.isOn[i] ? const Text("On") : const Text("Off"),
        ),
      ),
      content: Column(
        children: [
          spacerHL,
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxHeight: 100, minWidth: double.infinity),
            child: Card(
              child: Wrap(
                //alignment: WrapAlignment.start,//TODO 根据窗口大小选择排序方式
                children: [
                  spacerW,
                  const Text("波特率"),
                  spacerW,
                  DropDownButton(
                    disabled: comData.isOn[i],
                    title: Text(comData.baudRateText[i]),
                    items: [
                      MenuFlyoutItem(
                        text: const Text('300'),
                        onPressed: () =>
                            setState(() => comData.baudRateText[i] = "300"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('1200'),
                        onPressed: () =>
                            setState(() => comData.baudRateText[i] = "1200"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('2400'),
                        onPressed: () =>
                            setState(() => comData.baudRateText[i] = "2400"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('9600'),
                        onPressed: () =>
                            setState(() => comData.baudRateText[i] = "9600"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('19200'),
                        onPressed: () =>
                            setState(() => comData.baudRateText[i] = "19200"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('38400'),
                        onPressed: () =>
                            setState(() => comData.baudRateText[i] = "38400"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('115200'),
                        onPressed: () =>
                            setState(() => comData.baudRateText[i] = "115200"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  spacerWL,
                  const Text("数字位"),
                  spacerW,
                  DropDownButton(
                    disabled: comData.isOn[i],
                    title: Text(comData.digitBitText[i]),
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: () =>
                            setState(() => comData.digitBitText[i] = "2"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: () =>
                            setState(() => comData.digitBitText[i] = "8"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: () =>
                            setState(() => comData.digitBitText[i] = "16"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  spacerWL,
                  const Text("校验位"),
                  spacerW,
                  DropDownButton(
                    disabled: comData.isOn[i],
                    title: Text(comData.parityBitTex[i]),
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: () =>
                            setState(() => comData.parityBitTex[i] = "2"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: () =>
                            setState(() => comData.parityBitTex[i] = "8"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: () =>
                            setState(() => comData.parityBitTex[i] = "16"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  spacerWL,
                  const Text("停止位"),
                  spacerW,
                  DropDownButton(
                    disabled: comData.isOn[i],
                    title: Text(comData.stopBitText[i]),
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: () =>
                            setState(() => comData.stopBitText[i] = "2"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: () =>
                            setState(() => comData.stopBitText[i] = "8"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: () =>
                            setState(() => comData.stopBitText[i] = "16"),
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  spacerWL,
                  RadioButton(
                    checked: comData.isHex[i],
                    onChanged: comData.isOn[i]
                        ? null
                        : (v) => setState(() => comData.isHex[i] = v),
                    content: const Text("HEX"),
                  ),
                  spacerWL,
                  RadioButton(
                    checked: comData.isText[i],
                    onChanged: comData.isOn[i]
                        ? null
                        : (v) => setState(() => comData.isText[i] = v),
                    content: const Text("Text"),
                  ),
                ],
              ),
            ),
          ),
          spacerHL,
          Expanded(
            child: TextFormBox(
              controller: dataDisplayAreaController,
              readOnly: true,
              maxLines: null,
              suffixMode: OverlayVisibilityMode.always,
              minHeight: double.infinity,
              expands: true,
              placeholder: '数据展示区',
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 100),
            child: TextFormBox(
              controller: sendDataAreaController,
              maxLines: null,
              suffixMode: OverlayVisibilityMode.always,
              minHeight: 100,
              expands: true,
              placeholder: "命令交互区",
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 60),
            child: CommandBarCard(
              child: CommandBar(
                overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
                mainAxisAlignment: MainAxisAlignment.end,
                primaryItems: <CommandBarItem>[
                  CommandBarBuilderItem(
                    builder: (context, mode, w) => Tooltip(
                      message: "点击显示时间戳",
                      child: w,
                    ),
                    wrappedItem: CommandBarButton(
                      icon: const Icon(FluentIcons.date_time),
                      label: const Text('时间戳'),
                      onPressed: () {},
                    ),
                  ),
                  CommandBarBuilderItem(
                    builder: (context, mode, w) => Tooltip(
                      message: "点击设置定时",
                      child: w,
                    ),
                    wrappedItem: CommandBarButton(
                      icon: const Icon(FluentIcons.timer),
                      label: const Text('定时'),
                      onPressed: () {},
                    ),
                  ),
                  CommandBarBuilderItem(
                    builder: (context, mode, w) => Tooltip(
                      message: "点击清空",
                      child: w,
                    ),
                    wrappedItem: CommandBarButton(
                      icon: const Icon(FluentIcons.delete),
                      label: const Text('清空'),
                      onPressed: () {},
                    ),
                  ),
                  CommandBarBuilderItem(
                    builder: (context, mode, w) => Tooltip(
                      message: "点击暂停发送",
                      child: w,
                    ),
                    wrappedItem: CommandBarButton(
                      icon: const Icon(FluentIcons.circle_pause),
                      label: const Text('暂停发送'),
                      onPressed: () {},
                    ),
                  ),
                  CommandBarBuilderItem(
                    builder: (context, mode, w) => Tooltip(
                      message: "点击循环发送",
                      child: w,
                    ),
                    wrappedItem: CommandBarButton(
                      icon: const Icon(FluentIcons.history),
                      label: const Text('循环发送'),
                      onPressed: () {},
                    ),
                  ),
                  CommandBarBuilderItem(
                    builder: (context, mode, w) => Tooltip(
                      message: "点击发送",
                      child: w,
                    ),
                    wrappedItem: CommandBarButton(
                      icon: const Icon(FluentIcons.send),
                      label: const Text('发送'),
                      onPressed: () {
                        _sendPressed(comData);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
