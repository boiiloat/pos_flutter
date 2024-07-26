import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';

import '../../../controller/main_controller.dart';

class HomeProfileActionMenuWidget extends StatelessWidget {
  const HomeProfileActionMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    final controllerx = Get.find<LoginController>();

    return Container(
      padding: const EdgeInsets.all(5),
      child: PopupMenuButton<String>(
        // ignore: sort_child_properties_last
        child: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/logo_image.jpg"),
        ),
        onSelected: controller.onProfileActionPressed,
        itemBuilder: (BuildContext bc) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: Container(
                padding: const EdgeInsets.only(right: 80, bottom: 4.0),
                child: const Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Leam loat',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            )),
                        Text(
                          'Admin Role',
                          style: TextStyle(fontSize: 12),
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
                 const  SizedBox(width: 5),
                  InkWell(
                    child: Text(
                      'Logout'.tr,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
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
