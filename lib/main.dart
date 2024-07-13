import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/pos/table_plan_screen.dart';
import 'package:pos_system/screen/sale/sale_menu_screen.dart';
import 'package:pos_system/testing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // home: const LoginScreen(),
      home: TablePlanScreen(),
      // home: Testing(),
      debugShowCheckedModeBanner: false,
    );
  }
}
