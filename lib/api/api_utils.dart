import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/basic_text.dart';
import '../states/user_notifier.dart';
import '../utils/code_dialog.dart';
import '../utils/log_util.dart';
import '../widgets/dialog/custom_dialog.dart';
import 'custom_log_interceptor.dart';

final title = "ApiUtils";

ApiUtils apiUtils = ApiUtils();

class ApiUtils {
  static ApiUtils _apiUtils = ApiUtils._i();
  final Dio _dio = Dio();

  ApiUtils._i() {
    _dio.interceptors.add(CustomLogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
    ));
  }

  factory ApiUtils() {
    return _apiUtils;
  }

  Map<String, String> header = {"Content-Type": "application/json"};

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "api-version": "1"
  };

  Map<String, String> secureHeaders = {
    "Content-Type": "application/json",
    "api-version": "1",
    "Access_Token": ""
  }; //Access_Token

  String generateBoundary() {
    return '------------------------${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<Response> get(
      {required String url,
      Map<String, dynamic>? queryParameters,
      Options? options,
      bool userTokenHeader = true}) async {
    var result = await _dio.get(url,
        queryParameters: queryParameters,
        options: userTokenHeader
            ? null
            : Options(headers: {"Authorization": kakao_response_key}));
    return result;
  }

  Future<Response> getWithProgress(
      {required String url,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ProgressCallback? onReceiveProgress,
        bool userTokenHeader = true}) async {
    var result = await _dio.get(url,
        queryParameters: queryParameters,
        onReceiveProgress:onReceiveProgress ,
        options: userTokenHeader
            ? null
            : Options(headers: {"Authorization": kakao_response_key}));
    return result;
  }

  Future<Response> post({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    //Sending FormData:
    //FormData formData = FormData.fromMap({"name": ""});

    var result = await _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return result;
  }


  Future<Response> postWithProgress({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    //
    var result = await _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
    );
    return result;
  }

  Future<Response> put({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    var result = await _dio.put(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return result;
  }

  Future<Response> delete({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    //Options options = Options(headers: secureHeaders);

    //var result = await _dio.delete(api, options: options);
    var result = await _dio.delete(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return result;
  }

  String handleError(dynamic error,{BuildContext? context}) {
    String errorDescription = "";

    Log.loga(title, "handleError:: error >> $error");

    if (error is DioError) {
      Log.loga(
          title, '************************ DioError ************************');

      DioError dioError = error as DioError;
      Log.loga(title, 'dioError:: $dioError');

      if (dioError.response != null) {
        Log.loga(
            title, "dioError:: response >> " + dioError.response.toString());

      }

      if (dioError.response?.statusCode == 403) {
        if(context != null) {
          Provider
              .of<UserNotifier>(context, listen: false)
              .logout();
        }

        Log.loga(title,'403 Forbidden: ${dioError.message}');
      }

      switch (dioError.type) {
        case DioErrorType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioErrorType.connectionTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.badCertificate:
          errorDescription = 'Caused by an incorrect certificate';
          break;
        case DioErrorType.badResponse:
          errorDescription =
              "Received invalid status code: ${dioError.response?.statusCode}";
          break;
        case DioErrorType.connectionError:
          errorDescription =
              'Caused for example by a `xhr.onError` or SocketExceptions.';
          break;
        case DioErrorType.unknown:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    Log.loga(title, "handleError:: errorDescription >> $errorDescription");

    // if(context != null) {
    //   CustomDialog(funcAction: (BuildContext context) async {
    //     Navigator.pop(context);
    //   })
    //       .normalDialog(context, errorDescription.toString(), '확인');
    // }

    return errorDescription;
  }

  getFormattedError() {
    return {'error': 'Error'};
  }

  getNetworkError() {
    return "No Internet Connection.";
  }
}
