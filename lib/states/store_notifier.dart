import 'package:buycott/api/repository/store_api_repository.dart';
import 'package:buycott/constants/response_code.dart';
import 'package:buycott/data/result_model.dart';
import 'package:buycott/data/review_model.dart';
import 'package:buycott/data/store_model.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/dialog/custom_dialog.dart';

class StoreNotifier extends ChangeNotifier {
  final String TAG = "StoreNotifier";
  List<StoreModel> _storeList = [];
  List<StoreModel> _mainStoreList = [];
  List<Review> _reviewListData = [];
  List<Review> _reviewList = [];
  StoreModel? _storeModel;


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
    String prpReason,
      String x,
      String y,
  ) async {
    final result = await StoreApiRepo().registerStore(apiId,userSrno, storeType, storeTypeNm, storeAddress, storeName, storePhone, storeDesc,prpReason, x, y);

    if (result != null) {

      if (result.isSuccess(context: context)) {

        var dataResult = ResultModel.fromJson(result.data);

        _resultDialog(context, dataResult);

      }

    }
  }

  Future getStores(BuildContext context,double x, double y,{String? storeType}) async{
    final result = await StoreApiRepo().getStores( x, y,context: context);

    if (result != null) {
      print("result.statusCode :: ${result.statusCode}");

      if (result.isSuccess(context: context)) {

        var dataResult = ResultModel.fromJson(result.data);
        final _result = dataResult.body.map<StoreModel>((json) {
          return StoreModel.fromJson(json);
        }).toList();

        _storeList.clear();
        _storeList.addAll(_result);

        if(storeType != null){
          final _typeResult = _storeList.where((store) => store.storeType == storeType).toList();

          _storeList.clear();
          _storeList.addAll(_typeResult);
        }

        notifyListeners();
      }
    }
  }

  Future getMainStores() async{
    final result = await StoreApiRepo().getMainStores();

    if (result != null) {

      if (result.isSuccess()) {

        var dataResult = ResultModel.fromJson(result.data);
        final _result = dataResult.body.map<StoreModel>((json) {
          return StoreModel.fromJson(json);
        }).toList();
        _mainStoreList.clear();
        _mainStoreList.addAll(_result);

        notifyListeners();
      }
    }
  }

  Future<StoreModel?> storeDetail(int storeSrno) async{
    final result = await StoreApiRepo().storeDetail(storeSrno);

    if (result != null) {

      if (result.isSuccess()) {

        var dataResult = ResultModel.fromJson(result.data);
        _storeModel = StoreModel.fromJson(dataResult.body);

        notifyListeners();

        return _storeModel;
      }
    }
    return null;
  }

  Future<bool> registerReview( BuildContext context, String userSrno,
      String storeSrno,
      String reviewContent,
      int score,{List<XFile>? fileList}) async{

    final result = await StoreApiRepo().registerReview(userSrno, storeSrno, reviewContent, score,fileList: fileList,context: context);

    if (result != null) {

      if (result.isSuccess(context: context)) {
        var dataResult = ResultModel.fromJson(result.data);

        _reviewList.clear();
        getReviews(storeSrno,1,10);

        notifyListeners();

        return true;

      }
    }

    return false;
  }

  Future<List<Review>> getReviews(
      String storeSrno,
      int pageNum, int limit) async{

    final result = await StoreApiRepo().getReviews( storeSrno, pageNum,  limit);

    if (result != null) {

      if (result.isSuccess()) {
        var dataResult = ResultModel.fromJson(result.data);
        var _reviewModel = ReviewModel.fromJson(dataResult.body);

        if(_reviewModel.review != null){
          _reviewListData.clear();
          _reviewListData.addAll(_reviewModel.review!);


          for (var review in _reviewListData) {
            _reviewList.add(review);
          }

        }

        notifyListeners();

        return _reviewListData;

      }
    }
    return [];
  }


  Future<void> _resultDialog(BuildContext context, ResultModel resultModel) =>
      CustomDialog(funcAction: dialogPop)
          .normalDialog(context, resultModel.msg!, '확인');

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
  }

  List<StoreModel> get storeList => _storeList;
  List<StoreModel> get mainStoreList => _mainStoreList;
  List<Review> get reviewList => _reviewList;
  StoreModel? get storeModel => _storeModel;
}
