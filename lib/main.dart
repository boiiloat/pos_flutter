import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/pos/table_plain_screen.dart';
import 'package:pos_system/screen/sale/sale_menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const LoginScreen(),
      home: const SaleMenuScreen(),
      // home: Testing(),
      debugShowCheckedModeBanner: false,
    );
  }
}
