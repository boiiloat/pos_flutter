import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableActionWidget extends StatelessWidget {
  final String tableNumber;
  final String tableLabel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onPressed; // Required parameter
  final bool isDisabled;
  final double size;
  final double fontSize;

  const TableActionWidget({
    super.key,
    required this.tableNumber,
    required this.tableLabel,
    this.onEdit,
    this.onDelete,
    required this.onPressed, // Marked as required
    required this.isDisabled,
    this.size = 70,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed, // Disable tap if table is disabled
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey[300] : Colors.white,
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
                    color: isDisabled ? Colors.grey[500] : Colors.grey,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    tableLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: isDisabled ? Colors.grey[600] : Colors.black,
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
