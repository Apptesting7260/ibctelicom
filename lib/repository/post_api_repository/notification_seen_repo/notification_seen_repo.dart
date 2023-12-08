import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class NotificationSeenRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> NotificationSeenApi(
      Map<String, String>? head, Map<String, String>? body) async {
    dynamic response =
        await _apiService.postHeaderBodyApi(head, body, AppUrl.notificationSeenAPiUrl);
    return response;
  }
}
