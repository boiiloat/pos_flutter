import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/main_controller.dart';

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
    final mainController = Get.find<MainController>();

    // Special handling only for sale toggle
    if (text == 'Start Sale') {
      return Obx(() {
        final isSaleStarted = mainController.isSaleStarted.value;
        final displayText = isSaleStarted ? "Close Sale" : "Start Sale";
        final displayIcon =
            isSaleStarted ? Icons.stop_circle : Icons.play_circle_fill;
        final itemColor = isSaleStarted ? Colors.red : Colors.blue;

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
                      Icon(displayIcon, color: itemColor),
                      const SizedBox(width: 20),
                      Text(
                        displayText,
                        style: TextStyle(
                          color: itemColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      });
    }

    // Normal menu items
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
                  Icon(icon, color: color ?? Colors.black),
                  const SizedBox(width: 20),
                  Text(
                    text,
                    style: TextStyle(color: color ?? Colors.black),
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
