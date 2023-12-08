import 'dart:ui';

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/chatList/chatList_modalClass.dart';

// import 'package:getx_mvvm/data/network/network_api_services.dart';
// import 'package:getx_mvvm/res/app_url/app_url.dart';

class ChatListRepository {
  final _apiService = NetworkApiServices();

  Future<ChatListModalClass> chatListApi(var head,var body) async {
    dynamic response = await _apiService.postHeaderBodyApi(head, body,AppUrl.chatListApiUrl);

    return ChatListModalClass.fromJson(response);
  }
}
