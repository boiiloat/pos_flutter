import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';

import 'Widget/report_kpi_widget.dart';
import 'Widget/screen_tittle.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'SNACK & RELAX',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: appColor,
      ),
      body: Column(
        children: [
          ScreenTittle(
            icon: Icon(Icons.receipt_long),
            label: 'Receipt List',
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReceiptKpiWidget(
                  label: 'Total Sale',
                  value: '22',
                  icon: Icon(Icons.sell),
                  color: Colors.orange,
                ),
                ReceiptKpiWidget(
                  label: 'Total Order',
                  value: '5',
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.purple,
                ),
                ReceiptKpiWidget(
                  label: 'Total Revneue',
                  value: '\$ 22.00',
                  icon: Icon(Icons.home),
                  color: Colors.blue,
                ),
                ReceiptKpiWidget(
                  label: 'Total Profit',
                  value: '\$ 5.00',
                  icon: Icon(Icons.credit_card_sharp),
                  color: Colors.green,
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
