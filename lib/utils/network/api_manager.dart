import 'dart:developer';

import 'package:boilerplate/config/app_constants.dart';
import 'package:boilerplate/config/app_routes.dart';
import 'package:boilerplate/config/app_sessions.dart';
import 'package:boilerplate/utils/network/custom_response.dart';
import 'package:boilerplate/utils/zindex.dart';
import 'package:dio/dio.dart';
import 'package:boilerplate/config/app_config.dart';
import 'package:get/route_manager.dart';

Dio dio = Dio();

class APIManager {
  Future<CustomResponse> fetch(String endpoint, body, requestType) async {
    dio.options.baseUrl = AppConfig.apiBaseURL;
    var haveInternet = await helper.isNetworkConnection();
    if (haveInternet) {
      try {
        await _getToken(endpoint);
        log("Requesting to: ${dio.options.baseUrl}${endpoint.toString()}");
        log("Request: ${body.toString()}");
        Response? response;
        switch (requestType) {
          case "get":
            response = await dio.get(endpoint, queryParameters: body);
            break;
          case "post":
            response = await dio.post(endpoint, data: body);
            break;
          case "delete":
            response = await dio.delete(endpoint, data: body);
            break;
          case "put":
            response = await dio.put(endpoint, data: body);
            break;
        }
        log("Response: ${response?.data.toString()}");
        CustomResponse customResponse = await _formatOutput(response, null);
        return customResponse;
      } on DioError catch (err) {
        log(err.message.toString());
        if (err.type == DioErrorType.response) {
          if (err.response != null) {
            return _formatOutput(err.response, null);
          } else {
            return _formatOutput(err.response, null);
          }
        } else {
          rethrow;
        }
      } catch (err) {
        return _formatOutput(null, err.toString());
      }
    } else {
      return _formatOutput(null, AppConstants.noInternetAccess);
    }
  }

  Future<CustomResponse> _formatOutput(
      Response? response, String? message) async {
    CustomResponse _res = CustomResponse(isSuccess: null, message: null);
    if (response != null) {
      if (response.statusCode == 401) {
        helper.cleanStorage();
        Get.offAllNamed(AppRoutes.splash);
        _res.data = 0;
        _res.message = "Unauthorized access!";
        _res.isSuccess = false;
        return _res;
      } else {
        return CustomResponse.fromJson(response.data);
      }
    } else {
      _res.data = 0;
      _res.message = message!;
      _res.isSuccess = false;
      return _res;
    }
  }

  _getToken(String endpoint) async {
    bool _authNeed = AppConstants.noAuthAPIs.contains(endpoint);
    if (!_authNeed) {
      var accessToken = await helper.read(AppSessions.accessToken);
      if (accessToken != null && accessToken != '') {
        dio.options.headers["authorization"] = "Bearer $accessToken";
      }
    }
  }
}
