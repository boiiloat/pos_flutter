import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';

class Program {
  static SnackbarController? snackController;

  static getSnackbar_({
    required String title,
    required String description,
    required Icon icon,
    Color foreground = Colors.white,
    required Color background,
  }) {
    snackController = Get.snackbar(
      title,
      description,
      maxWidth: 500,
      padding: const EdgeInsets.symmetric(vertical: 10),
      // margin: const EdgeInsets.only(top: 3, left: 3, right: 3),
      backgroundColor: background,
      icon: icon,
      colorText: foreground,
      snackPosition: SnackPosition.TOP,
      overlayBlur: 0,
      shouldIconPulse: true,
      barBlur: 20,
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }

  static alert(String title, String description) async {
    if (Get.isSnackbarOpen == false) {
      getSnackbar_(
        title: title,
        description: description,
        foreground: Colors.white,
        background: HexColor.fromHex("#27ae60"),
        icon: const Icon(Icons.task_alt_outlined, color: Colors.white),
      );
    }
  }

  static warning(String title, String description) async {
    if (Get.isSnackbarOpen == false) {
      getSnackbar_(
        title: title,
        description: description,
        background: HexColor.fromHex("#f1c40f"),
        icon: const Icon(
          Icons.report_problem_outlined,
          color: Colors.white,
        ),
      );
    }
  }

  static error(String title, String description) async {
    if (Get.isSnackbarOpen == false) {
      getSnackbar_(
        title: title,
        description: description,
        // background: HexColor.fromHex("#e74c3c").withOpacity(0.7),
        background: HexColor.fromHex("#e74c3c"),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }
}
