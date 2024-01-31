import 'dart:convert';

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

  PlaceApiRepo(){
  }

  /*
  * 장소 검색(kakao)
  * */
  Future<PlaceResultModel?> placeSearch(String query) async {

    String url = Api.placeUrl;

    Map<String, dynamic>? queryParameters = { PARAM_QUERY: query};

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters,userTokenHeader: false);

      if (response != null) {
        return PlaceResultModel.fromJson(response.data);
      }

    } catch (e) {
     return null;
    }
  }



}
