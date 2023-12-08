import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';

class ChatGPTtrainRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> ChatGPTtainApi(
      var head, var body) async {
    dynamic response =
        await _apiService.postHeaderBodyApi(head, body, AppUrl.chatGPTApiUrl);
    return response;
  }
}
