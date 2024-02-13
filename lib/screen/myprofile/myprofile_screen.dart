import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../widgets/style/container.dart';

class MyProfileScreen extends StatefulWidget {
  final UserNotifier userNotifier;
  const MyProfileScreen({super.key, required this.userNotifier});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  @override
  void initState() {
    getProfileImg();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: sized_18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sized_18),
            child: Text(
              'MY',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          heightSizeBox(sized_14),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sized_18),
            child: _myProfile(context),
          ),
          heightSizeBox(sized_30),
          _menu(context, "내 가게 목록", true),
          _menu(context, "내가 쓴 리뷰", true),
          _menu(context, "공지사항", false),
          _menu(context, "약관 및 정책", false),
        ],
      ),
    );
  }

  Column _menu(BuildContext context, String title, bool visible) {
    return Column(
      children: [
        ListTile(
          dense:true,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: sized_18,
          ),
          title: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500)),
          onTap: () {},
          trailing: Visibility(
              visible: visible,
              child: Icon(
                Icons.chevron_right,
                size: sized_25,
                color: Colors.black,
              )),
        ),
        divider()
      ],
    );
  }

  Row _myProfile(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            CircleImage(
              img:
                  widget.userNotifier.profileImg ?? "https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg" ,
              size: sized_60,
            ),
            widthSizeBox(sized_10),
            Text(
              '닉네임',
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: sized_40,
            height: sized_25,
            decoration: grayDecor(),
            child: Center(
                child:
                    Text('수정', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          ),
        ))
      ],
    );
  }


  void getProfileImg(){
    Provider.of<UserNotifier>(context,listen: false).getProfileImg(context,1);
  }
}
