import 'package:connectivity_plus/connectivity_plus.dart';

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

  Future<BaseModel?> getStores(double x, double y) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.store;

    Map<String, dynamic>? queryParameters = { PARAM_X: x,PARAM_Y : y};

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
