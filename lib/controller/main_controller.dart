import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_close_screen.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_start_screen.dart';
import 'package:pos_system/screen/customer/customer_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/pos/table_plan/table_plan_screen.dart';
import 'package:pos_system/screen/product/product_screen.dart';
import 'package:pos_system/screen/report/report_expense/report_expense_screen.dart';
import 'package:pos_system/screen/report/report_stock/report_stcok_screen.dart';
import 'package:pos_system/screen/report/report_working_day/report_working_day_screen.dart';
import 'package:pos_system/screen/resetransection/reset_transection_screen.dart';
import 'package:pos_system/screen/working_day/working_dat_close_screen.dart';
import 'package:pos_system/screen/working_day/working_day_start_screen.dart';

import '../screen/receipt/receipt_screen.dart';
import '../screen/report/main_report/report_screen.dart';

class MainController extends GetxController {
  var isLoading = true.obs;
  var workingInfor = <String, dynamic>{"wd": null, "cs": null}.obs;
  var isSaleStarted = false.obs;
  var selectedItem = 'Morning Shift'.obs;
  var dropdownItems = <String>['Morning Shift', 'Afternoon Shift'].obs;

  void onLogoutPressed() {
    Get.off(const LoginScreen());
  }

  void updateSelectedItem(String newItem) {
    selectedItem.value = newItem;
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
    Program.error("title", "description");
  }

  void onReceiptPressed() {
    Get.to(() => ReceiptScreen());
  }

  void onCustomerPressed() {
    Get.to(() => const CustomerScreen());
  }

  void onProductPressed() {
    Get.to(() => const ProductScreen());
  }

  void onResetTransactionPressed() {
    Get.to(() => const ResetTransectionScreen());
  }

  void onReportPressed() {
    Get.to(() => ReportScreen());
  }

  void onStockReportPressed() {
    Get.to(() => ReportStockScreen());
  }

  void onWorkingDayReportPressed() {
    Get.to(() => ReportWorkingDayScreen());
  }

  void onExpensePressed() {
    Get.to(() => ReportExpanseScreen());
  }
}
