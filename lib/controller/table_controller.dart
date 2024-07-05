import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TableController extends GetxController {
  var tables = <TableData>[].obs; // Observable list of tables

  @override
  void onInit() {
    fetchTables(); // Fetch tables when controller initializes
    super.onInit();
  }

  void fetchTables() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/tables'));

      if (response.statusCode == 200) {
        List<dynamic> tableJson = jsonDecode(response.body);
        tables.assignAll(tableJson.map((json) {
          try {
            return TableData.fromJson(json);
          } catch (e) {
            print('Error parsing table data: $e');
            return null;
          }
        }).whereType<TableData>().toList());
      } else {
        throw Exception('Failed to load tables');
      }
    } catch (e) {
      print('Error fetching tables: $e');
    }
  }
}

class TableData {
  final int id;
  final String name;
  final int capacity;

  TableData({required this.id, required this.name, required this.capacity});

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'] as int? ?? 0, // Default value (0 in this case) if id is null
      name: json['name'] as String? ?? '', // Default value (empty string) if name is null
      capacity: json['capacity'] as int? ?? 0, // Default value (0 in this case) if capacity is null
    );
  }
}
