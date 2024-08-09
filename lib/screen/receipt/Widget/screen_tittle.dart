import 'package:flutter/material.dart';

class ScreenTittle extends StatelessWidget {
  final Icon icon;
  final String label;
  const ScreenTittle({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Icon(icon.icon),
          SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
