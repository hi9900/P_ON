import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/theme/custom_theme_app.dart';
import 'package:fast_app_base/screen/main/s_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static bool isForeground = true;

  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> with Nav, WidgetsBindingObserver {
  @override
  GlobalKey<NavigatorState> get navigatorKey => App.navigatorKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);    return CustomThemeApp(
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: App.navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Image Finder',
          theme: context.themeType.themeData,
          home: const MainScreen(),
        );
      }),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        App.isForeground = false;
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
    super.didChangeAppLifecycleState(state);
  }
}