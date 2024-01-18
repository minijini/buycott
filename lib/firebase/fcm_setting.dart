import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/basic_text.dart';


//앱이 실행중일 때는 Foreground, 앱이 꺼져있거나 background로 실행중일 때 Background 상태
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
  debugPrint("Handling a background message data: ${message.data}");

  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  if (initialMessage != null) _handleMessage(initialMessage);

  // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  // iOS 는 Foreground 상태일 때 푸시 알람을 누르면 이쪽으로 옴
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

}

void _handleMessage(RemoteMessage message) {
  debugPrint('handleMessage = ${message.notification!.title}');
  debugPrint('handleMessage data= ${message.data}');

}



Future<String?> fcmSetting() async {
  // // firebase core 기능 사용을 위한 필수 initializing
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage(); //Terminated 상태일때
  if (initialMessage != null) {
    debugPrint('terminated fcm =======');
    _handleMessage(initialMessage);
  }

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
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
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');

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

  // foreground 에서의 푸시 알림 표시를 위한 local notifications 설정
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);


  // foreground 푸시 알림 핸들링
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');
    debugPrint('Message notification hashCode: ${notification.hashCode}');
    debugPrint('Message notification title: ${notification?.title}');
    debugPrint('Message notification body: ${notification?.body}');

    if (message.notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
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
          )
      );

      debugPrint('Message also contained a notification: ${message.notification}');
      // 데이터 유무 확인
      debugPrint('Message data: ${message.data}');
      // notification 유무 확인
      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification!.body}');
      }
    }
  });

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/appicon'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse details) async { // forground 클릭시 이벤트
      debugPrint('onDidReceiveNotificationResponse - payload: ${details.payload}');
      final payload = details.payload ?? '';

      final parsedJson = jsonDecode(payload);
      // if (!parsedJson.containsKey('routeTo')) {
      //   return;
      // }

    },
  );

  // firebase token 발급
  String? firebaseToken = await messaging.getToken();

  debugPrint("firebaseToken : ${firebaseToken}");

  pushtoken = firebaseToken;

  return firebaseToken;
}