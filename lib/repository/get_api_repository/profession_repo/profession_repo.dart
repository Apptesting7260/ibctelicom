import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/education/education_modal_class.dart';
import 'package:nauman/models/hobbies/hobbies_modal_class.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/models/profession/profession_modal_class.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class ProfessionGetRepository {
  final _apiService = NetworkApiServices();

  Future<ProfessionModalClass> ProfessionApi() async {
    dynamic response = await _apiService.getApi(AppUrl.professionGetApiUrl);
    // print(response);
    return ProfessionModalClass.fromJson(response);
  }
}
