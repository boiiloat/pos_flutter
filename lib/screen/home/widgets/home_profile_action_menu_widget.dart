import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';
import 'package:pos_system/controller/main_controller.dart';
import 'package:pos_system/screen/login/login_screen.dart';

class HomeProfileActionMenuWidget extends StatelessWidget {
  const HomeProfileActionMenuWidget({super.key});

  // Helper method to get role name based on roleId
  String _getRoleName(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cashier';
      default:
        return 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final loginController = Get.find<LoginController>();

    return Container(
      padding: const EdgeInsets.all(5),
      child: PopupMenuButton<String>(
        child: Obx(() {
          final profileImage = loginController.profileImage;
          return CircleAvatar(
            backgroundImage: (profileImage != null && profileImage.isNotEmpty)
                ? NetworkImage('http://localhost:8000/storage/$profileImage')
                    as ImageProvider
                : const AssetImage("assets/images/logo_image.jpg")
                    as ImageProvider,
          );
        }),
        onSelected: (value) {
          if (value == 'logout') {
            // Call the logout method
            loginController.logout();
            Get.offAll(() => const LoginScreen());
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
                    // Profile image in the popup menu
                    Obx(() {
                      final profileImage = loginController.profileImage;
                      return CircleAvatar(
                        radius: 20,
                        backgroundImage: (profileImage != null &&
                                profileImage.isNotEmpty)
                            ? NetworkImage(
                                    'http://localhost:8000/storage/$profileImage')
                                as ImageProvider
                            : const AssetImage("assets/images/logo_image.jpg")
                                as ImageProvider,
                      );
                    }),
                    const SizedBox(width: 10.0),
                    // Use Obx to reactively update user information
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loginController.userFullName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${_getRoleName(loginController.roleId)} Role',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )),
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
}
