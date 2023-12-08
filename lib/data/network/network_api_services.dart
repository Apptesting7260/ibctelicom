import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
// import 'package:getx_mvvm/data/network/base_api_services.dart';
import 'package:http/http.dart' as http;
import 'package:nauman/data/network/base_api_services.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

import '../app_exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  // Get API
  @override
  Future<dynamic> getApi(String url) async {
    String? token = await UserPreference().getToken();
    if (kDebugMode) {
      print(url);
    }

    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer $token', // Include your authentication token here
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    print(responseJson);
    return responseJson;
  }

//  Post Api
  @override
  Future<dynamic> postApi(var data, String url) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 50));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  // Post Header Body Api
  @override
  Future<dynamic> postHeaderBodyApi(var head, var body, String url) async {
    if (kDebugMode) {
      print(url);
      print(head);
      print(body);
    }

    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), headers: head, body: body)
          .timeout(const Duration(seconds: 50));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  //  Post header api
  @override
  Future<dynamic> postHeaderApi(var data, String url) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), headers: data)
          .timeout(const Duration(seconds: 50));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        throw FetchDataException(
            'Error accoured while communicating with server ' +
                response.statusCode.toString());
    }
  }
}
