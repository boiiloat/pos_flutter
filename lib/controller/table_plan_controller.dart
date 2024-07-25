import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_system/program.dart';
import 'dart:convert';

import 'package:pos_system/screen/sale/sale_menu_screen.dart';

class TablePlanController extends GetxController {
  var isloading = false;
  var tableData = [].obs;

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
        print('Failed to load table data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void onBackPressed() {
    Get.back();
  }

  void onTablePlanPressed() {
    Get.to(() => SaleMenuScreen());
  }

  void onAddNewTablePressed() {
    Program.alert("title", "description");
  }
}
