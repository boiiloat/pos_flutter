import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/working_day/wokingday_start_screen.dart';

import '../screen/cashier_shift/shift_close_screen.dart';
import '../screen/cashier_shift/shift_starts_screen.dart';
import '../screen/pos/pos_screen.dart';
import '../screen/working_day/workingday_close_screen.dart';

class MainController extends GetxController {
  var isLoading = true.obs;
  void onLogoutPressed() {
    Get.to(const LoginScreen());
  }

  void onWIFIPressed() {
    Get.defaultDialog(title: 'WIFI PASSWORD');
  }

  void onBackupPressed() {
    Get.snackbar(
      'Back Up',
      'Back up Successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  void onWorkingdayPressed() {
    Get.to(() => const WorkingdayStartScreen());
  }

  void onCloseWorkingdayPressed() {
    Get.to(() => const WorkingdayCloseScreen());
  }

  void onStartShiftPressed() {
    Get.to(() => const ShiftStartScreen());
  }

  void onCloseShiftPressed() {
    Get.to(() => const ShiftCloseScreen());
  }

  void onPOSPressed() {
    Get.to(() => const POSScreen());
  }

  void onProfileActionPressed(String value) async {}
}
