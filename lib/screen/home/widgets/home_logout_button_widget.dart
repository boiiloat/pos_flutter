import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/main_controller.dart';

class HomeLogoutButtonWidget extends StatelessWidget {
  const HomeLogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MainController>();
    return SizedBox(
      height: 50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.onLogoutPressed,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 20),
                Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
