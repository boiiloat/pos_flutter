import 'package:get/get.dart';
import 'package:pos_system/screen/login/login_screen.dart';

class MainController extends GetxController {
  void onLogoutPressed() {
    Get.to(LoginScreen());
  }
}
