import 'package:flutter/material.dart';

class TablePlanWidget extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String table_label;
  final VoidCallback onPressed;

  const TablePlanWidget({
    super.key,
    // ignore: non_constant_identifier_names
    required this.table_label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                table_label,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Icon(
                Icons.deck,
                color: Colors.grey,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
