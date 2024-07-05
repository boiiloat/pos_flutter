import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/table_controller.dart';

class TableListScreen extends StatelessWidget {
  final TableController tableController = Get.put(TableController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table List'),
      ),
      body: Obx(() {
        if (tableController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Table List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Column(
                  children: tableController.tables.map((table) {
                    return Container(
                      height: 140,
                      width: 200,
                      color: Colors.green, // Green background color
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${table.name}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Seats: ${table.seats}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Available: ${table.available == 1 ? 'isTrue' : 'isFalse'}', // Adjust condition based on API response
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
