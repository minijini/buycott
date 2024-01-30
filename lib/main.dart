import 'package:buycott/router/router.dart';
import 'package:buycott/states/shop_notifier.dart';
import 'package:buycott/states/user_notifier.dart';
import 'package:buycott/utils/theme/basic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

import 'constants/basic_text.dart';
import 'firebase/fcm_setting.dart';
import 'firebase/firebaseservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //kakao Login 설정
  KakaoSdk.init(nativeAppKey: '36819280f2245ae1a969dd8de2dda219');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); //세로고정

  final user_State = UserNotifier();
  final shop_State = ShopNotifier();


  // notification 설정
  // String? firebaseToken = await fcmSetting();

  await FirebaseService.initializeFirebase();

  runApp( MyApp(userNotifier: user_State, shopNotifier: shop_State,));
}

class MyApp extends StatefulWidget {
  final UserNotifier userNotifier;
  final ShopNotifier shopNotifier;


  const MyApp({super.key,required this.userNotifier, required this.shopNotifier});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: app_name,
      home:  MainApp(userNotifier: widget.userNotifier,shopNotifier: widget.shopNotifier,),
    );
  }
}

class MainApp extends StatelessWidget {
  final UserNotifier userNotifier;
  final ShopNotifier shopNotifier;


  const MainApp({Key? key,required this.userNotifier, required this.shopNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<UserNotifier>(
          lazy: false,
          create: (BuildContext createContext) => userNotifier,
        ), 
        
        ChangeNotifierProvider<ShopNotifier>(
          lazy: false,
          create: (BuildContext createContext) => shopNotifier,
        ),


        Provider<MyRouter>(
          lazy: false,
          create: (context) => MyRouter(userNotifier),
        )
      ],
      child: Builder(
        builder: (BuildContext context) {
          // TODO: Add Router
          final router = Provider.of<MyRouter>(context, listen: false).router;
          return MaterialApp.router(
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            title: 'Navigater',
            theme: BasicTheme.light(),
          );
        },
      ),
    );
  }
}
