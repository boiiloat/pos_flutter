import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_system/program.dart';
import 'dart:convert';

import 'package:pos_system/screen/pos/table_plan/widgets/guest_cover_popup_input_widget.dart';
import 'package:pos_system/screen/pos/sale/sale_menu_screen.dart';

class TablePlanController extends GetxController {
  var isloading = false;
  var tableData = [].obs;
  var guestCover = ''.obs;
  var isLoading = true.obs;
  var isDoubleGridViewEnabled = true.obs;
  var _guestCover = ''.obs;
  var isLoginProcess = false.obs;

  @override
  void onInit() {
    fetchTableData(); // Fetch data when the controller initializes
    super.onInit();
  }

  Future<void> fetchTableData() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/tables'));
      if (response.statusCode == 200) {
        tableData.value = jsonDecode(response.body);
      } else {
        Program.error("title", "Failed to load table data");
      }
    } catch (e) {
      Program.error("title", "$e");
    }
  }

  void onBackPressed() {
    Get.back();
  }

  void onTablePlanPressed() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(7)), // Adjust the border radius if needed
        ),
        child: Container(
          width: 100, // Set the desired width
          height: 400, // Set the desired height
          padding: const EdgeInsets.all(
              16.0), // Optional: Add padding to the content
          child: GuestCoverPopupInputWidget(
            onPressed: () {
              Get.back();
              Get.to(
                () =>const SaleMenuScreen(),
              );
            },
          ),
        ),
      ),
    );

    // Get.to(() => const SaleMenuScreen());
  }

  void onAddNewTablePressed() {
    Program.alert("title", "description");
  }

  void onBackspace() {
    guestCover("");
  }

  void onKeyNumberPressed(String value) async {
    guestCover("${guestCover.value}$value");
    _guestCover = guestCover;
  }

  void onCancelPressed(String value) async {
    Get.back();
  }
}
