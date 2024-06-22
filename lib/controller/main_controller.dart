import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import '../screen/StartSale/shift_close_screen.dart';
import '../screen/pos/pos_screen.dart';

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

  void onStartSalePressed() {
    Get.dialog(Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Get.back(), // Close the dialog
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                isSaleStarted.value = false;
                Get.to(ShiftCloseScreen()); // Close the dialog after the action
                // Close the dialog after the action
              },
              child: Text('Do something'),
            ),
          ],
        ),
      ),
    ));
  }

  void onCloseSalePrssed() {
    Get.dialog(
      AlertDialog(
        content: Text('This is the content of the dialog.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close the dialog
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Perform some action
              isSaleStarted.value = false;
              Get.back(); // Close the dialog after the action
              // Close the dialog after the action
            },
            child: Text('Do something'),
          ),
        ],
      ),
    );
  }

  void onPOSPressed() {
    Get.to(() => const POSScreen());
  }

  void onProfileActionPressed(String value) async {}

  void onTesting() {
    // Program.alert("Testing ", "Testing Successfully");
    // Program.warning("title", "description");
    Program.error("title", "description");
  }
}
