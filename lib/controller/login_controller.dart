import 'package:get/get.dart';

import '../screen/home/home_screen.dart';

class LoginController extends GetxController {
  // void onInit() {
  //   super.onInit();
  // }

  void onLoginPressed() {
    Get.to(const HomeScreen());
  }
}
