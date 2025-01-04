import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/screen/report/report_working_day/Widgets/report_working_day_action_button_widget.dart';

import '../../../constans/constan.dart';
import '../../../controller/workingday_start_controller.dart';
import 'Widgets/report_working_day_mian_widget.dart';

class ReportWorkingDayScreen extends StatelessWidget {
  const ReportWorkingDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkingDayStartController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SNACK & RELAX CAFE',
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
      body: Expanded(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Working Day #WD2024-00022',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Working Day & Cashier Shift Report',
                                    style: TextStyle(fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 15,
                      child: Column(
                        children: [
                          ReportWorkingDayMainWidget(
                            working_day: 'WD2024-00022',
                            shift_opened: '2024-9-10 was opened by Leam loat',
                            shift_closed: '2024-9-10 was closed by Leam loat',
                            shift_number: 'Total Shift: 2 ',
                            index: 0, // Pass index here
                          ),
                          ReportWorkingDayMainWidget(
                            working_day: 'WD2024-00023',
                            shift_opened: '2024-9-10 was opened by Leam loat',
                            shift_closed: '2024-9-10 was closed by Leam loat',
                            shift_number: 'Total Shift: 1 ',
                            index: 1, // Pass index here
                          ),
                          ReportWorkingDayMainWidget(
                            working_day: 'WD2024-00024',
                            shift_opened: '2024-9-11 was opened by Leam loat',
                            shift_closed: '2024-9-11 was closed by Leam loat',
                            shift_number: 'Total Shift: 1',
                            index: 2, // Pass index here
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Expanded(
                  child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ReportWorkingDayActionButtonWidget(
                              label: 'Sale Summary',
                              onPressed: () {},
                              color: Colors.blue.shade200,
                              label_color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            ReportWorkingDayActionButtonWidget(
                              label: 'Sale Transection',
                              onPressed: () {},
                              color: Colors.white,
                              label_color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.grey.shade400,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 350,
                              height: 500,
                              color: Colors.white,
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Close Cashier Shift Summary',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'CS2024-00022',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          "Shift Information",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Working Day'),
                                        Text('WD2024-00022')
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Created Date'),
                                        Text('2024-9-10')
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('2024-9-10'),
                                        Text('Admin')
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Close By'),
                                        Text('Admin'),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Status '),
                                        Text('Closed'),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Exchange Rate '),
                                        Text('\$ 1 = ៛​ 4,000'),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Sale Summary",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Sale Sub total '),
                                        Text('\$ 15.00'),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total Sale Revenue'),
                                        Text('\$ 15.00'),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Payment Breakdown",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ABA Dollar'),
                                        Text('\$15.00'),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Payment"),
                                        Text("\$ 15.00"),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(""),
                                        Text("៛​ 60,000"),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total Revenue'),
                                        Text('\$ 15.00'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(''),
                                        Text('៛ 60,000'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
