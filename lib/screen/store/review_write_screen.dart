import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/screen/store/store_detail_screen.dart';
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

  double _rating = 4;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  final int _maxImageCount = 4; // 최대 선택 개수


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
        title: Text(
          "리뷰 작성",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  registerReview(context);
                }
              },
              icon: Icon(
                Icons.check,
                size: 30,
              ))
        ],
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          width: size!.width,
          padding: EdgeInsets.symmetric(horizontal: padding_side),
          child: Column(
            children: [
              RatingBar.builder(
                initialRating: 4,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                allowHalfRating: false,
                itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                itemSize: 30,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              heightSizeBox(sized_16),
              Text('현재 별점: ${_rating.toInt()}'),
              heightSizeBox(sized_30),
              GestureDetector(
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
                child: Row(
                  children: [
                    Text(
                      '첨부',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: BasicColor.darkgrey),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      // 패딩 설정 iconbutton zero
                      constraints: BoxConstraints(),
                      // constraints
                      icon: Icon(Icons.attach_file),
                      iconSize: sized_16,
                      onPressed: null,
                    ),
                    line(color: BasicColor.darkgrey),
                    Text('최대 4개',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              ...List.generate(
                  _images.length > 4 ? 4 : _images.length,
                  (index) => Container(
                        width: size!.width,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: sized_10,
                                        horizontal: padding_side),
                                    width: sized_30,
                                    height: sized_30,
                                    child: Image.file(
                                      File(_images[index]!.path),
                                      fit: BoxFit.cover,
                                    )),
                                SizedBox(
                                  width: (size?.width)! - 150,
                                  child: AutoSizeText(_images[index].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              color: BasicColor.darkgrey)),
                                ),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
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
                                ))
                              ],
                            ),
                            divider()
                          ],
                        ),
                      )),
              heightSizeBox(20),
              Container(
                height: 200,
                child: TextFormField(
                  maxLength: 200,
                  expands: true,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                    maxLines: null,
                  cursorColor: BasicColor.primary,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (text) {
                    return Validator().validateNull(text?.trim(), '내용을 입력해주세요');
                  },
                  decoration:  textInputDecor_grey(
                    hint: "내용을 입력 하세요",
                  )


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerReview(BuildContext context) {

    Provider.of<StoreNotifier>(context, listen: false).registerReview(
        context, userSrno.toString(), widget.storeSrno, _contentController.text, _rating.toInt(), fileList: _images).then((value){
          if(value){
            CustomDialog(funcAction: dialogPop)
                .normalDialog(context, review_success, '확인');
          }
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
