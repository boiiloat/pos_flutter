import 'package:flutter/material.dart';

class TablePlanAddNewWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const TablePlanAddNewWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              height: 35,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.green.shade600),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Add Table',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
