// lib/screen/pos/table/widgets/table_plan_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../sale/sale.dart';

class TableActionWidget extends StatelessWidget {
  final String tableNumber;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double size;
  final double fontSize;

  const TableActionWidget({
    super.key,
    required this.tableNumber,
    this.onEdit,
    this.onDelete,
    this.size = 70,
    this.fontSize = 14,
    required String tableLabel,
    required void Function() onPressed,
  });

  void _showGuestNumberDialog(BuildContext context, String tableNumber) {
    final guestNumberController = TextEditingController();

    Get.defaultDialog(
      title: 'Table $tableNumber',
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: guestNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Guests',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (guestNumberController.text.isNotEmpty) {
                  Get.back();
                  // Navigate to order screen with table info
                  // Get.to(() => SaleScreen(
                  //     tableNumber: tableNumber,
                  //     guestCount: int.parse(guestNumberController.text),
                  //     ));
                  Get.toNamed('/sale');
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Start Order',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showGuestNumberDialog(context, tableNumber),
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chair,
                    size: 55,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    tableNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null || onDelete != null)
              Positioned(
                right: 2,
                top: 2,
                child: PopupMenuButton(
                  iconSize: 18,
                  icon: const Icon(Icons.more_vert, size: 16),
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child:
                            Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      Get.defaultDialog(
                        title: 'Confirm Delete',
                        middleText:
                            'Are you sure you want to delete this table?',
                        textConfirm: 'Delete',
                        textCancel: 'Cancel',
                        confirmTextColor: Colors.white,
                        onConfirm: onDelete,
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
