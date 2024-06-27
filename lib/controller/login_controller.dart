import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/home/home_screen.dart';

class LoginController extends GetxController {
  var isLoading = true.obs;
  var pinCode = ''.obs;
  var isLoginProcess = false.obs;
  var isChecked = false.obs;

  // @override
  // Future<void> onInit() async {
  //   super.onInit();
  //   pinCode.value = '';
  //   //
  // }

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
    Get.to(() => const HomeScreen());
    // Get.to(() => const HomeScreen());
    // pinCode.value = '';
  }

  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }
}
