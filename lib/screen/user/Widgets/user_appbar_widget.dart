// App Bar
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar UserAppBarWdiget() {
  return AppBar(
    title: Text('User Management'.tr),
    actions: [
      IconButton(
        icon: const Icon(Icons.refresh),
        // onPressed: controller.fetchUsers,
        onPressed: (){}

        
      ),
    ],
  );
}