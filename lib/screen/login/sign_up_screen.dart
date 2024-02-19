import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../widgets/list/shop_list_tile.dart';

class SignUpScreen extends StatefulWidget {
  final String userId;
  const SignUpScreen({super.key, required this.userId});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  XFile? _ximage;
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  double progressValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
        children: [
          TextButton(onPressed: (){
            _showModalBottomSheet();
          }, child: Text('사진등록')),
          SizedBox(height: sized_20,),
          TextButton(onPressed: (){
            if(_ximage != null ) {
              setProfileImg(_ximage!);
            }
          }, child: Text('api등록')),
          SizedBox(height: sized_20,),
          Visibility(
            visible: _ximage != null,
            child: SizedBox(
              width: sized_60,
              height: sized_60,
              child: Image.file(
                File(_ximage != null ? _ximage!.path : ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent:progressValue,
            header: new Text("Icon header"),
            center: new Icon(
              Icons.person_pin,
              size: 50.0,
              color: Colors.blue,
            ),
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
          ),

          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: progressValue,
            lineHeight: 10,
            backgroundColor: Colors.black38,
            progressColor: Colors.indigo.shade900,
            width: MediaQuery.of(context).size.width,
          ),

          ShopListTile()


        ],
      ) ,

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

  void setProfileImg(XFile file){
    Provider.of<UserNotifier>(context,listen: false).userImg(context,1,file,handleProgress);
  }

  void handleProgress(double progress) {
    setState(() {
      progressValue = progress;
    });
  }
}
