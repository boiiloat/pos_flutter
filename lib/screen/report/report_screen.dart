import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/screen/report/Widget/report_chart_widget.dart';

import '../receipt/Widget/report_kpi_widget.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReceiptKpiWidget(
                  label: 'Total Sale',
                  value: '07',
                  icon: Icon(Icons.receipt_long),
                  color: Colors.orange,
                ),
                ReceiptKpiWidget(
                  label: 'Total Order',
                  value: '\$ 81.00',
                  icon: Icon(Icons.paid_outlined),
                  color: Colors.red,
                ),
                ReceiptKpiWidget(
                  label: 'Total Revenue',
                  value: '\$ 3.00',
                  icon: Icon(Icons.discount_outlined),
                  color: Colors.purple,
                ),
                ReceiptKpiWidget(
                  label: 'Grand Profit',
                  value: '\$ 78.00',
                  icon: Icon(Icons.monetization_on),
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Sale Overview"),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.more_horiz)),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Text('Grid 1'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 5, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Top Sale',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.more_horiz,
                                            size: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: PieChart(
                                      PieChartData(
                                        sections: [
                                          PieChartSectionData(
                                            value: 30,
                                            color: Colors.blue,
                                            title: '30%',
                                            radius: 80, // Adjusted radius
                                            titleStyle: TextStyle(
                                              fontSize:
                                                  14, // Adjusted font size
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: 20,
                                            color: Colors.red,
                                            title: '20%',
                                            radius: 80, // Adjusted radius
                                            titleStyle: TextStyle(
                                              fontSize:
                                                  14, // Adjusted font size
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: 25,
                                            color: Colors.green,
                                            title: '25%',
                                            radius: 80, // Adjusted radius
                                            titleStyle: TextStyle(
                                              fontSize:
                                                  14, // Adjusted font size
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: 25,
                                            color: Colors.orange,
                                            title: '25%',
                                            radius: 80, // Adjusted radius
                                            titleStyle: TextStyle(
                                              fontSize:
                                                  14, // Adjusted font size
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                        borderData: FlBorderData(show: false),
                                        centerSpaceRadius:
                                            0, // Adjusted center space radius
                                        sectionsSpace:
                                            0, // No space between sections
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Chip before first text
                                      Container(
                                        width: 12, // Width of the chip
                                        height: 12, // Height of the chip
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Colors.blue, // Color of the chip
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Space between chip and text
                                      Text(
                                        'ឆាក្តៅសាច់មាន់',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(width: 8),

                                      // Chip before second text
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'អាម៉ុក',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(width: 8),

                                      // Chip before third text
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'មាន់ដុត',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(width: 8),

                                      // Chip before fourth text
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Angkor beer',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  child: Row(
                                    children: [
                                      Text("Working day & Stock Report"),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Text('Grid 2'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Centered word at the top
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Summary',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Quantity',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              child: Center(
                                                child: Text(
                                                  '22',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider
                                    Divider(color: Colors.blue),
                                    // Row 2
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Invoice',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              child: Center(
                                                child: Text(
                                                  '22',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider
                                    Divider(color: Colors.blue),

                                    // Row 3
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Paid',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              child: Center(
                                                child: Text(
                                                  '22',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider
                                    Divider(color: Colors.blue),

                                    // Row 4
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Unpaid',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              child: Center(
                                                child: Text(
                                                  '22',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider
                                    Divider(color: Colors.blue),

                                    // Row 5
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Table',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              child: Center(
                                                child: Text(
                                                  '22',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
