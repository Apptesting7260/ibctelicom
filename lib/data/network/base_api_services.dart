abstract class BaseApiServices {
  Future<dynamic> getApi(String url);
  Future<dynamic> postApi(dynamic data, String url);
  Future<dynamic> postHeaderApi(dynamic data, String url);
  Future<dynamic> postHeaderBodyApi(
      dynamic head, dynamic body, String url);
}
