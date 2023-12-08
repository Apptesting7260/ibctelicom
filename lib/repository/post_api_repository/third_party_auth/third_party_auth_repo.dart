import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
class Third_PartyRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> thirdPartyApi(var data) async {
    dynamic response = await _apiService.postApi(data, AppUrl.thirdPartyApiUrl);
    return response;
  }
}
