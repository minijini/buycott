import 'dart:convert';

import 'package:buycott/api/repository/store_api_repository.dart';
import 'package:buycott/constants/response_code.dart';
import 'package:buycott/constants/sharedpreference_key.dart';
import 'package:buycott/data/result_model.dart';
import 'package:buycott/data/review_model.dart';
import 'package:buycott/data/store_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/keyword_Item.dart';
import '../widgets/dialog/custom_dialog.dart';

class StoreNotifier extends ChangeNotifier {
  final String TAG = "StoreNotifier";
  List<StoreModel> _storeList = [];
  List<StoreModel> _mainStoreList = [];
  List<StoreModel> _myStoreList = [];
  List<StoreModel> _searchStoreList = [];
  List<Review> _reviewListData = [];
  List<Review> _reviewList = [];
  List<Review> _myReviewListData = [];
  List<Review> _myReviewList = [];
  List<KeywordItem> _keywordList = [];
  StoreModel? _storeModel;

  /*
    * 가게 등록
    * */
  Future<bool> registerStore(
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
    final result = await StoreApiRepo().registerStore(apiId,userSrno, storeType, storeTypeNm, storeAddress, storeName, storePhone, storeDesc,prpReason, x, y,context: context);

    if (result != null) {

      if (result.isSuccess(context: context)) {

        var dataResult = ResultModel.fromJson(result.data);

        return true;
      }

    }
    return false;
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

  /*
  * 가게이름으로 검색
  * */
  Future searchStores(String word,int? userSrno) async{
    final result = await StoreApiRepo().searchStores(word,userSrno);

    if (result != null) {
      if (result.isSuccess()) {

        var dataResult = ResultModel.fromJson(result.data);
        final _result = dataResult.body.map<StoreModel>((json) {
          return StoreModel.fromJson(json);
        }).toList();

        _searchStoreList.clear();
        _searchStoreList.addAll(_result);

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

  Future<StoreModel?> storeDetail(int storeSrno,int? userSrno) async{
    final result = await StoreApiRepo().storeDetail(storeSrno,userSrno);

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

  Future myStores(BuildContext context,int? userSrno) async{
    final result = await StoreApiRepo().myStores(userSrno,context: context);

    if (result != null) {

      if (result.isSuccess()) {

        var dataResult = ResultModel.fromJson(result.data);
        final _result = dataResult.body.map<StoreModel>((json) {
          return StoreModel.fromJson(json);
        }).toList();

        _myStoreList.clear();
        _myStoreList.addAll(_result);

        notifyListeners();

      }
    }
  }

  Future<bool> registerReview( BuildContext context, String userSrno,
      String storeSrno,
      String reviewContent,
      int score,void Function(double) onProgress,{List<XFile>? fileList}) async{

    final result = await StoreApiRepo().registerReview(userSrno, storeSrno, reviewContent, score,onProgress,fileList: fileList,context: context);

    if (result != null) {

      if (result.isSuccess(context: context)) {
        var dataResult = ResultModel.fromJson(result.data);

        _reviewListReset(storeSrno,userSrno);
        storeDetail(int.parse(storeSrno), int.parse(userSrno));


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

  Future<bool> deleteReview(BuildContext context,String storeSrno,String userSrno,String reviewSrno) async{
    final result = await StoreApiRepo().deleteReview( userSrno, reviewSrno,context:context);

    if (result != null) {

      if (result.isSuccess(context: context)) {
        // _reviewListReset(storeSrno,userSrno);
        storeDetail(int.parse(storeSrno), int.parse(userSrno));
        notifyListeners();

        return true;
      }
    }
    return false;
  }


  Future<List<Review>> myReviews(String userSrno,int pageNum, int limit) async{


    final result = await StoreApiRepo().myReviews( userSrno, pageNum,  limit);

    if (result != null) {

      if (result.isSuccess()) {
        var dataResult = ResultModel.fromJson(result.data);
        var _reviewModel = ReviewModel.fromJson(dataResult.body);

        if(_reviewModel.review != null){
          _myReviewListData.clear();
          _myReviewListData.addAll(_reviewModel.review!);


          for (var review in _myReviewListData) {
            _myReviewList.add(review);
          }

        }

        notifyListeners();

        return _myReviewListData;

      }
    }
    return [];
  }


  Future saveKeywordItems(List<KeywordItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final value = items.map((item) => item.toJson()).toList();
    prefs.setString(KEYWORD_ITEMS, jsonEncode(value));
  }

  Future<List<KeywordItem>> getKeywordItems() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(KEYWORD_ITEMS);

    if (value != null) {
      final List<dynamic> decoded = jsonDecode(value);
      final _keywordResult =  decoded.map((item) => KeywordItem.fromJson(item)).toList();
      _keywordList.addAll(_keywordResult);

      notifyListeners();

      return _keywordList;

    } else {
      _keywordList = [];
      notifyListeners();
      return [];
    }


  }

  void _reviewListReset(String storeSrno,String userSrno) {
    _reviewList.clear();
    getReviews(storeSrno,1,10);
    // _myReviewList.clear();
    // myReviews(userSrno,1,10);
  }

  Future<void> _resultDialog(BuildContext context, ResultModel resultModel) =>
      CustomDialog(funcAction: dialogPop)
          .normalDialog(context, resultModel.msg!, '확인');

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
  }

  List<StoreModel> get storeList => _storeList;
  List<StoreModel> get mainStoreList => _mainStoreList;
  List<StoreModel> get myStoreList => _myStoreList;
  List<StoreModel> get searchStoreList => _searchStoreList;
  List<Review> get reviewList => _reviewList;
  List<Review> get myReviewList => _myReviewList;
  List<KeywordItem> get keywordList => _keywordList;
  StoreModel? get storeModel => _storeModel;
}
