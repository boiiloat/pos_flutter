import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/home/home_screen.dart';

class LoginController extends GetxController {
  var pinCode = ''.obs;
  var isLoginProcess = false.obs;

  void onBackspace() {
    pinCode("");
  }

  void onKeyNumberPressed(String value) async {
    pinCode("${pinCode.value}$value");
  }

  void onLoginPressed(String value) async {
    if (pinCode.value == "12345") {
      await Program.alert("Login", "Login Success");

      Get.to(() => const HomeScreen());
    } else {
      Program.error("Login", "Please Input correct pssword");
    }
  }
}
