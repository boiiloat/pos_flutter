import 'package:flutter/material.dart';

class HomeDrawerMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final VoidCallback? onPressed;
  const HomeDrawerMenuItemWidget({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Icon(
                    icon,
                    color: color ?? Colors.red,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    text,
                    style: TextStyle(color: color ?? Colors.red),
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
