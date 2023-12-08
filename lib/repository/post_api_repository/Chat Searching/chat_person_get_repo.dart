import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/chat%20person%20searching/chat_searching_modal.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/hobbies/hobbies_modal_class.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/models/other_user_profile_modal.dart/other_user_profile_view_modalClass.dart';

import 'package:nauman/models/personalityQ/personalityQ_model.dart';
import 'package:nauman/models/user_profile_view_model.dart/user_profile_view.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class ChatPersonGetRepository {
  final _apiService = NetworkApiServices();

 
  Future<ChatPersonGetModalClass> ChatPersonGetApi(var head, var body) async {
    dynamic response = await _apiService.postHeaderBodyApi(
        head, body, AppUrl.chatPersonGetApiUrl);

    return ChatPersonGetModalClass.fromJson(response);
  }
}
