import 'package:fluent_ui/fluent_ui.dart';
import '../socket/client_socket.dart';
import '../socket/socket_data.dart';

const Widget spacerH = SizedBox(height: 5.0);
const Widget spacerW = SizedBox(width: 5.0);
const Widget spacerHL = SizedBox(height: 15.0);
const Widget spacerWL = SizedBox(width: 30.0);

class COMPage extends StatefulWidget {
  final int pageIndex;
  const COMPage(this.pageIndex, {Key? key}) : super(key: key);

  @override
  State createState() {
    // ignore: no_logic_in_create_state
    return _COMPageState(pageIndex);
  }
}

class _COMPageState extends State<COMPage> {
  final int pageIndex;

  _COMPageState(this.pageIndex);

  bool disabled = false;
  SerialPortData myportdata = SerialPortData.serialPortData;
  bool valueOfHEXBtn = false;
  bool valueOfTextBtn = false;
  String sendBuffer = "";

  List<CommandBarItem> _commandBarItems() {
    final commandBarItems = <CommandBarItem>[
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
            sendComData();
          },
        ),
      ),
    ];

    return commandBarItems;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myportdata.name = "COM$pageIndex";
    return ScaffoldPage(
      header: PageHeader(
        title: Text(myportdata.name),
        commandBar: ToggleSwitch(
          checked: disabled,
          onChanged: (v) => setState(() {
            disabled = v;
            if (disabled) {
              ClientSocket.connectPorts(myportdata);
            } else {
              ClientSocket.disconnectPorts(myportdata);
            }
          }),
          content: disabled ? const Text("On") : const Text("Off"),
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
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  spacerW,
                  const Text("波特率"),
                  spacerW,
                  DropDownButton(
                    disabled: disabled,
                    title: Text("${myportdata.baud}"), //TODO 返回选取值
                    items: getBaudViewList(),
                  ),
                  spacerWL,
                  const Text("数字位"),
                  spacerW,
                  DropDownButton(
                    disabled: disabled,
                    title: Text("8"), //TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: () {},
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
                    disabled: disabled,
                    title: Text("8"), //TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  spacerWL,
                  const Text("奇偶位"),
                  spacerW,
                  DropDownButton(
                    disabled: disabled,
                    title: Text("8"), //TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  spacerWL,
                  RadioButton(
                    checked: valueOfHEXBtn,
                    onChanged: disabled
                        ? null
                        : (v) => setState(() => valueOfHEXBtn = v),
                    content: Text("HEX"),
                  ),
                  spacerWL,
                  RadioButton(
                    checked: valueOfTextBtn,
                    onChanged: disabled
                        ? null
                        : (v) => setState(() => valueOfTextBtn = v),
                    content: Text("Text"),
                  ),
                ],
              ),
            ),
          ),
          spacerHL,
          Expanded(
            child: TextFormBox(
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
              maxLines: null,
              suffixMode: OverlayVisibilityMode.always,
              minHeight: 100,
              expands: true,
              placeholder: '命令行交互区',
              onChanged: (s) {
                sendBuffer = s;
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 60),
            child: CommandBarCard(
              child: CommandBar(
                overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
                mainAxisAlignment: MainAxisAlignment.end,
                primaryItems: _commandBarItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 波特率列表
  List<MenuFlyoutItem> getBaudViewList() {
    final List<MenuFlyoutItem> baudListViews = <MenuFlyoutItem>[];
    for (int i = 0; i < SerialPortData.baudList.length; i++) {
      baudListViews.add(MenuFlyoutItem(
          text: Text('${SerialPortData.baudList[i]}'),
          onPressed: () => setState(() {
                myportdata.baud = SerialPortData.baudList[i];
              })));
    }
    return baudListViews;
  }

  // 发送命令行数据
  void sendComData() {
    ClientSocket.sendData(myportdata, sendBuffer);
  }

  // 怎么解决接收数据的问题
  void receivedData(String data) {
    print(data);
  }
}


