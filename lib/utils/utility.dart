// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'color/basic_color.dart';




class Utility {


  static String getPostTime2(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat =
        DateFormat.jm().format(dt) + ' - ' + DateFormat("dd MMM yy").format(dt);
    return dat;
  }

  static String getDob(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat = DateFormat.yMMMd().format(dt);
    return dat;
  }

  static String getJoiningDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat = DateFormat("MMMM yyyy").format(dt);
    return 'Joined $dat';
  }

  static String getYear() {
    var date = DateTime.now();

    var dat = DateFormat("yyyy").format(date);

    return dat;
  }

   String getAge(String age){
    int to_year = int.parse(getYear());
    int age_year = int.parse(age.substring(0,4));

    int _age = to_year - age_year;

    return _age.toString();
  }

  static String getChatTime(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    String msg = '';
    var dt = DateTime.parse(date).toLocal();

    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
    }

    var dur = DateTime.now().toLocal().difference(dt);
    if (dur.inDays > 365) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 30) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 0) {
      msg = '${dur.inDays} d';
      return dur.inDays == 1 ? '1d' : DateFormat.MMMd().format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours} h';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes} m';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds} s';
    } else {
      msg = 'now';
    }
    return msg;
  }

  static String getPollTime(String date) {
    int hr, mm;
    String msg = 'Poll ended';
    var endDate = DateTime.parse(date);
    if (DateTime.now().isAfter(endDate)) {
      return msg;
    }
    msg = 'Poll ended in';
    var dur = endDate.difference(DateTime.now());
    hr = dur.inHours - dur.inDays * 24;
    mm = dur.inMinutes - (dur.inHours * 60);
    if (dur.inDays > 0) {
      msg = ' ' + dur.inDays.toString() + (dur.inDays > 1 ? ' Days ' : ' Day');
    }
    if (hr > 0) {
      msg += ' ' + hr.toString() + ' hour';
    }
    if (mm > 0) {
      msg += ' ' + mm.toString() + ' min';
    }
    return (dur.inDays).toString() +
        ' Days ' +
        ' ' +
        hr.toString() +
        ' Hours ' +
        mm.toString() +
        ' min';
  }



  static void debugLog(String log, {dynamic param = ""}) {
    final String time = DateFormat("mm:ss:mmm").format(DateTime.now());
    debugPrint("[$time][Log]: $log, $param");
  }


  static List<String> getHashTags(String text) {
    RegExp reg = RegExp(
        r"([#])\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> _matches = reg.allMatches(text);
    List<String> resultMatches = <String>[];
    for (Match match in _matches) {
      if (match.group(0)!.isNotEmpty) {
        var tag = match.group(0);
        resultMatches.add(tag!);
      }
    }
    return resultMatches;
  }

  static String getUserName({
    required String id,
    required String name,
  }) {
    String userName = '';
    if (name.length > 15) {
      name = name.substring(0, 6);
    }
    name = name.split(' ')[0];
    id = id.substring(0, 4).toLowerCase();
    userName = '@$name$id';
    return userName;
  }

  static bool validateCredentials(
      BuildContext context, String? email, String? password) {
    if (email == null || email.isEmpty) {
      customSnackBar(context, 'Please enter email id');
      return false;
    } else if (password == null || password.isEmpty) {
      customSnackBar(context, 'Please enter password');
      return false;
    } else if (password.length < 8) {
      customSnackBar(context, 'Password must me 8 character long');
      return false;
    }

    var status = validateEmail(email);
    if (!status) {
      customSnackBar(context, 'Please enter valid email id');
      return false;
    }
    return true;
  }

  static customSnackBar(BuildContext context, String msg,
      {double height = 30, Color backgroundColor = BasicColor.primary}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      elevation: 3.0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool validateEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    var status = regExp.hasMatch(email);
    return status;
  }


  static void copyToClipBoard({
    required BuildContext context,
    required String text,
    required String message,
  }) {
    var data = ClipboardData(text: text);
    Clipboard.setData(data);
    customSnackBar(context, message);
  }

  static Locale getLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  bool isKeyboardOpened(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void setSharedPreference(String key , String? data)async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, data ?? '');
  }



  void setSharedPreference_bool(String key , bool? data)async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(key, data ?? false);
  }

  Future<String> getSharedPreference(String key) async {
    debugPrint('getSharedPreferencegetSharedPreference');
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(key) ?? "";
    debugPrint('token data : $data');
    return data;
  }

  void removeSharedPreference(String key )async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }


  String comma(String data){
    int num = int.parse(data);
    var  result = NumberFormat('###,###,###,###').format(num);
    return result.toString();
  }

  String currency(String data){
    int num = int.parse(data);
    var  result = NumberFormat.currency(locale: "ko_KR", symbol: "￦").format(num);
    return result.toString();
  }

  String getOpenClose(String openTime, String closeTime){
    // 현재 시간을 가져옴
    DateTime now = DateTime.now();

    // 현재 날짜에 시간을 추가하여 DateTime 객체를 만듭니다.
    DateTime openingDateTime = DateTime(now.year, now.month, now.day, int.parse(openTime.split(":")[0]), int.parse(openTime.split(":")[1]));
    DateTime closingDateTime = DateTime(now.year, now.month, now.day, int.parse(closeTime.split(":")[0]), int.parse(closeTime.split(":")[1]));

    // 영업 시간 비교
    if (now.isAfter(openingDateTime) && now.isBefore(closingDateTime)) {
     return "영업 중";
    } else {
      return "영업 종료";
    }
  }

  String getDateFormat(String date){
    DateTime? parsedDate = parseCustomDate(date);

    debugPrint("data :: $parsedDate");

    if (parsedDate != null) {
      String formattedDate = DateFormat('yyyy.MM.dd').format(parsedDate);
      return formattedDate; // Output: 2024.03.08
    }

    return "";
  }

  DateTime? parseCustomDate(String input) {
    try {
      List<String> parts = input.split('-');
      if (parts.length == 5) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);
        int hour = int.parse(parts[3]);
        int minute = int.parse(parts[4]);

        return DateTime(year, month, day, hour, minute);
      }
    } catch (e) {
      // Handle parsing errors
    }

    return null;
  }




  // Future<String?> getDeviceUniqueId() async { //핸드폰 정보 id
  //   var deviceInfo = DeviceInfoPlugin();
  //
  //   if (Platform.isAndroid) {
  //     var androidInfo = await deviceInfo.androidInfo;
  //     deviceId = androidInfo.id!;
  //   } else if (Platform.isIOS) {
  //     var iosInfo = await deviceInfo.iosInfo;
  //     deviceId = iosInfo.identifierForVendor!;
  //   }
  //   return deviceId;
  // }

}
