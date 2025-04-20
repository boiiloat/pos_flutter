// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';

class HomeDrawerProfileWidget extends StatelessWidget {
  const HomeDrawerProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final loginController = Get.find<LoginController>();

    return SizedBox(
      height: 150,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_image.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundImage:
                            AssetImage("assets/images/logo_image.jpg"),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: const BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Obx(() => Text(
                      //       loginController.loggedInUser.value?.fullname ??
                      //           'Unknown',
                      //       style: const TextStyle(
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //       ),
                      //     )),
                      // Obx(() => Text(
                      //       'POS Profile: ${_getRoleName(loginController.loggedInUser.value?.roleId)}',
                      //       style: const TextStyle(
                      //           color: Colors.white, fontSize: 12),
                      //     )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
        return 'Unknown';
    }
  }
}
