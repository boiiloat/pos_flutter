import 'package:flutter/material.dart';
import 'package:pos_system/constans/constan.dart';

class ReportWorkingDayActionButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color label_color;
  const ReportWorkingDayActionButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color, required this.label_color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 40,
        decoration: BoxDecoration(
          color: color, // You can change the color as needed
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),

              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
          borderRadius:
              BorderRadius.circular(5), // optional if you want rounded corners
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: label_color),
            // optional text styling
          ),
        ),
      ),
    );
  }
}
