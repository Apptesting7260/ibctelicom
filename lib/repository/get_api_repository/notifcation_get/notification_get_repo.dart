import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/hobbies/hobbies_modal_class.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/models/notification_get/notification_get.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class NotificationGetRepository {
  final _apiService = NetworkApiServices();

  Future<NotificationGetListModalClass> NotificationGetApi() async {
    dynamic response = await _apiService.getApi(AppUrl.notificationGetAPIUrl);
    // print(response);
    return NotificationGetListModalClass.fromJson(response);
  }
}
