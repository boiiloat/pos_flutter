import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/services/api_service.dart';
import 'package:pos_system/services/auth_service.dart';

import 'controller/login_controller.dart';
import 'controller/user_controller.dart';
import 'screen/user/user_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'POS System',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      initialRoute: GetStorage().read('token') == null ? '/login' : '/home',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/user', page: () => UserScreen()),
      ],
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
    Get.put(AuthService());
    Get.put(LoginController());
    Get.put(UserController());
  }
}
