import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_close_screen.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_start_screen.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/pos/sale/widgets/sale_discount_widget.dart';
import 'package:pos_system/screen/pos/table_plan/table_plan_screen.dart';
import 'package:pos_system/screen/pos/sale/sale_menu_screen.dart';
import 'package:pos_system/screen/receipt/receipt_screen.dart';
import 'package:pos_system/screen/working_day/widgets/footer_action_widget.dart';
import 'package:pos_system/screen/working_day/working_dat_close_screen.dart';
import 'package:pos_system/screen/working_day/working_day_start_screen.dart';
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
      home: HomeScreen(),
      // home: Testing(),
      debugShowCheckedModeBanner: false,
    );
  }
}
