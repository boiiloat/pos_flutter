import 'package:get/get.dart';
import 'package:pos_system/program.dart';

class RecieptController extends GetxController {
  // Sample data for the table
  var tableData = [
    {"Name": "John Doe", "Age": "25", "Occupation": "Developer"},
    {"Name": "Jane Smith", "Age": "30", "Occupation": "Designer"},
    {"Name": "Alice Johnson", "Age": "28", "Occupation": "Manager"},
  ].obs;

  // Add a new row to the table
  void addRow(Map<String, String> newRow) {
    tableData.add(newRow);
  }

  // Remove a row from the table
  void removeRow(int index) {
    tableData.removeAt(index);
  }

  void onReceiptPressed() {
    print("xxx");
  }
}
