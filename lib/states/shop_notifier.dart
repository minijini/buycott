
import 'package:buycott/data/result_model.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/repository/shop_api_repository.dart';
import '../api/repository/user_api_repository.dart';
import '../constants/response_code.dart';
import '../constants/sharedpreference_key.dart';
import '../constants/status.dart';
import '../constants/constants.dart';
import '../data/place_result_model.dart';
import '../utils/code_dialog.dart';
import '../utils/utility.dart';
import '../widgets/dialog/custom_dialog.dart';

class ShopNotifier extends ChangeNotifier{
  final String TAG = "ShopNotifier";
  String? _token ;


  /*
    * 장소 검색
    * */
  Future placeSearch(BuildContext context , String query) async{
    final result = await ShopApiRepo().placeSearch(query);

    if (result != null) {

        if(result.documents != null) {

          final _dataResult = result.documents!;

          for (var place in _dataResult) {
            Log.logs(TAG, "place name :: ${place.placeName}");
          }

        }

    }

    return false;
  }


    Future<void> _resultDialog(BuildContext context, ResultModel resultModel) => CustomDialog(funcAction: dialogPop).normalDialog(context, resultModel.msg!, '확인');

    void dialogPop(BuildContext context) async {
      Navigator.pop(context);
    }


}

