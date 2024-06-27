import 'package:flutter/material.dart';

class SaleButtomActionWidget extends StatelessWidget {
  final Color color;
  final Icon icon;
  final String label;
  SaleButtomActionWidget(
      {super.key,
      required this.color,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon.icon,
              color: Colors.white,
              size: 20,
            ),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
