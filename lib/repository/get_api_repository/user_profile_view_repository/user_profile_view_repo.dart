import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/hobbies/hobbies_modal_class.dart';

import 'package:nauman/models/personalityQ/personalityQ_model.dart';
import 'package:nauman/models/user_profile_view_model.dart/user_profile_view.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class UserProfileViewRepository {
  final _apiService = NetworkApiServices();

  Future<UserProfileViewModalClass> UserProfileViewGetApi() async {
    dynamic response =
        await _apiService.getApi(AppUrl.userProfileViewPostApiUrl);

    return UserProfileViewModalClass.fromJson(response);
  }
}
