import 'dart:io';

import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/utils/utility.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/dialog/custom_dialog.dart';
import '../../widgets/style/button_decor.dart';
import '../../widgets/style/input_decor.dart';


class MyProfileEditScreen extends StatefulWidget {
  const MyProfileEditScreen({super.key});

  @override
  State<MyProfileEditScreen> createState() => _MyProfileEditScreenState();
}

class _MyProfileEditScreenState extends State<MyProfileEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPushYN = false;

  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  String? profileImg;
  XFile? _ximage;


  TextEditingController _nickNameTextController = TextEditingController();
  bool? nickNmCheck;

  double progressValue = 1.0;



  @override
  void initState() {
    super.initState();
    _isPushYN = userModel?.pushYn == "Y" ? true : false;


    profileImg = context.read<UserNotifier>().profileImg;
    _nickNameTextController.text = userModel?.nickname ?? "";
  }

  @override
  void dispose() {
    _nickNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -10,
          title: Text(
            "내 정보 관리",
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
      body: Form(
        key: _formKey,
        child: Container(
          width: size!.width,
          height: size!.height,
          padding: EdgeInsets.symmetric(horizontal: padding_side),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSizeBox(sized_35),
              Center(child: _profileImg()),
              heightSizeBox(sized_20),
              Padding(
                padding:  EdgeInsets.only(bottom: sized_6),
                child: Text("닉네임",style: Theme.of(context).textTheme.displayLarge!.copyWith(color: BasicColor.lightgrey2),),
              ),
              _changeNicknm(context),
              Visibility(
                visible: nickNmCheck != null,
                child: Padding(
                  padding: const EdgeInsets.only(top: sized_8,left: sized_10),
                  child: Text(nickNmCheck ?? false ? nickNm_success : nickNm_fail, style: Theme.of(context).textTheme.bodySmall!.copyWith(color:nickNmCheck ?? false ? BasicColor.primary : BasicColor.red,),),
                ),
              ),
              heightSizeBox(sized_20),
              _pushSwitch(),
             Expanded(child: Align(
                 alignment: Alignment.bottomCenter,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     _editProfileButton(context),
                     heightSizeBox(sized_10),
                     GestureDetector(
                       onTap: (){
                         context.goNamed(withdrawalRouteName);
                       },
                       child: Container(
                           decoration:  BoxDecoration(
                               border: Border(
                                   bottom: BorderSide(color: BasicColor.linegrey,width: 0.5))
                           ),
                           child: Text('회원탈퇴를 원하시나요?',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize:sized_11,color: BasicColor.linegrey),)),
                     ),
                     heightSizeBox(sized_30),
                   ],
                 )))
            ],
          ),
        ),
      ),
    );
  }

  Row _changeNicknm(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (text == userModel?.nickname) {
                        setState(() {
                          nickNmCheck = null;
                        });
                        return '기존 닉네임과 동일합니다';
                      }else if(text!.isNotEmpty ){
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
                        Utility().hideKeyboard(context);

                        var nickNm = _nickNameTextController.text;
                        if (_formKey.currentState!.validate()) {
                        if(nickNm != "" ){
                          Provider.of<UserNotifier>(context,listen: false).nicknameCheck(context, nickNm).then((value){
                            setState(() {
                              nickNmCheck = value;
                            });
                          });
                        }}
                      }, child: Text('중복확인',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey2),)),
                ),
              ],
            );
  }

  Widget _profileImg() {
    return GestureDetector(
      onTap: (){
        _showModalBottomSheet();
      },
      child: Stack(
              children: [
                _ximage != null ?ClipOval(
                  child: SizedBox(
                        width: sized_80,
                        height: sized_80,
                        child: Image.file(
                          File(_ximage != null ? _ximage!.path : ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                ) : CircleImage(
                  img: profileImg,
                  size: sized_80,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: sized_20,
                    height: sized_20,
                    decoration: profileImgDecor(Colors.white),
                    child: Icon(Icons.add,size: sized_15,color: Colors.white,),
                  ),
                )
              ],
            ),
    );
  }


  SizedBox _editProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: sized_45,
      child: ElevatedButton(
          style:  _editProfileButton_click_possibility() ? primary_btn_style() :disable_btn_style() ,
          onPressed: (progressValue == 1.0 && _editProfileButton_click_possibility() )? (){
            Utility().hideKeyboard(context);

            if(!(nickNmCheck ?? false)){
              CustomDialog(funcAction: dialogPop).normalDialog(context, nickName_check, '확인');

            }else {

                if(nickNmCheck == true){
                  modifyNickname();
                }
            }

          } : null, child: Text('수정완료',style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: _editProfileButton_click_possibility() ?FontWeight.w700 : FontWeight.w600,color: _editProfileButton_click_possibility() ? BasicColor.lightgrey2 : BasicColor.lightgrey4,))),
    );
  }

  bool _editProfileButton_click_possibility(){
    if(nickNmCheck == true || _ximage != null){
      return true;
    }else{
      return false;
    }
  }

  Widget _pushSwitch(){
    return Row(
      children: [
        Text('푸시허용',
            style:Theme.of(context).textTheme.displayLarge!.copyWith(color: BasicColor.lightgrey2)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AdvancedSwitch(
              initialValue : _isPushYN,
              activeColor: BasicColor.primary,
              inactiveColor: BasicColor.linegrey,
              activeChild: Text('ON'),
              inactiveChild: Text('OFF'),
              borderRadius: BorderRadius.all(const Radius.circular(15)),
              width: 65.0,
              height: 30.0,
              enabled: true,
              disabledOpacity: 0.5,
              onChanged: (value) {
                setState(() {
                  _isPushYN = value;
                });
                Provider.of<UserNotifier>(context, listen: false).pushSetting(userSrno!,_isPushYN ? 'Y' : 'N');
              },
            ),
          ),

            // child: Align(
            //     alignment: Alignment.centerRight,
            //     child: Container(
            //       width: sized_45,
            //       height: sized_5,
            //       child: Transform.scale(
            //         scale: 0.7,
            //         child: CupertinoSwitch(
            //           // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //           value: _isPushYN,
            //           activeColor: BasicColor.primary,
            //           thumbColor: BasicColor.linegrey,
            //           trackColor: BasicColor.linegrey,
            //           onChanged: (bool value) {
            //             setState(() {
            //               _isPushYN = value;
            //             });
            //             Provider.of<UserNotifier>(context, listen: false).pushSetting(userSrno!,_isPushYN ? 'Y' : 'N');
            //           },
            //         ),
            //       ),
            //     ))
        ),
      ],
    );
  }

  Future<dynamic> _showModalBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
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
                            .copyWith(color: BasicColor.primary2))),
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
                            .copyWith(color: BasicColor.primary2))),
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
                              .copyWith(color: BasicColor.primary2))),
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

      if(_ximage != null){
        setProfileImg(_ximage!);
      }
    }
  }

  void modifyNickname(){
    Provider.of<UserNotifier>(context,listen: false).modifyNickname(context, userSrno!, _nickNameTextController.text);
  }


  void setProfileImg(XFile file){
    Provider.of<UserNotifier>(context,listen: false).userImg(context,userSrno!,file,handleProgress);
  }

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
  }

  void dialogProfilePop(BuildContext context) async {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void handleProgress(double progress) {
    setState(() {
      progressValue = progress;
    });
  }
}
