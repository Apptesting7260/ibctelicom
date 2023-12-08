import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';

class LogoutRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> logoutApi(
      Map<String, String>? head) async {
    dynamic response =
        await _apiService.postHeaderApi(head, AppUrl.lougOutAPi);
    return response;
  }
}
