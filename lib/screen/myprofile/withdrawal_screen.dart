import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/utility.dart';
import '../../widgets/dialog/custom_dialog.dart';
import '../../widgets/style/button_decor.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  bool isCheck = false;
  double progressValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -10,
          title: Text(
            "회원 탈퇴",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: BasicColor.back_black,
              icon: Image.asset('assets/icon/icon_arrow_left.png',scale: 16,))
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _checkBox(context,"동의하십니까?"),
          _dropButton(context)
        ],
      ),
    );
  }

  Container _checkBox(BuildContext context , String title) {
    return Container(
      padding:EdgeInsets.only(left:sized_10,bottom: sized_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCheck = !isCheck;
              });
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: isCheck
                    ? Image.asset(
                  'assets/icon/icon_check_on.png', // Replace with your checked icon path
                  width: sized_20,
                  height: sized_20,
                )
                    : Image.asset(
                  'assets/icon/icon_check_off.png', // Replace with your unchecked icon path
                  width: sized_20,
                  height: sized_20,
                ),
              ),
            ),
          ),
          SizedBox(width:sized_4),
          Text(title,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: isCheck ? BasicColor.darkgrey : BasicColor.lightgrey2 , fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }

  SizedBox _dropButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: sized_45,
      child: ElevatedButton(
          style:  isCheck ? primary_btn_style() :disable_btn_style() ,
          onPressed: (isCheck)? (){
              CustomDialog(funcAction: dialog_MainPop).actionDialog(context, drop_member, '아니오', '확인');
          } : null, child: Text('탈퇴하기',style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: isCheck ?FontWeight.w700 : FontWeight.w600,color: isCheck ? BasicColor.lightgrey2 : BasicColor.lightgrey4,))),
    );
  }

  void dialog_MainPop(BuildContext context) async {
    Navigator.pop(context);
    goMain();
  }

  void goMain(){
    context.goNamed(mainRouteName);
  }
}
