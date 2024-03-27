import 'package:get/get.dart';
import 'package:pos_system/screen/login/login_screen.dart';

class MainController extends GetxController {
  var isLoading = true.obs;
  void onLogoutPressed() {
    Get.to(const LoginScreen());
  }

  void onWIFIPressed() {
    Get.defaultDialog(title: 'this is wifi');
  }

  void onProfileActionPressed(String value) async {}
}
