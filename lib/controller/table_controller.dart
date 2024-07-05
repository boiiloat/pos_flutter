// controllers/table_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_system/models/api/table_model.dart';
import 'dart:convert';

class TableController extends GetxController {
  var tables = <TableData>[].obs;
  var isLoading = true.obs; // Observable to track loading state

  @override
  void onInit() {
    fetchTables();
    super.onInit();
  }

  void fetchTables() async {
    try {
      isLoading(true); // Set loading state to true

      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/tables'));

      if (response.statusCode == 200) {
        List<dynamic> tableJson = jsonDecode(response.body);

        tables.assignAll(tableJson
            .map((json) => TableData.fromJson(json))
            .whereType<TableData>()
            .toList());

        isLoading(false); // Set loading state to false
      } else {
        throw Exception('Failed to load tables');
      }
    } catch (e) {
      print('Error fetching tables: $e');
      isLoading(false); // Set loading state to false on error
    }
  }
}
