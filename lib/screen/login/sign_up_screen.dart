import 'dart:io';

import 'package:buycott/constants/response_code.dart';
import 'package:buycott/constants/status.dart';
import 'package:buycott/firebase/firebaseservice.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:buycott/widgets/style/button_decor.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/utility.dart';
import '../../utils/validator.dart';
import '../../widgets/dialog/custom_dialog.dart';
import '../../widgets/list/shop_list_tile.dart';
import '../../widgets/style/input_decor.dart';

class SignUpScreen extends StatefulWidget {
  final String userId;
  final String signType;
  const SignUpScreen({super.key, required this.userId, required this.signType});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TAG = "SignUpScreen";

  XFile? _ximage;
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _nickNameTextController = TextEditingController();

  bool? nickNmCheck;

  double progressValue = 1.0;

  bool isCheck_all = false;
  bool isCheck_age = false;
  bool isCheck_terms = false;
  bool isCheck_policy = false;
  bool isCheck_event = false;


  @override
  void dispose() {
    _nameTextController.dispose();
    _nickNameTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Utility().hideKeyboard(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: Text(
            "회원가입",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: padding_side),
          color: Colors.white,
          child:  Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(context,'이름',sized_35),
                TextFormField(
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
                  controller: _nameTextController,
                  keyboardType: TextInputType.text,
                  cursorColor: BasicColor.primary,
                  validator: (text) {

                    return Validator().validateNull(text?.trim(), '이름을 입력해주세요');
                  },
                  decoration:  textInputDecor_grey(sized_5,
                      hint: "이름을 입력 하세요",

                      ),

                ),
                _title(context,'닉네임',sized_30),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
                        controller: _nickNameTextController,
                        keyboardType: TextInputType.text,
                        cursorColor: BasicColor.primary,
                        onChanged:(text){
                          if(text.isEmpty){
                            setState(() {
                              nickNmCheck = null;
                            });
                          }
                        } ,
                        validator: (text) {
                          if (text!.isNotEmpty) {
                            return null;
                          } else {
                            return '닉네임을 입력해주세요';
                          }
                        },
                        decoration:  textInputDecor_grey(sized_5,
                          hint: "닉네임을 입력 하세요",
                        ),
                      ),
                    ),
                    widthSizeBox(sized_10),

                    SizedBox(
                      width: sized_100,
                      height: sized_48,
                      child: ElevatedButton(
                          style: primary_btn_style(),
                          onPressed: (){
                            var nickNm = _nickNameTextController.text;
                            if(nickNm != "" ){
                              Provider.of<UserNotifier>(context,listen: false).nicknameCheck(context, nickNm).then((value){
                                setState(() {
                                  nickNmCheck = value;
                                });
                              });
                            }else{

                            }
                          }, child: Text('중복확인',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey2),)),
                    ),
                  ],
                ),
                Visibility(
                  visible: nickNmCheck != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: sized_8,left: sized_10),
                    child: Text(nickNmCheck ?? false ? nickNm_success : nickNm_fail, style: Theme.of(context).textTheme.bodySmall!.copyWith(color:nickNmCheck ?? false ? BasicColor.primary : BasicColor.red,),),
                  ),
                ),
                heightSizeBox(sized_40),

              _checkBox(context,'전체 이용약관에 동의합니다.',CheckBoxStatus.all, isCheck_all,handleCheckboxTap,boxDecoration: grayDecor2()),
                heightSizeBox(sized_26),
                _checkBox(context,'만 14세 이상입니다. (필수)',CheckBoxStatus.age,isCheck_age,handleCheckboxTap,),
                _checkBox(context,'이용약관에 동의합니다. (필수)',CheckBoxStatus.terms,isCheck_terms,handleCheckboxTap,),
                _checkBox(context,'개인정보 수집/이용에 동의합니다. (필수)',CheckBoxStatus.policy,isCheck_policy,handleCheckboxTap,),
                _checkBox(context,'이벤트 및 혜택 알림에 동의합니다. (선택)',CheckBoxStatus.event,isCheck_event,handleCheckboxTap,),




                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _signUpButton(context)),
                ),

                heightSizeBox(sized_30)






                // TextButton(onPressed: (){
                //   _showModalBottomSheet();
                // }, child: Text('사진등록')),
                //
                // SizedBox(height: sized_20,),
                // TextButton(onPressed: (){
                //   if(_ximage != null ) {
                //     setProfileImg(_ximage!);
                //   }
                // }, child: Text('api등록')),
                // SizedBox(height: sized_20,),
                // Visibility(
                //   visible: _ximage != null,
                //   child: SizedBox(
                //     width: sized_60,
                //     height: sized_60,
                //     child: Image.file(
                //       File(_ximage != null ? _ximage!.path : ""),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                // CircularPercentIndicator(
                //   radius: 50.0,
                //   lineWidth: 10.0,
                //   percent:progressValue,
                //   header: new Text("Icon header"),
                //   center: new Icon(
                //     Icons.person_pin,
                //     size: 50.0,
                //     color: Colors.blue,
                //   ),
                //   backgroundColor: Colors.grey,
                //   progressColor: Colors.blue,
                // ),

                // LinearPercentIndicator(
                //   padding: EdgeInsets.zero,
                //   percent: progressValue,
                //   lineHeight: 10,
                //   backgroundColor: Colors.black38,
                //   progressColor: Colors.indigo.shade900,
                //   width: MediaQuery.of(context).size.width,
                // ),


              ],
            ),
          ) ,

        ),
      ),
    );
  }

  Container _checkBox(BuildContext context , String title,CheckBoxStatus checkBoxStatus, bool isChecked, Function(CheckBoxStatus) onTap,{BoxDecoration? boxDecoration}) {
    return Container(
                decoration: boxDecoration,
                padding:checkBoxStatus == CheckBoxStatus.all ? EdgeInsets.all( sized_10) :EdgeInsets.only(left:sized_10,bottom: sized_10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => onTap(checkBoxStatus),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: isChecked
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
                    Text(title,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: isChecked ? BasicColor.darkgrey : BasicColor.lightgrey2 , fontWeight: FontWeight.w500),),
                  ],
                ),
              );
  }

  void handleCheckboxTap(CheckBoxStatus checkBoxStatus) {
    setState(() {
      switch (checkBoxStatus) {
        case CheckBoxStatus.all:
          isCheck_all = !isCheck_all;
          isCheck_age = isCheck_all;
          isCheck_terms = isCheck_all;
          isCheck_policy = isCheck_all;
          isCheck_event = isCheck_all;
          break;
        case CheckBoxStatus.age:
          isCheck_age = !isCheck_age;
          break;
        case CheckBoxStatus.terms:
          isCheck_terms = !isCheck_terms;
          break;
        case CheckBoxStatus.policy:
          isCheck_policy = !isCheck_policy;
          break;
        case CheckBoxStatus.event:
          isCheck_event = !isCheck_event;
          break;
      }
    });
  }


  SizedBox _signUpButton(BuildContext context) {
    return SizedBox(
                  width: double.infinity,
                  height: sized_45,
                  child: ElevatedButton(
                      style:  _signButton_click_possibility() ? primary_btn_style() :disable_btn_style() ,
                      onPressed: (progressValue == 1.0 && _signButton_click_possibility() )? (){
                        Log.logs(TAG, "signupclick");
                    var name = _nameTextController.text;
                    var nickNm = _nickNameTextController.text;

                    if(!(nickNmCheck ?? false)){
                      CustomDialog(funcAction: dialogPop).normalDialog(context, nickName_check, '확인');

                    }else {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<UserNotifier>(context, listen: false).signUp(
                            context, widget.userId,
                            "${widget.userId}${widget.signType}", name, nickNm,
                            widget.signType,handleProgress).then((value){
                              if(value == signupSuccess){
                                CustomDialog(funcAction: dialog_MainPop).normalDialog(context, signUp_success, '확인');
                              }
                        });
                      }
                    }

                  } : null, child: Text('가입하기',style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: _signButton_click_possibility() ?FontWeight.w700 : FontWeight.w600,color: _signButton_click_possibility() ? BasicColor.lightgrey2 : BasicColor.lightgrey4,))),
                );
  }

  Padding _title(BuildContext context,String title, double topSize) {
    return Padding(
              padding:  EdgeInsets.only(top: topSize,bottom: sized_6),
              child: Text(title,style: Theme.of(context).textTheme.displayLarge!.copyWith(color: BasicColor.lightgrey2,fontWeight: FontWeight.w500),),
            );
  }

  Future<dynamic> _showModalBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Center(
                    child: Text('사진찍기',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: BasicColor.primary))),
                onTap: () {
                  getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
                  Navigator.pop(context);
                },
              ),
              Divider(
                color: BasicColor.linegrey,
              ),
              ListTile(
                title: Center(
                    child: Text('앨범에서 선택',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: BasicColor.primary))),
                onTap: () {
                  getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
                  Navigator.pop(context);
                },
              ),
              Divider(
                color: BasicColor.linegrey,
              ),
              Visibility(
                visible: _ximage != null,
                child: ListTile(
                  title: Center(
                      child: Text('사진삭제',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: BasicColor.primary))),
                  onTap: () {
                    setState(() {
                      _ximage = null;
                    });

                    Navigator.pop(context);
                  },
                ),
              ),


            ],
          );
        });
  }

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _ximage = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  bool _signButton_click_possibility(){
    if(isCheck_age == true && isCheck_terms == true && isCheck_policy == true){
      return true;
    }else{
      return false;
    }

  }

  void setProfileImg(XFile file){
    Provider.of<UserNotifier>(context,listen: false).userImg(context,1,file,handleProgress);
  }

  void handleProgress(double progress) {
    Log.logs(TAG, "progress :: $progress");
    setState(() {
      progressValue = progress;
    });
  }

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
  }

  void dialog_MainPop(BuildContext context) async {
    Navigator.pop(context);
    goMain();
  }

  void goMain(){
    context.goNamed(mainRouteName);
  }
}
