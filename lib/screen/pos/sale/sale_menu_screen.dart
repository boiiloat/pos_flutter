import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/product_controller.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/pos/sale/widgets/testing.dart';
import '../../../testing.dart';
import 'widgets/app_bar_sale_menu_widget.dart';
import 'widgets/body_sale_menu_widget.dart';
import 'widgets/menu_item_widget.dart';
import 'widgets/sale_buttom_action_widget.dart';
import 'widgets/sale_item_note_widget.dart';
import 'widgets/sale_product_widget.dart';

class SaleMenuScreen extends StatelessWidget {
  const SaleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(ProductController());
    // // var controller = Get.put(SaleController());
    // // var controller = Get.put(ProductController);
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: AppBarSaleMenuWidget(),
          ),
          Expanded(
            flex: 12,
            child: BodySaleMenuWidget(),
          ),
        ],
      ),
    );
  }
}
