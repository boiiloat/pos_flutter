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
                 const Icon(
                    Icons.inventory_sharp,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Load Menu'.tr,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'loadUsers',
              child: Row(
                children: [
                 const Icon(
                    Icons.account_box,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Reload User'.tr,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'loadConfig',
              child: Row(
                children: [
                 const Icon(
                    Icons.settings_suggest_outlined,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Load Config'.tr,
                    style: const TextStyle(color: Colors.black),
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
