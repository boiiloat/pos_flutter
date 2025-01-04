import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/screen/report/main_report/Widget/report_total_receipt_widget.dart';

import '../../receipt/Widget/report_kpi_widget.dart';
import 'Widget/report_circle_chartWidget.dart';
import 'Widget/report_sale_overview_widget.dart';
import 'Widget/report_summary_widget.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Report Sceen',
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReceiptKpiWidget(
                  label: 'Total Sale',
                  value: '25',
                  icon: Icon(Icons.sell, color: Colors.orange),
                  color: Colors.orange,
                ),
                ReceiptKpiWidget(
                  label: 'Total Order',
                  value: '20',
                  icon: Icon(Icons.shopping_cart, color: Colors.red),
                  color: Colors.red,
                ),
                ReceiptKpiWidget(
                  label: 'Total Revenue',
                  value: '\$ 275.00',
                  icon: Icon(Icons.monetization_on, color: Colors.purple),
                  color: Colors.purple,
                ),
                ReceiptKpiWidget(
                  label: 'Total Profit',
                  value: '\$ 220.00',
                  icon: Icon(Icons.payment, color: Colors.blue),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Expanded(
              child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: ReportSaleOverviewWidget(),
                      ),
                      Expanded(
                        flex: 3,
                        child: ReportCircleChartWidget(),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: ReportTotalReceiptWidget(),
                      ),
                      const Expanded(
                        flex: 3,
                        child: ReportSummaryWidget(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
