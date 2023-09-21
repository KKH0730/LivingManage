import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livingmanage/data/provider/SessionProvider.dart';
import 'package:livingmanage/ui/CardScreen.dart';
import 'package:livingmanage/ui/authorization/new_authorization/AuthorizationScreen.dart';
import 'package:livingmanage/ui/common/ImageDetailScreen.dart';
import 'package:livingmanage/ui/qr/CreateQrCodeScreen.dart';
import 'package:livingmanage/ui/qr/ScanQrCodeScreen.dart';
import 'package:livingmanage/ui/sign_in/SignInScreen.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_cupertino_app.dart';

import 'ui/authorization/detail_authorization/AuthorizationDetailScreen.dart';
import 'ui/home/HomeScreen.dart';
import 'di/DIBinding.dart';

final routeObserver = RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 파이어베이스 초기화
  await EasyLocalization.ensureInitialized();

  setupFirebase();
  setupLoggingException();

  var prefs = await SharedPreferences.getInstance();
  if(prefs.getString('id')?.isNotEmpty == true) {
    initialRoute = '/HomeScreen';
  } else {
    initialRoute = '/SignInScreen';
  }

  runApp(
      ProviderScope(
        child: EasyLocalization(
            supportedLocales: const [
              Locale('en','US'), // US
              Locale('ko','KR'), // Korean
            ],
            fallbackLocale: const Locale('ko','KR'),
            path: 'assets/languages',
            child: LivingManageApp()
        ),
      )
  );
}

void setupFirebase() async {
  /**
   * 앱 빌드시 사용
   */
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /**
   * 웹 빌드 시 사용
   */
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //       apiKey: "AIzaSyAxN97k6ncdEsly3eu9m5N6EuUhuZix-zY",
  //       authDomain: "chat-module-3187e.firebaseapp.com",
  //       databaseURL: "https://chat-module-3187e-default-rtdb.firebaseio.com",
  //       projectId: "chat-module-3187e",
  //       storageBucket: "chat-module-3187e.appspot.com",
  //       messagingSenderId: "1033869949481",
  //       appId: "1:1033869949481:web:be91f0e9f7cd7f0e3dfa38"
  //   ),
  // );
  // FirebaseDatabase.instance.setPersistenceEnabled(false);
}

void setupLoggingException() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      print('Uncaught error: ${details.exception}');
    }
    FlutterError.dumpErrorToConsole(details);
  };
}

class LivingManageApp extends StatelessWidget {

  LivingManageApp({super.key});

  @override
  Widget build(BuildContext context)  {
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider.value(value: SessionProvider())
      ],
      child: GetCupertinoApp(
        builder: (context, child) => SafeArea(child: child!),
        initialBinding: DIBinding(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: initialRoute,
        navigatorObservers: [routeObserver],
        routes: routes,
      ),
    );
  }
}

String initialRoute = '/SignInScreen';
final Map<String, WidgetBuilder> routes = {
  '/CardScreen': (BuildContext context) => CardScreen(),
  '/CreateQrCodeScreen': (BuildContext context) => CreateQrCodeScreen(),
  '/ScanQrCodeScreen': (BuildContext context) => const ScanQrCodeScreen(),
  '/SignInScreen': (BuildContext context) => SignInScreen(),
  '/HomeScreen': (BuildContext context) => const HomeScreen(),
  '/AuthorizationScreen': (BuildContext context) => const AuthorizationScreen(),
  '/AuthorizationDetailScreen': (BuildContext context) => const AuthorizationDetailScreen(),
  '/ImageDetailScreen': (BuildContext context) => ImageDetailScreen()
};
