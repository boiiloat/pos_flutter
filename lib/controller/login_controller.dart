import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/home/home_screen.dart';

class LoginController extends GetxController {
  var pinCode = ''.obs;
  var isLoginProcess = false.obs;

  void onBackspace() {
    pinCode("");
    Program.alert("title", "description");
  }

  void onKeyNumberPressed(String value) async {
    pinCode("${pinCode.value}$value");
  }

  void onLoginPressed(String value) async {
    Get.to(HomeScreen());
  }
}
