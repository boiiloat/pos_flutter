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
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                table_label,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.deck,
                color: Colors.blue,
                size: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
