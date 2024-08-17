import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/report/report_working_day/Widgets/report_working_day_action_button_widget.dart';

import '../../../constans/constan.dart';
import '../../../controller/workingday_start_controller.dart';

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
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Working Day #WD2024-00024',
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
                    Expanded(
                      flex: 15,
                      child: Container(
                        color: Colors.grey.shade200,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              10,
                              (index) => Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    controller.selectContainer(index);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color:
                                              controller.selectedIndex.value ==
                                                      index
                                                  ? Color.fromARGB(
                                                      255, 173, 209, 236)
                                                  : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                "WD2024-00012",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: controller
                                                              .selectedIndex
                                                              .value ==
                                                          index
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (controller.selectedIndex.value ==
                                          index)
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 3),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text("10 : 45 AM"),
                                                      Text("#CS2024-00022"),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text("10 : 45 AM"),
                                                      Text("#CS2024-00022"),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
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
            Expanded(
              flex: 7,
              child: Container(
                child: Expanded(
                    child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReportWorkingDayActionButtonWidget(
                              label: 'Sale Summary',
                              onPressed: () {},
                            ),
                            const SizedBox(width: 10),
                            ReportWorkingDayActionButtonWidget(
                              label: 'Sale Product Summary',
                              onPressed: () {},
                            ),
                            const SizedBox(width: 10),
                            ReportWorkingDayActionButtonWidget(
                              label: 'Sale Transection',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
