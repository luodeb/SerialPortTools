import 'package:fluent_ui/fluent_ui.dart';

const Widget spacerH = SizedBox(height: 5.0);
const Widget spacerW = SizedBox(width: 5.0);
const Widget spacerHL = SizedBox(height: 15.0);
const Widget spacerWL = SizedBox(width: 30.0);

class COM8 extends StatefulWidget {
  const COM8({Key? key}) : super(key: key);

  @override
  State createState() {
    return _COM8State();
  }
}

class _COM8State extends State<COM8> {
  bool disabled = false;

  bool valueOfHEXBtn = false;
  bool valueOfTextBtn = false;

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
        onPressed: () {},
      ),
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text("COM8"),
        commandBar: ToggleSwitch(
          checked: disabled,
          onChanged: (v) => setState(() => disabled = v),
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
                    title: Text("9600"), //TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('300'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('1200'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('2400'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('9600'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('19200'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('38400'),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: const Text('115200'),
                        onPressed: () {},
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
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 60),
            child: CommandBarCard(
              child: CommandBar(
                overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
                mainAxisAlignment: MainAxisAlignment.end,
                primaryItems: [
                  ...commandBarItems,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
