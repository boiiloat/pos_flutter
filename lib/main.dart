import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_close_screen.dart';
import 'package:pos_system/screen/cashier_shift/cashier_shift_start_screen.dart';
import 'package:pos_system/screen/customer/customer_screen.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/login/login_screen.dart';
import 'package:pos_system/screen/pos/sale/widgets/sale_discount_widget.dart';
import 'package:pos_system/screen/pos/table_plan/table_plan_screen.dart';
import 'package:pos_system/screen/pos/sale/sale_menu_screen.dart';
import 'package:pos_system/screen/product/product_screen.dart';
import 'package:pos_system/screen/receipt/Widget/list.dart';
import 'package:pos_system/screen/receipt/receipt_screen.dart';
import 'package:pos_system/screen/report/main_report/report_screen.dart';
import 'package:pos_system/screen/report/report_working_day/report_working_day_screen.dart';
import 'package:pos_system/screen/working_day/widgets/footer_action_widget.dart';
import 'package:pos_system/screen/working_day/working_dat_close_screen.dart';
import 'package:pos_system/screen/working_day/working_day_start_screen.dart';
import 'package:pos_system/testing.dart';

import 'screen/report/report_stock/report_stcok_screen.dart';

void main() async {
  await GetStorage.init(); // Initialize GetStorage
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginScreen(),
      // home: ProductScreen(),
      // home: ProductScreen(),
      // home: LoginScreen(),

      // home: Testing(),
      debugShowCheckedModeBanner: false,
    );
  }
}
