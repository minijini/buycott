import 'package:buycott/api/repository/store_api_repository.dart';
import 'package:buycott/constants/response_code.dart';
import 'package:buycott/data/result_model.dart';
import 'package:buycott/data/store_model.dart';
import 'package:flutter/widgets.dart';
import '../widgets/dialog/custom_dialog.dart';

class StoreNotifier extends ChangeNotifier {
  final String TAG = "StoreNotifier";
  List<StoreModel> _storeList = [];

  /*
    * 가게 등록
    * */
  Future registerStore(
    BuildContext context,
    String apiId,
    int userSrno,
    String storeType,
    String storeTypeNm,
    String storeAddress,
    String storeName,
    String storePhone,
    String storeDesc,
      String x,
      String y,
  ) async {
    final result = await StoreApiRepo().registerStore(apiId,userSrno, storeType, storeTypeNm, storeAddress, storeName, storePhone, storeDesc, x, y);

    if (result != null) {

      if (result.isSuccess(context)) {

        var dataResult = ResultModel.fromJson(result.data);

        _resultDialog(context, dataResult);

      }

    }
  }

  Future getStores(BuildContext context,double x, double y) async{
    final result = await StoreApiRepo().getStores( x, y);

    if (result != null) {

      if (result.isSuccess(context)) {

        var dataResult = ResultModel.fromJson(result.data);
        final _result = dataResult.body.map<StoreModel>((json) {
          return StoreModel.fromJson(json);
        }).toList();

        _storeList.clear();
        _storeList.addAll(_result);

        notifyListeners();
      }

    }
  }

  Future<void> _resultDialog(BuildContext context, ResultModel resultModel) =>
      CustomDialog(funcAction: dialogPop)
          .normalDialog(context, resultModel.msg!, '확인');

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
  }

  List<StoreModel> get storeList => _storeList;
}
