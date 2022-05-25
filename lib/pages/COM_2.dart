import 'package:fluent_ui/fluent_ui.dart';

const Widget spacerH = SizedBox(height: 5.0);
const Widget spacerW = SizedBox(width: 5.0);
const Widget spacerHL = SizedBox(height: 15.0);
const Widget spacerWL = SizedBox(width: 30.0);

class COM2 extends StatefulWidget{
  const COM2({Key? key}) : super(key: key);

  @override
  State createState() {
    return _COM2State();
  }
}

class _COM2State extends State<COM2> {
  bool disabled = false;

  bool valueOfHEXBtn = false;
  bool valueOfTextBtn = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text("COM2"),
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
            constraints: const BoxConstraints(maxHeight: 100,minWidth: double.infinity),
            child: Card(
              child: Wrap(
                //alignment: WrapAlignment.start,//TODO 根据窗口大小选择排序方式
                children: [
                  spacerW,
                  const Text("波特率"),
                  spacerW,
                  DropDownButton(
                    disabled: !disabled,
                    title: Text("9600"),//TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('300'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('1200'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('2400'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('9600'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('19200'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('38400'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('115200'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  spacerWL,
                  const Text("数字位"),
                  spacerW,
                  DropDownButton(
                    disabled: !disabled,
                    title: Text("8"),//TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  spacerWL,
                  const Text("校验位"),
                  spacerW,
                  DropDownButton(
                    disabled: !disabled,
                    title: Text("8"),//TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  spacerWL,
                  const Text("奇偶位"),
                  spacerW,
                  DropDownButton(
                    disabled: !disabled,
                    title: Text("8"),//TODO 返回选取值
                    items: [
                      MenuFlyoutItem(
                        text: const Text('2'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('8'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('16'),
                        onPressed: (){},
                      ),
                      MenuFlyoutItem(
                        text: const Text('自定义'),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  spacerWL,
                  RadioButton(
                    checked: valueOfHEXBtn,
                    onChanged: !disabled ? null : (v) => setState(() => valueOfHEXBtn = v),
                    content: Text("HEX"),
                  ),
                  spacerWL,
                  RadioButton(
                    checked: valueOfTextBtn,
                    onChanged: !disabled ? null : (v) => setState(() => valueOfTextBtn = v),
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
        ],
      ),
    );
  }
}