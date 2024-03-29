import 'package:buycott/constants/constants.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/data/notice_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../widgets/NoGlowScrollBehavior.dart';
import '../../widgets/circle_progressbar.dart';
import '../../widgets/list/notice_list_tile.dart';
import '../../widgets/style/container.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {


  @override
  void initState() {
    super.initState();
    getNotice();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            "공지사항",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: false,
          titleSpacing: -10,
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: BasicColor.back_black,
              icon: Image.asset('assets/icon/icon_arrow_left.png',scale: 16,))
      ),
      body: Container(
        width: device_width!,
        height: size!.height,
        child: _noticeList(),
      ) ,
    );
  }

  Widget _noticeList() {
    return  ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Consumer<UserNotifier>(
          builder: (context, notifier, widget) {
            return notifier.noticeList.isNotEmpty ? ListView.separated(
                itemBuilder: (context, index) {
                  NoticeModel notice = notifier.noticeList[index];

                  return GestureDetector(
                      onTap: (){
                        context.goNamed(noticeDetailRouteName, pathParameters: {'subject': notice.noticeSubject!,'content':notice.noticeContent!,'date':notice.regDt!});
                      },
                      child: NoticeListTile(noticeModel: notice,));
                },
                separatorBuilder: (context, index) {
                  return divider();
                },
                itemCount: notifier.noticeList.length) : CustomCircularProgress();
          }
      ),
    );
  }

  void getNotice(){
    Provider.of<UserNotifier>(context,listen: false).getNotice();
  }

}
