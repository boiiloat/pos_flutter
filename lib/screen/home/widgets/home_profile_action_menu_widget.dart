import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';
import 'package:pos_system/controller/main_controller.dart';
import 'package:pos_system/screen/login/login_screen.dart';

class HomeProfileActionMenuWidget extends StatelessWidget {
  const HomeProfileActionMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final loginController = Get.find<LoginController>();

    return Container(
      padding: const EdgeInsets.all(5),
      child: PopupMenuButton<String>(
        child: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/logo_image.jpg"),
        ),
        onSelected: (value) {
          if (value == 'logout') {
            // Call the logout method
            Get.to(() => const LoginScreen());
          } else {
            mainController.onProfileActionPressed(value);
          }
        },
        itemBuilder: (BuildContext bc) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: Container(
                padding: const EdgeInsets.only(right: 80, bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loginController.loggedInUser.value?.fullname ??
                              'Unknown',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' ${_getRoleName(loginController.loggedInUser.value?.roleId)} Role ',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'reload',
              child: Row(
                children: [
                  Icon(
                    Icons.refresh,
                    size: 20.0,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Reload'.tr,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 20.0,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Logout'.tr,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  String _getRoleName(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cashier';
      default:
        return 'Unknown Role';
    }
  }
}
