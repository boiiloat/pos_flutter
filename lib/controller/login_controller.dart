import 'package:get/get.dart';
import 'package:pos_system/screen/home/home_screen.dart';

class LoginController extends GetxController {
  var isLoading = true.obs;
  var pinCode = ''.obs;
  var isLoginProcess = false.obs;

  Future<void> onInitState() async {
    //
  }

  void updateResult(String value) {
    pinCode.value += value;
  }

  void onKeyNumberPressed(String value) async {
    pinCode("${pinCode.value}$value");
  }

  void onBackspace() {
    pinCode("");
  }

  void onLoginPressed() {
    Get.to(() => HomeScreen());
    pinCode.value = "";
  }
}
