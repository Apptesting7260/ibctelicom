import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/models/personality_traits_options/personality_traits_options_modal_class.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class PersonalityTraitsOptionsRepository {
  final _apiService = NetworkApiServices();

  Future<PersonalityTraitsOptionsModalClass>
      PersonalityTraitsOptionsApi() async {
    dynamic response =
        await _apiService.getApi(AppUrl.personalityTraitsOptionsApiUrl);
    print(response);
    return PersonalityTraitsOptionsModalClass.fromJson(response);
  }
}
