

import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/data/network/network_api_services.dart';
import 'package:nauman/models/blockList/blockList_modal_class.dart';

class BlockListRepository {
  final _apiService = NetworkApiServices();

  Future<BlockListModalClass> BlockListGetApi(var head,var body) async {
    dynamic response = await _apiService.postHeaderBodyApi(head,body ,AppUrl.blockListApiUrl);

    return BlockListModalClass.fromJson(response);
  }
}
