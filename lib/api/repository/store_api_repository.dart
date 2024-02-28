import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import '../../data/base_model.dart';
import '../api_end_points.dart';
import '../api_params.dart';
import '../api_url.dart';
import '../api_utils.dart';

class StoreApiRepo {
  /*
  * 가게등록
  * */
  Future<BaseModel?> registerStore(
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
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.store;

    Map<String, dynamic>? queryParameters = {
      PARAM_APIID: apiId,
      PARAM_USERSRNO : userSrno,
      PARAM_STORETYPE: storeType, //category_group_code
      PARAM_STORETYPENM: storeTypeNm, //category_group_name
      PARAM_STOREADDRESS: storeAddress, // road_address_name + place_name
      PARAM_STORENAME: storeName, //place_name
      PARAM_STOREPHONE: storePhone, //phone
      PARAM_STOREDESC: storeDesc, //가게설명
      PARAM_X: x,
      PARAM_Y: y,
    };

    try {
      final response = await apiUtils.post(url: url, data: queryParameters);

      if (response != null) {
        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }

  /*
  * 지도 -> 가게조회
  * */
  Future<BaseModel?> getStores(double x, double y,{BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.store_map;

    Map<String, dynamic>? queryParameters = { PARAM_X: x,PARAM_Y : y};

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
  }

  /*
  * 메인 -> 가게목록
  * */
 Future<BaseModel?> getMainStores({BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.store_main;

    try {
      final response = await apiUtils.get(url: url);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
  }


  /*
  * 리뷰등록
  * */
  Future<BaseModel?> registerReview(
      String userSrno,
      String storeSrno,
      String reviewContent,
      int score,{BuildContext? context}
      ) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.review;

    Map<String, dynamic>? queryParameters = {
      PARAM_USERSRNO : userSrno,
      PARAM_STORESRNO : storeSrno,
      PARAM_REVIEWCONTENT : reviewContent,
      PARAM_SCORE : score,
    };

    try {
      final response = await apiUtils.post(url: url, data: queryParameters);

      if (response != null) {
        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
  }

  /*
  * 리뷰조회
  * */
  Future<BaseModel?> getReviews(String storeSrno,int pageNum, int limit,{BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.review;

    Map<String, dynamic>? queryParameters = {
      PARAM_STORESRNO : storeSrno,
      PARAM_PAGENUM : pageNum,
      PARAM_LIMIT : limit,
    };

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
  }


}
