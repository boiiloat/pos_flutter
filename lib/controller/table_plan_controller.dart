import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        print(tableData);
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
}
