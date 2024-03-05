import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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
    String prpReason,
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
      PARAM_PRPREASON: prpReason, //제안이유
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
  * 가게상세조회
  * */
  Future<BaseModel?> storeDetail(int storeSrno,{BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.store_search;

    Map<String, dynamic>? queryParameters = { PARAM_STORESRNO: storeSrno};


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
  * 리뷰등록
  * */
  Future<BaseModel?> registerReview(
      String userSrno,
      String storeSrno,
      String reviewContent,
      int score,{BuildContext? context,List<XFile>? fileList}
      ) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.review;

    final multipartImageList = fileList != null ? fileList.map((image) =>
        MultipartFile.fromFileSync(image.path, filename: image.name,
            contentType: MediaType("image", "jpeg"))).toList() : [];


    var formData = FormData.fromMap({
      PARAM_USERSRNO : userSrno,
      PARAM_STORESRNO : storeSrno,
      PARAM_REVIEWCONTENT : reviewContent,
      PARAM_SCORE : score,
      PARAM_FILES : multipartImageList,
    });

    try {
      final response = await apiUtils.post(url: url, data: formData);

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
  Future<BaseModel?> getReviews(String storeSrno,int pageNum, int limit) async {
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
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }


}
