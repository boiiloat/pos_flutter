import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/user/user_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/pos/table_plan/table_plan_screen.dart';
import 'package:pos_system/screen/product/product_screen.dart';
import 'package:pos_system/screen/report/report_expense/report_expense_screen.dart';

import '../screen/receipt/receipt_screen.dart';
import '../screen/report/main_report/report_screen.dart';

class MainController extends GetxController {
  var isLoading = true.obs;
  var isSaleStarted = false.obs;

  var dropdownItems = <String>['Morning Shift', 'Afternoon Shift'].obs;

  void onStartSalePressed() {
    Get.defaultDialog(
      title: "Start sale",
      middleText: "Are you sure you want to start sale?",
      textCancel: "Cancel",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.off( HomeScreen());
      },
      onCancel: () {},
    );
  }

  void onPOSPressed() {
    Get.to(() => const TablePlanScreen());
  }

  void onLogoutPressed() {
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
    Get.toNamed('/product'); //ProductScreen
  }

  void onReportPressed() {
    Get.to(() => ReportScreen());
  }

  void onExpensePressed() {
    Get.to(() => ReportExpanseScreen());
  }

  void onResetSalePressed() {
    Program.success("title", "description");
  }
}
