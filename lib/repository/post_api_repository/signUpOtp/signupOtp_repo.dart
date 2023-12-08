import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class SignupOTPRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> SignupOTPApi(var data) async {
    dynamic response = await _apiService.postApi(data, AppUrl.signupOTPApiUrl);
    return response;
  }
}
