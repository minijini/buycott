import 'package:buycott/router/router.dart';
import 'package:buycott/states/place_notifier.dart';
import 'package:buycott/states/store_notifier.dart';
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
  final place_State = PlaceNotifier();
  final store_State = StoreNotifier();


  // notification 설정
  // String? firebaseToken = await fcmSetting();

  await FirebaseService.initializeFirebase();

  runApp( MyApp(userNotifier: user_State, placeNotifier: place_State,storeNotifier: store_State,));
}

class MyApp extends StatefulWidget {
  final UserNotifier userNotifier;
  final PlaceNotifier placeNotifier;
  final StoreNotifier storeNotifier;


  const MyApp({super.key,required this.userNotifier, required this.placeNotifier, required this.storeNotifier});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: app_name,
      home:  MainApp(userNotifier: widget.userNotifier,placeNotifier: widget.placeNotifier,storeNotifier: widget.storeNotifier,),
      builder: (context, child) => MediaQuery( //앱 전체 글자 크기 고정
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: child!,
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  final UserNotifier userNotifier;
  final PlaceNotifier placeNotifier;
  final StoreNotifier storeNotifier;

  const MainApp({Key? key,required this.userNotifier, required this.placeNotifier, required this.storeNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<UserNotifier>(
          lazy: false,
          create: (BuildContext createContext) => userNotifier,
        ), 
        
        ChangeNotifierProvider<PlaceNotifier>(
          lazy: false,
          create: (BuildContext createContext) => placeNotifier,
        ),
        ChangeNotifierProvider<StoreNotifier>(
          lazy: false,
          create: (BuildContext createContext) => storeNotifier,
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
