import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/data/place_result_model.dart';
import 'package:buycott/screen/place/shop_list_screen.dart';
import 'package:buycott/states/store_notifier.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/validator.dart';
import '../../widgets/UnanimatedPageRoute.dart';
import '../../widgets/dialog/custom_dialog.dart';
import '../../widgets/style/button_decor.dart';
import '../../widgets/style/container.dart';
import '../../widgets/style/input_decor.dart';
import '../place/address_list_screen.dart';

class Arguments {
  Place place; //반환때 사용할 클래스
  Arguments({required this.place});
}

class StoreAddScreen extends StatefulWidget {
  const StoreAddScreen({super.key});

  @override
  State<StoreAddScreen> createState() => _StoreAddScreenState();
}

class _StoreAddScreenState extends State<StoreAddScreen> {
  final TAG = "StoreAddScreen";
  TextEditingController _storeDescController = TextEditingController();
  TextEditingController _storePrpReasonController = TextEditingController();
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _storeAddressController = TextEditingController();
  Place? storeModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _storeDescController.dispose();
    _storeNameController.dispose();
    _storeAddressController.dispose();
    _storePrpReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '가게 제안',
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
        padding: EdgeInsets.symmetric(horizontal: padding_side),
        color: Colors.white,
        child:  Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _title(context,'가게명',sized_30),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
                      controller: _storeNameController,
                      keyboardType: TextInputType.text,
                      cursorColor: BasicColor.primary,
                      decoration:  textInputDecor_grey(sized_5,
                        hint: "",
                      ),
                    ),
                  ),
                  widthSizeBox(sized_10),
                  SizedBox(
                    width: sized_100,
                    height: sized_48,
                    child: ElevatedButton(
                        style: primary_btn_style(),
                        onPressed: ()async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShopListScreen()),
                          );

                          if(result != null){
                            setState(() {
                              storeModel = result.place;
                              _storeNameController.text = storeModel?.placeName ?? "";
                              _storeAddressController.text = storeModel?.addressName ?? "";
                            });
                          }
                        }, child: Text('검색하기',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey2),)),
                  ),
                ],
              ),
              _title(context,'가게주소',sized_35),
              TextFormField(
                readOnly: true,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
                controller: _storeAddressController,
                keyboardType: TextInputType.text,
                cursorColor: BasicColor.primary,
                decoration:  textInputDecor_grey(sized_5,
                  hint: "",

                ),

              ),
              _title(context,'가게를 제안하는 이유를 알려주세요! (필수)',sized_30),
              _contentTextField(context),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _storeRegisterButton(context)),
              ),

              heightSizeBox(sized_30)
            ],
          ),
        ) ,

      ),

    );
  }

  Padding _title(BuildContext context,String title, double topSize) {
    return Padding(
      padding:  EdgeInsets.only(top: topSize,bottom: sized_6),
      child: Text(title,style: Theme.of(context).textTheme.displayLarge!.copyWith(color: BasicColor.lightgrey2,fontWeight: FontWeight.w500),),
    );
  }

  SizedBox _storeRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: sized_45,
      child: ElevatedButton(
          style:  _storeRegisterButton_click_possibility() ? primary_btn_style() :disable_btn_style() ,
          onPressed: ( _storeRegisterButton_click_possibility() )? (){

              if (_formKey.currentState!.validate()) {
                if(storeModel != null) {
                  registerStore(storeModel!);
                }
              }

          } : null, child: Text('등록하기',style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: _storeRegisterButton_click_possibility() ?FontWeight.w700 : FontWeight.w600,color: _storeRegisterButton_click_possibility() ? BasicColor.lightgrey2 : BasicColor.lightgrey4,))),
    );
  }

  bool _storeRegisterButton_click_possibility(){
    if(storeModel != null && _storePrpReasonController.text.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  Container _contentTextField(BuildContext context) {
    return Container(
      height: 200,
      child: TextFormField(
          maxLength: 200,
          expands: true,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.darkgrey),
          controller: _storePrpReasonController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: BasicColor.primary,
          textAlignVertical: TextAlignVertical.top,
          validator: (text) {
            return Validator().validateNull(text?.trim(), '내용을 입력해주세요');
          },
          decoration:  textInputDecor_grey(5,
            hint: "해당 가게를 제안 하는 이유를 입력 해 주세요",
          ).copyWith(hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.darkgrey))
      ),
    );
  }

  void registerStore(Place storeModel) {
    Provider.of<StoreNotifier>(context, listen: false).registerStore(
        context,
        storeModel.id!,
        userSrno!,
        storeModel.categoryGroupCode!,
        storeModel.categoryGroupName!,
        storeModel.roadAddressName!,
        storeModel.placeName!,
        storeModel.phone!,
        _storeDescController.text,
        _storePrpReasonController.text,
        storeModel.x!,
        storeModel.y!).then((value){
          if(value){
            _resultDialog(context);
          }
    });
  }

  Future<void> _resultDialog(BuildContext context,) =>
      CustomDialog(funcAction: dialogPop)
          .normalDialog(context, store_register_text, '확인');

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
    goMain();
  }


  void goMain(){
    context.goNamed(mainRouteName);
  }


}
