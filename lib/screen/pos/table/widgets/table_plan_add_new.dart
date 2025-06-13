// lib/screen/pos/table/widgets/table_plan_add_new.dart
import 'package:flutter/material.dart';

class TableAddNewWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const TableAddNewWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onPressed != null)
            ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add_circle, size: 25),
              label: const Text('Add New Table'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
