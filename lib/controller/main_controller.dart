import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_close_screen.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_start_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/pos/table_plan/table_plan_screen.dart';
import 'package:pos_system/screen/working_day/working_dat_close_screen.dart';
import 'package:pos_system/screen/working_day/working_day_start_screen.dart';

import '../screen/receipt/receipt_screen.dart';

class MainController extends GetxController {
  var isLoading = true.obs;
  var workingInfor = <String, dynamic>{"wd": null, "cs": null}.obs;
  var isSaleStarted = false.obs;

  void onLogoutPressed() {
    Get.to(const LoginScreen());
  }

  void onWIFIPressed() {
    Get.defaultDialog(title: 'WIFI PASSWORD');
  }

  void onBackupPressed() {
    Program.alert("title", "description");
  }

  void onStartWorkingDayPressed(BuildContext context) {
    Get.to(() => const WorkingDayStartScreen());
  }

  void onCloseWorkingDayPressed(BuildContext context) {
    Get.to(() => const WorkingDayCloseScreen());
  }

  void onStartShiftPressed() {
    Get.to(() => const ShiftStartScreen());
  }

  void onCloseShiftPressed() {
    Get.to(() => const ShiftCloseScreen());
  }

  void onPOSPressed() {
    Get.to(() => const TablePlanScreen());
  }

  void onProfileActionPressed(String value) async {}

  void onTesting() {
    // Program.alert("Testing ", "Testing Successfully");
    // Program.warning("title", "description");
    Program.error("title", "description");
  }

  void onReceiptPressed() {
    Get.to(() => ReceiptScreen());
  }

  // Define the list of dropdown items with shift options
  var dropdownItems = <String>['Morning Shift', 'Afternoon Shift'].obs;

  // Define the selected item
  var selectedItem = 'Morning Shift'.obs;

  // Method to update the selected item
  void updateSelectedItem(String newItem) {
    selectedItem.value = newItem;
  }
}
