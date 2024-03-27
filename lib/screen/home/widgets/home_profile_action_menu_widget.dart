import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/main_controller.dart';

class HomeProfileActionMenuWidget extends StatelessWidget {
  const HomeProfileActionMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
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
              value: 'loadMenu',
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_sharp,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Load Menu'.tr,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'loadUsers',
              child: Row(
                children: [
                  Icon(
                    Icons.account_box,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Reload User'.tr,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'loadConfig',
              child: Row(
                children: [
                  Icon(
                    Icons.settings_suggest_outlined,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Load Config'.tr,
                    style: TextStyle(color: Colors.red),
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
