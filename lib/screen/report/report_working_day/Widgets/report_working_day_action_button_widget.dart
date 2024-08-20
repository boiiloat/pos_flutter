import 'package:flutter/material.dart';

class ReportWorkingDayActionButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const ReportWorkingDayActionButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white, // You can change the color as needed
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
            // optional text styling
          ),
        ),
      ),
    );
  }
}
