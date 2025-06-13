// lib/screen/pos/table/table_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/table_controller.dart';
import 'package:pos_system/utils/constants.dart';
import 'package:pos_system/screen/pos/table/widgets/table_action_widget.dart';
import 'package:pos_system/screen/pos/table/widgets/table_plan_add_new.dart';

class TablePlanScreen extends StatelessWidget {
  const TablePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TableController controller = Get.put(TableController());
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate table size based on screen width
    final tableSize = screenWidth > 600 ? 80.0 : 70.0;
    final fontSize = screenWidth > 600 ? 16.0 : 14.0;

    return SafeArea(
      child: Scaffold(
         key: UniqueKey(),
        appBar: AppBar(
          title: const Text(
            'SNACK & RELAX CAFE',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: appColor,
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.table_restaurant),
                  SizedBox(width: 5),
                  Text(
                    'Table Layout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Obx(() => TableAddNewWidget(
                  onPressed: controller.isAdmin.value
                      ? () => _showAddTableDialog(controller)
                      : null,
                )),
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                final crossAxisCount = screenWidth > 600 ? 7 : 5;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: controller.tableData.length,
                    itemBuilder: (context, index) {
                      final table = controller.tableData[index];
                      return TableActionWidget(
                        tableNumber: table['name'],
                        tableLabel:
                            'Table ${table['name']}', // Customize label as needed
                        onPressed: controller.onTablePlanPressed,
                        onEdit: controller.isAdmin.value
                            ? () => _showEditTableDialog(
                                controller, table['id'], table['name'])
                            : null,
                        onDelete: controller.isAdmin.value
                            ? () => controller.deleteTable(table['id'])
                            : null,
                        size: tableSize,
                        fontSize: fontSize,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTableDialog(TableController controller) {
    final nameController = TextEditingController();
    Get.defaultDialog(
      title: 'Add New Table',
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (nameController.text.isNotEmpty) {
            await controller.createTable(nameController.text);
            Get.back();
          }
        },
        child: const Text('Save'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }

  void _showEditTableDialog(
      TableController controller, int tableId, String currentName) {
    final nameController = TextEditingController(text: currentName);
    Get.defaultDialog(
      title: 'Edit Table',
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (nameController.text.isNotEmpty) {
            await controller.updateTable(tableId, nameController.text);
            Get.back();
          }
        },
        child: const Text('Update'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }
}
