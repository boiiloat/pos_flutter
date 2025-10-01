import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/expanse/exspanse_screen.dart';

import '../screen/receipt/receipt_screen.dart';
import '../screen/report/main_report/report_screen.dart';

class MainController extends GetxController {
  var isLoading = true.obs;
  var isSaleStarted = false.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    isSaleStarted.value = _storage.read('isSaleStarted') ?? false;
  }

  void toggleSale() {
    if (isSaleStarted.value) {
      // If sale is active, ask to close
      Get.defaultDialog(
        title: "Close Sale".tr,
        middleText: "Do you want to close the sale?".tr,
        textCancel: "No".tr,
        textConfirm: "Yes".tr,
        confirmTextColor: Colors.white,
        onConfirm: () {
          isSaleStarted.value = false;
          _storage.write('isSaleStarted', false);
          Get.back();
          Get.snackbar(
            "Success".tr,
            "Sale closed successfully".tr,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
          );
        },
      );
    } else {
      // If sale is not active, ask to start
      Get.defaultDialog(
        title: "Start Sale".tr,
        middleText: "Do you want to start sale?".tr,
        textCancel: "No".tr,
        textConfirm: "Yes".tr,
        confirmTextColor: Colors.white,
        onConfirm: () {
          isSaleStarted.value = true;
          _storage.write('isSaleStarted', true);
          Get.back();
          Get.snackbar(
            "Success".tr,
            "Sale started successfully".tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      );
    }
  }

  void onPOSPressed() {
    if (!isSaleStarted.value) {
      Get.snackbar(
        "Warning".tr,
        "Please start sale first".tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } else {
      Get.toNamed('/table');
    }
  }

  // In MainController - Update the onLogoutPressed method
  void onLogoutPressed() {
    // Check if sale is started
    if (isSaleStarted.value) {
      // Use Program.error instead of Get.snackbar
      Program.error("Logout", "Please close the sale first before logging out");
      return; // Stop here - don't proceed to logout
    }

    // If sale is closed, show normal logout confirmation
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textCancel: "Cancel",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.off(const LoginScreen());
      },
      onCancel: () {},
    );
  }

  void onProfileActionPressed(String value) async {}

  void onTesting() {
    Program.error("title", "description");
  }

  void onReceiptPressed() {
    Get.to(() => ReceiptScreen());
  }

  void onUserPressed() {
    Get.toNamed('/user');
  }

  void onProductPressed() {
    Get.toNamed('/product');
  }

  void onReportPressed() {
    Get.to(() => ReportScreen());
  }

  void onExpensePressed() {
    Get.to(() => ExpenseScreen());
  }

  void onResetSalePressed() {
    Program.success("title", "description");
  }
}
