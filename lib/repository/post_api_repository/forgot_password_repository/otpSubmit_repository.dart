import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class OtpSubmitRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> OtpSubmitApi(var data) async {
    dynamic response = await _apiService.postApi(data, AppUrl.otpSubmitApiurl);
    return response;
  }
}
