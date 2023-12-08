import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/favouriteList/favouriteListModalClass.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class FavouriteListRepository {
  final _apiService = NetworkApiServices();

  Future<FavouriteListModalClass> FavouriteListApi(var header, var body) async {
    dynamic response =
        await _apiService.postHeaderBodyApi(header,body, AppUrl.favouriteListApiUrl);

       
    return FavouriteListModalClass.fromJson(response);
  }
}
