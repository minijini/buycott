import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' show FirebaseMessaging, RemoteMessage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';
import 'firebase_options.dart';


class FCMProvider extends ChangeNotifier {
  static BuildContext? _context;

  static void setContext(BuildContext context) => FCMProvider._context = context;


  static callChatList()async {
    // await Provider.of<ChatNotifier>(FCMProvider._context!, listen: false).chatList();
    // ChatNotifier().chatList(FCMProvider._context!);
    // await FCMProvider._context!.read<ChatNotifier>().chatList();
  }

  /// when app is in the foreground
  static Future<void> onTapNotification(NotificationResponse? response) async {
    if (FCMProvider._context == null || response?.payload == null) return;

    print('onDidReceiveNotificationResponse - payload: ${response?.payload}');

    // FCMProvider.callChatList();

    final payload = response?.payload ?? '';

    // Map<String, dynamic> jsonData = json.decode(payload);
    //
    // print('onDidReceiveNotificationResponse - parsedJson type: ${jsonData['type']}');

    final  _data = FCMProvider.convertPayload(response!.payload!);
    print('onDidReceiveNotificationResponse - parsedJson type: ${_data['type']}');
    // if (_data['type'] == fcm_chat){
    //   FCMProvider._context!.goNamed(
    //     chatRouteName,
    //     pathParameters: {
    //       'pkChat': '${_data['pkChat']}',
    //       'pkMember': '${_data['pkMember']}',
    //     },
    //   );
    // }
  }




  static dynamic convertPayload(String payload){
    final String _payload = payload.substring(1, payload.length - 1);
    List<String> _split = [];
    _payload.split(",").forEach((String s) => _split.addAll(s.split(":")));
     final _mapped = {};
    for (int i = 0; i < _split.length + 1; i++) {
      if (i % 2 == 1) _mapped.addAll({_split[i-1].trim().toString(): _split[i].trim()});
    }
    return _mapped;
  }

  static handleMessage(RemoteMessage message) {
    print('handleMessage = ${message.notification!.title}');
    print('handleMessage data= ${message.data}');
    print('handleMessage data type= ${message.data['type']}');

    // if (message.data['type'] == fcm_chat){
    //   FCMProvider._context!.goNamed(
    //     chatRouteName,
    //     pathParameters: {
    //       'pkChat': '${message.data['pkChat']}',
    //       'pkMember': '${message.data['pkMember']}',
    //     },
    //   );
    // }

    FCMProvider.callChatList();

  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    print("Handling a background message: ${message.messageId}");
    print("Handling a background message data: ${message.data}");
    print("Handling a background message data type: ${message.data['type']}");

    FCMProvider.callChatList();

  }
}