import 'package:get/get.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://127.0.0.1:8000/api';
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }
}