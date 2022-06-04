import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/COM_1.dart';
import 'pages/COM_2.dart';
import 'pages/COM_3.dart';
import 'pages/COM_4.dart';
import 'pages/COM_5.dart';
import 'pages/COM_6.dart';
import 'pages/COM_7.dart';
import 'pages/COM_8.dart';
import 'pages/COM_9.dart';
import 'pages/settings.dart';
import 'theme.dart';

import 'socket/server_socket.dart';

const String appTitle = '  串口调试助手  ';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if it's on the web, windows or android, load the accent color
  if (kIsWeb ||
      [TargetPlatform.windows, TargetPlatform.android]
          .contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }

  setPathUrlStrategy();

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setSize(const Size(1000, 750));
      await windowManager.setMinimumSize(const Size(500, 375));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

 if (isDesktop) {//只有在桌面端程序才会启动服务端
    socketBind('127.0.0.1', 4041);
 }

  runApp(const MyApp());
  // asyncServerSocket("127.0.0.1",9099);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
          color: appTheme.color,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          theme: ThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;

  int index = 0;

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
          /*
          FlutterLogo(
            style: appTheme.displayMode == PaneDisplayMode.top
                ? FlutterLogoStyle.markOnly
                : FlutterLogoStyle.horizontal,
            size: appTheme.displayMode == PaneDisplayMode.top ? 24 : 100.0,
          ),
          */
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
        items: [
          // It doesn't look good when resizing from compact to open
          // PaneItemHeader(header: Text('User Interaction')),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM1'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM2'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM3'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM4'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM5'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM6'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM7'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            title: const Text('COM8'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.devices3),
            /*
            icon: Icon(
              appTheme.displayMode == PaneDisplayMode.top
                  ? FluentIcons.more
                  : FluentIcons.more_vertical,
            ),
            */
            title: const Text('COM9'),
            /*
            infoBadge: const InfoBadge(
              source: Text('9'),
            ),
            */
          ),
        ],
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
          ),
        ],
      ),
      content: NavigationBody(index: index, children: [
        const COM1(),
        const COM2(),
        const COM3(),
        const COM4(),
        const COM5(),
        const COM6(),
        const COM7(),
        const COM8(),
        const COM9(),
        Settings(controller: settingsController),
      ]),
    );
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
