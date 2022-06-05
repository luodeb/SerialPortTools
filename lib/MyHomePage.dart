import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'MyApp.dart';
import 'Pages/COM.dart';
import 'Pages/COMData.dart';
import 'Pages/setting.dart';
import 'theme.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;

  int index = 0;
  int comNum = 10;

  final List<Widget> _paneContext = [];
  final List<NavigationPaneItem> _paneItem = [];

  _MyHomePageState() {
    for (int i = 0; i < comNum; i++) {
      _paneContext.add(COM(i));
      _paneItem.add(PaneItem(
        icon: const Icon(FluentIcons.devices3),
        title: Text('COM${i + 1}'),
      ));
    }
    _paneContext.add(Settings(controller: settingsController));
  }

  final settingsController = ScrollController();
  final viewKey = GlobalKey();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => COMData(comNum),
        builder: (context, _) {
          final appTheme = context.watch<AppTheme>();
          return NavigationView(
            key: viewKey,
            appBar: NavigationAppBar(
              automaticallyImplyLeading: false,
              title: () {
                if (kIsWeb) return const Text(appTitle);
                return const DragToMoveArea(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      appTitle,
                      textScaleFactor: 1.5,
                    ),
                  ),
                );
              }(),
              actions: kIsWeb
                  ? null
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [Spacer(), WindowButtons()],
                    ),
            ),
            pane: NavigationPane(
              selected: index,
              onChanged: (i) => setState(() => index = i),
              size: const NavigationPaneSize(
                //openMinWidth: 150,
                //openMaxWidth: 220,
                openWidth: 200,
              ),
              header: Container(
                height: kOneLineTileHeight,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "串口列表",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.2,
                ),
              ),
              displayMode: appTheme.displayMode,
              indicator: () {
                switch (appTheme.indicator) {
                  case NavigationIndicators.end:
                    return const EndNavigationIndicator();
                  case NavigationIndicators.sticky:
                  default:
                    return const StickyNavigationIndicator();
                }
              }(),
              items: _paneItem,
              footerItems: [
                PaneItemSeparator(),
                PaneItem(
                  icon: const Icon(FluentIcons.settings),
                  title: const Text('Settings'),
                ),
              ],
            ),
            content: NavigationBody(index: index, children: _paneContext),
          );
        });
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('退出程序'),
            content: const Text('您确定要退出吗？'),
            actions: [
              FilledButton(
                child: const Text('是'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('否'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
