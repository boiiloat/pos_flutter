import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/table_controller.dart';

class TableListScreen extends StatelessWidget {
  var controller = Get.put(TableController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table List'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.tableData.length,
          itemBuilder: (context, index) {
            final table = controller.tableData[index];
            bool isAvailable = table['available'] ??
                false; // Use default value if 'available' is null
            return ListTile(
              title: Text(table['name'] ?? ''),
              subtitle: Text('Seats: ${table['seat'] ?? ''}'),
              trailing: Text(isAvailable ? 'Available' : 'Occupied'),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
