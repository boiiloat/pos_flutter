import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/test.dart';
import 'screen/login/login_screen.dart'; // Import your LoginScreen widget here

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
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
