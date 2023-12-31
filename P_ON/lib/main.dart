import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'app.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'common/data/preference/app_preferences.dart';
import 'screen/main/tab/promise_room/vo_naver_headers.dart';
import 'common/theme/custom_theme_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/foundation.dart';
import 'package:p_on/screen/main/user/token_state.dart';

late void Function() runAppAgain;

void main() async {
  runAppAgain = main;

  // WidgetsFlutterBinding.ensureInitialized();

  final bindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: bindings);
  await EasyLocalization.ensureInitialized();
  await AppPreferences.init();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'e61e6e5be260e142ffbc2ebf12d15f09',
    javaScriptAppKey: '257ed79230fb398c5b7d48ae7ddb916d',
  );

  // await NaverMapSdk.instance.initialize(clientId: Naver_Map_Id);
  if (kIsWeb) {
  } else {
    await NaverMapSdk.instance.initialize(clientId: Naver_Map_Id);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  timeago.setLocaleMessages('ko', timeago.KoMessages());
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ko')],
      fallbackLocale: const Locale('ko'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: const CustomThemeApp(
        child: ProviderScope(child: App()),
      )));
}
