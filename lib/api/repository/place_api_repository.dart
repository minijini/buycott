import 'dart:convert';

import 'package:buycott/data/address_result_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/basic_text.dart';
import '../../constants/sharedpreference_key.dart';
import '../../data/base_model.dart';
import '../../data/place_result_model.dart';
import '../api_end_points.dart';
import '../api_params.dart';
import '../api_url.dart';
import '../api_utils.dart';

class PlaceApiRepo {

  /*
  * 장소 검색(kakao)
  * */
  Future<PlaceResultModel?> placeSearch(String query,int pageIndex) async {

    String url = Api.placeUrl + ApiEndPoints.kakao_keyword;

    Map<String, dynamic>? queryParameters = { PARAM_QUERY: query,PARAM_PAGE : pageIndex};

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters,userTokenHeader: false);

      if (response != null) {
        return PlaceResultModel.fromJson(response.data);
      }

    } catch (e) {
     return null;
    }
  }

  /*
  * 주소 검색(kakao)
  * */
  Future<AddressResultModel?> addressSearch(String query,int pageIndex) async {

    String url = Api.placeUrl + ApiEndPoints.kakao_address;

    Map<String, dynamic>? queryParameters = { PARAM_QUERY: query,PARAM_PAGE : pageIndex,PARAM_SIZE : 25};

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters,userTokenHeader: false);

      if (response != null) {
        return AddressResultModel.fromJson(response.data);
      }

    } catch (e) {
      return null;
    }
  }







}
