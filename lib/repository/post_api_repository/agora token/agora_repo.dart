import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/agora%20token%20modal/agora_token.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/hobbies/hobbies_modal_class.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/models/other_user_profile_modal.dart/other_user_profile_view_modalClass.dart';

import 'package:nauman/models/personalityQ/personalityQ_model.dart';
import 'package:nauman/models/user_profile_view_model.dart/user_profile_view.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class AgoraTokenRepository {
  final _apiService = NetworkApiServices();

  Future<AgoraTokenModalClass> AgoraTokenApi(var head, var body) async {
    dynamic response = await _apiService.postHeaderBodyApi(
        head, body, AppUrl.agoraTokenGetAPIUrl);

    return AgoraTokenModalClass.fromJson(response);
  }
}
