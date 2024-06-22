import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/StartSale/widgets/start_sale_alert.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import '../screen/pos/table_plain_screen.dart';

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

  void onStartSalePressed(BuildContext context) {
    Get.defaultDialog(
      radius: 5,
      title: "Start Sale",
      backgroundColor: Colors.white,
      content: StartSaleAlert(
        onBack: () {
          Get.back();
        },
        onSave: () {
          isSaleStarted.value = true;
          Get.back();
        },
        text: 'Are you sure you want to start sale?',
      ),
    );
  }

  void onCloseSalePrssed() {
    Get.defaultDialog(
      radius: 5,
      title: "Close Sale",
      backgroundColor: Colors.white,
      content: StartSaleAlert(
        onBack: () {
          Get.back();
        },
        onSave: () {
          isSaleStarted.value = false;
          Get.back();
        },
        text: 'Are you sure you want to stop sale?',
      ),
    );
  }

  void onPOSPressed() {
    Get.to(() => const TablePlainScreen());
  }

  void onProfileActionPressed(String value) async {}

  void onTesting() {
    // Program.alert("Testing ", "Testing Successfully");
    // Program.warning("title", "description");
    Program.error("title", "description");
  }
}
