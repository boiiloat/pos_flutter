import 'package:flutter/material.dart';

class SalePaymentButtonWidget extends StatelessWidget {
  final String label;
  final Color color;
  final Icon icon;
  final VoidCallback onPressed;
  const SalePaymentButtonWidget({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Ink(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon.icon, // Use the icon's icon data
                color: color, // Set the icon color
                size: 22,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
