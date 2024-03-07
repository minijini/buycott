import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/screen/store/store_detail_screen.dart';
import 'package:buycott/widgets/circle_progressbar.dart';
import 'package:buycott/widgets/square_image.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../constants/screen_size.dart';
import '../../states/store_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/validator.dart';
import '../../widgets/dialog/custom_dialog.dart';
import '../../widgets/style/button_decor.dart';
import '../../widgets/style/input_decor.dart';

class ReviewWriteScreen extends StatefulWidget {
  final String storeSrno;

  const ReviewWriteScreen({super.key, required this.storeSrno});

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double progressValue = 1.0;

  double _rating = 4;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  final int _maxImageCount = 2; // 최대 선택 개수


  @override
  void dispose() {
    _contentController.dispose();
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
          "리뷰 작성",
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child:
                Container(
                  width: size!.width,
                  child: Column(
                    children: [
                      _storeInfo(),
                      divider(),
                      heightSizeBox(sized_30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding_side),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title(context,"리뷰 작성란"),
                            heightSizeBox(sized_15),
                            _contentTextField(context),
                            heightSizeBox(sized_30),
                            _title(context,"만족도"),
                            heightSizeBox(sized_15),
                            _ratingBar(),
                            heightSizeBox(sized_30),
                            _title(context,"사진 첨부 (최대 2장)"),
                            heightSizeBox(sized_6),
                            Text("리뷰 내용과 상관없는 사진 첨부시 통보없이 삭제될 수 있습니다.",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: BasicColor.darkgrey),),
                            heightSizeBox(sized_15),
                            _imgAdd(),
                            heightSizeBox(20),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),

            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _review_add_Button(context))),
            Visibility(
                visible: progressValue != 1.0,
                child: CustomCircularProgress())
          ],
        ),
      ),
    );
  }

  Padding _review_add_Button(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sized_30,horizontal: padding_side),
      child: SizedBox(
        width: double.infinity,
        height: sized_45,
        child: ElevatedButton(
            style:   primary_btn_style() ,
            onPressed: (progressValue == 1.0)? (){
              if (_formKey.currentState!.validate()) {
                Provider.of<StoreNotifier>(context, listen: false)
                    .registerReview(
                    context, userSrno.toString(), widget.storeSrno,
                    _contentController.text, _rating.toInt(), handleProgress,
                    fileList: _images)
                    .then((value) {
                  if (value) {
                    CustomDialog(funcAction: dialogPop)
                        .normalDialog(context, review_success, '확인');
                  }
                });
              }

            } : null, child: Text('등록하기',style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w700 ,color:BasicColor.lightgrey2,))),
      ),
    );
  }

  Container _contentTextField(BuildContext context) {
    return Container(
                            height: 200,
                            child: TextFormField(
                                maxLength: 200,
                                expands: true,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.darkgrey),
                                controller: _contentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                cursorColor: BasicColor.primary,
                                textAlignVertical: TextAlignVertical.top,
                                validator: (text) {
                                  return Validator().validateNull(text?.trim(), '내용을 입력해주세요');
                                },
                                decoration:  textInputDecor_grey(0,
                                  hint: "방문일, 맛, 서비스, 위치 등 후기를 자유롭게 남겨주세요.",
                                ).copyWith(hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.darkgrey))
                            ),
                          );
  }

  Row _imgAdd() {
    return Row(
                            children: [
                              Visibility(
                                visible :_images.isNotEmpty,
                                child: Container(
                                  width: _images.length == 2 ? size!.width - 206 :size!.width - 286 ,
                                  height: sized_70,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _images.length > 2 ? 2 : _images.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(right: sized_10),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: sized_70,
                                            height: sized_70,
                                            child: Image.file(
                                              File(_images[index].path),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: -10,
                                            right: -10,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _images.remove(_images[index]);
                                                });
                                                //TODO: image cnt print
                                                // for (var i = 0; i < _images.length; i++) {
                                                //   print('path : ${_images[i].path} , name : ${_images[i].name}');
                                                // }
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: BasicColor.darkgrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _images.length != 2 ,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_images != null) {
                                      _images.clear();
                                    }

                                    try {
                                      final List<XFile>? selectedImages =
                                      await _picker.pickMultiImage(imageQuality: 100);

                                      setState(() {
                                        if (selectedImages!.isNotEmpty) {

                                          // 최대 선택 개수를 넘지 않도록 리스트에 추가
                                          _images =
                                              selectedImages.take(_maxImageCount).toList();

                                          // _images.addAll(selectedImages);
                                        } else {
                                          debugPrint('no image select');
                                        }
                                      });
                                    } catch (e) {
                                      debugPrint(' image picker error: $e');
                                    }
                                  },
                                  child: Container(
                                    width: sized_70,
                                    height: sized_70,
                                    decoration: imgDecor(BasicColor.linegrey, ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        size: sized_30,
                                        color: BasicColor.linegrey,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
  }

  RatingBar _ratingBar() {
    return RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            allowHalfRating: false,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemSize: 30,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color:BasicColor.yellow_star
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                              });
                            },
                          );
  }

  Text _title(BuildContext context,String title) => Text(title,style: Theme.of(context).textTheme.displayLarge,);

  Widget _storeInfo(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding_side,vertical: sized_20),
      child: Row(
        children: [
        SquareImage(img: "img",width: sized_70,height: sized_50,),
          widthSizeBox(sized_12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("가게이름",style: Theme.of(context).textTheme.displayMedium,),
              heightSizeBox(sized_4),
              Text("가게주소",style: Theme.of(context).textTheme.bodySmall,)
            ],
          )

      ],),
    );
  }

  void registerReview(BuildContext context) {

    Provider.of<StoreNotifier>(context, listen: false).registerReview(
        context, userSrno.toString(), widget.storeSrno, _contentController.text, _rating.toInt(),handleProgress, fileList: _images).then((value){
          if(value){
            CustomDialog(funcAction: dialogPop)
                .normalDialog(context, review_success, '확인');
          }
    });
  }

  void handleProgress(double progress) {
    setState(() {
      progressValue = progress;
    });
  }

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
    goStoreDetail();
  }

  void goStoreDetail(){
    context.goNamed(storeDetailRouteName,pathParameters: {
      'storeSrno' : widget.storeSrno
    });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => StoreDetailScreen(storeSrno: widget.storeSrno,)),
    // );
  }


}
