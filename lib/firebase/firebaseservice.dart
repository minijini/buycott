import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/basic_text.dart';
import '../utils/log_util.dart';
import 'fcmprovider.dart';
import 'firebase_options.dart';

const String TAG = "FirebaseService";

class FirebaseService {

  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging => FirebaseService._firebaseMessaging ?? FirebaseMessaging.instance;

   static Future<void> initializeFirebase() async {
     //TODO:options 제거함
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp();
    FirebaseService._firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseService.initializeLocalNotifications();
    await FirebaseService.onBackgroundMsg();

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
    if (initialMessage != null) FCMProvider.handleMessage(initialMessage);

    // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
    // iOS 는 Foreground 상태일 때 푸시 알람을 누르면 이쪽으로 옴
    FirebaseMessaging.onMessageOpenedApp.listen(FCMProvider.handleMessage);


    // firebase token 발급
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    Log.logs(TAG,"firebaseToken : ${firebaseToken}");
    pushtoken = firebaseToken;

  }


  Future<String?> getDeviceToken() async => await FirebaseMessaging.instance.getToken();


  static FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initializeLocalNotifications() async {
    final InitializationSettings _initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@drawable/appicon'),
        iOS: DarwinInitializationSettings()
    );
    /// on did receive notification response = for when app is opened via notification while in foreground on android
    await FirebaseService._localNotificationsPlugin.initialize(_initSettings, onDidReceiveNotificationResponse: FCMProvider.onTapNotification);
    /// need this for ios foregournd notification
    await FirebaseService.firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    /*
  * ios 권한요청
alert - 권한 요청 알림 화면을 표시 (default true)
announcement - 시리를 통해 알림의 내용을 자동으로 읽을 수 있는 권한 요청 (default false)
badge - 뱃지 업데이트 권한 요청 (default true)
carPlay - carPlay 환경에서 알림 표시 권한 요청 ( default false)
criticalAlert -  중요 알림에 대한 권한 요청, 해당 알림 권한을 요청하는 이유를 app store 등록시 명시해야함 (default true)
provisional - 무중단 알림 권한 요청 (default false)
sound - 알림 소리 권한 요청 (default true)
  * */
    NotificationSettings settings = await FirebaseService.firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    Log.logs(TAG,'User granted permission: ${settings.authorizationStatus}');


    // foreground에서의 푸시 알림 표시를 위한 알림 중요도 설정 (안드로이드)
    /*
  * id(필수) - 채널 아이디 설정
    name(필수) - 채널 이름 설정
    description - 채널 설명
    groupId - 채널이 속한 그룹의 id
    importance - 알림의 중요도
    playSound - 알림 소리 여부 설정
    sound - 재생할 소리 지정, playSound가 true이어야함.
    enableVibration - 알림 진동 여부
    enableLights - 알림 조명 여부
    vibrationPattern - 알림 진동 패턴 설정
    ledColor - 알림 조명의 색상을 지정
    showBadge - 뱃지 표시 여부 지정
  * */
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'geuttae_notification',
        'geuttae_notification',
        description: '그때 알림입니다.',
        importance: Importance.max
    );

    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      Log.logs(TAG,'Got a message whilst in the foreground!');
      Log.logs(TAG,'Message data: ${message.data}');
      Log.logs(TAG,'Message notification hashCode: ${notification.hashCode}');
      Log.logs(TAG,'Message notification title: ${notification?.title}');
      Log.logs(TAG,'Message notification body: ${notification?.body}');

      if (message.notification != null && android != null) {
        await FirebaseService._localNotificationsPlugin.show(
            notification.hashCode,
            notification?.title,
            notification?.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'appicon',
              ),
            ),
            payload: message.data.toString()
        );


        FCMProvider.callChatList();

        Log.logs(TAG,'Message also contained a notification: ${message.notification}');
        // 데이터 유무 확인
        Log.logs(TAG,'Message data: ${message.data}');
        // notification 유무 확인
        if (message.notification != null) {
          Log.logs(TAG,'Message also contained a notification: ${message.notification!.body}');
        }
      }else{
        FCMProvider.callChatList();
      }
    });
  }

  static NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      "high_importance_channel", "High Importance Notifications", priority: Priority.max, importance: Importance.max,
    ),
  );

  static Future<void> onBackgroundMsg() async {

    FirebaseMessaging.onBackgroundMessage(FCMProvider.backgroundHandler);

  }

}