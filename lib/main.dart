import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screen/sale/sale_menu_widget.dart';

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
