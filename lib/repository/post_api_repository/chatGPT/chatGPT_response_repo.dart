import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/chatGPT/chatGPT_responseModal.dart';

class ChatGPT_responseRepository {
  final _apiService = NetworkApiServices();

  Future<ChatGPT_responseModalClass> ChatGPT_responseApi(
     var header, var body) async {
    dynamic response =
        await _apiService.postHeaderBodyApi(header, body, AppUrl.chatGPTApiUrl);
       print('Printing response in Repo -> ${response}');
    return ChatGPT_responseModalClass.fromJson(response);
  }
}
