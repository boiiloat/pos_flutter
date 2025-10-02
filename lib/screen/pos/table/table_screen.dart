// lib/screen/pos/table/table_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/table_controller.dart';
import 'package:pos_system/controller/sale_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/utils/constants.dart';
import 'package:pos_system/screen/pos/table/widgets/table_action_widget.dart';
import 'package:pos_system/screen/pos/table/widgets/table_plan_add_new.dart';

class TablePlanScreen extends StatelessWidget {
  const TablePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TableController controller = Get.put(TableController());
    final screenWidth = MediaQuery.of(context).size.width;

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
            onPressed: () => _navigateBackToHome(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: appColor,
          actions: [
            IconButton(
              onPressed: () => controller.fetchTables(),
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Refresh Tables',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.table_restaurant),
                      SizedBox(width: 5),
                      Text(
                        'Table Layout',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Obx(() => TableAddNewWidget(
                        onPressed: controller.isAdmin.value
                            ? () => _showAddTableDialog(controller)
                            : null,
                      )),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
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
                          final isTableDeleted = table['deleted_at'] != null;

                          return TableActionWidget(
                            tableNumber: table['name'],
                            tableLabel: 'Table ${table['name']}',
                            onEdit: controller.isAdmin.value && !isTableDeleted
                                ? () => _showEditTableDialog(
                                    controller, table['id'], table['name'])
                                : null,
                            onDelete: controller.isAdmin.value &&
                                    !isTableDeleted
                                ? () =>
                                    _handleDeleteTable(controller, table['id'])
                                : null,
                            size: tableSize,
                            fontSize: fontSize,
                            isDisabled: isTableDeleted,
                            onPressed: () =>
                                _handleTableSelection(controller, table),
                          );
                        },
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateBackToHome() {
    Get.offAllNamed('/home');
  }

  void _handleTableSelection(
      TableController controller, Map<String, dynamic> table) async {
    try {
      final tableId = table['id'];
      final tableName = table['name'];

      if (tableId == null || tableName == null) {
        Get.snackbar('Error', 'Table information is incomplete');
        return;
      }

      controller.loading.value = true;

      if (Get.isRegistered<SaleController>()) {
        final saleController = Get.find<SaleController>();
        saleController.cartItems.clear();
        saleController.cartQuantities.clear();
        saleController.saleSubtotal.value = 0.0;
        saleController.saleDiscount.value = 0.0;
        saleController.saleTotal.value = 0.0;
      }

      controller.selectTable(tableId, tableName);

      if (!Get.isRegistered<SaleController>()) {
        Get.put(SaleController(), permanent: true);
      }

      final saleController = Get.find<SaleController>();
      saleController.setCurrentTable(tableId, tableName);

      await Get.toNamed('/sales', arguments: {
        'table_id': tableId,
        'table_name': tableName,
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select table: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      controller.loading.value = false;
    }
  }

  // FIXED: Direct delete without extra confirmation dialog
  void _handleDeleteTable(TableController controller, int tableId) async {
    // Close the confirmation dialog first
    Get.back();

    // Then call the delete method
    await controller.deleteTable(tableId);
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
        onPressed: () {
          if (nameController.text.isNotEmpty) {
            Get.back();
            controller.createTable(nameController.text);
          } else {
            Program.error('Validation Error', 'Please enter table name');
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
        onPressed: () {
          if (nameController.text.isNotEmpty) {
            Get.back();
            controller.updateTable(tableId, nameController.text);
          } else {
            Program.error('Validation Error', 'Please enter table name');
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
