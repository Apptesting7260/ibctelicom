

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';

import 'package:nauman/models/my_connections/my_connections_modalClass.dart';





class MyConnectionsRepository {
  final _apiService = NetworkApiServices();

  Future<MyConnectionsModalClass> MyConnectionsGetApi(var head,var body) async {
    dynamic response = await _apiService.postHeaderBodyApi(head, body,AppUrl.myConnectionsApiUrl);

    return MyConnectionsModalClass.fromJson(response);
  }
}
