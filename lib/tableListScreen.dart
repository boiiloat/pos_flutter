import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/table_controller.dart';

class TableListScreen extends StatelessWidget {
  final TableController tableController = Get.put(TableController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table List'),
      ),
      body: Obx(() {
        if (tableController.tables.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: tableController.tables.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tableController.tables[index].name),
                subtitle:
                    Text('Capacity: ${tableController.tables[index].capacity}'),
              );
            },
          );
        }
      }),
    );
  }
}
