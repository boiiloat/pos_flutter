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
      body: Obx(() {
        if (controller.tables.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.tables.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(controller.tables[index].name),
              );
            },
          );
        }
      }),
    );
  }
}
