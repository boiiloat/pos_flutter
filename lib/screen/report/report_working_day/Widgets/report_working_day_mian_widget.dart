import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/workingday_start_controller.dart';

class ReportWorkingDayMainWidget extends StatelessWidget {
  final String working_day;
  final String shift_opened;
  final String shift_closed;
  final String shift_number;
  final int
      index; // Add index to distinguish between different working day widgets

  const ReportWorkingDayMainWidget({
    super.key,
    required this.working_day,
    required this.shift_opened,
    required this.shift_closed,
    required this.shift_number,
    required this.index, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkingDayStartController>();

    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Obx(
            () => GestureDetector(
              onTap: () {
                controller
                    .selectContainer(index); // Pass index to the controller
              },
              child: Column(
                children: [
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: controller.selectedIndex.value == index
                          ? const Color.fromARGB(255, 173, 209, 236)
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                working_day,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: controller.selectedIndex.value == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    child: Text(
                                      'Closed',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: controller.selectedIndex.value == index
                                    ? Colors.white
                                    : Colors.black,
                                size: 11,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                shift_opened,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: controller.selectedIndex.value == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 11,
                                color: controller.selectedIndex.value == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                shift_closed,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: controller.selectedIndex.value == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.summarize,
                                size: 11,
                                color: controller.selectedIndex.value == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Text(
                                shift_number,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: controller.selectedIndex.value == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.selectedIndex.value ==
                      index) // Show shifts based on the selected index
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 3),
                              GestureDetector(
                                onTap: () {
                                  controller.selectSubContainer(0);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(7.0),
                                  decoration: BoxDecoration(
                                    color: controller.selectedSubContainerIndex
                                                .value ==
                                            0
                                        ? const Color.fromARGB(
                                            255, 175, 207, 233)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        "10:45 AM",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      Text(
                                        "#CS2024-00022",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  controller.selectSubContainer(1);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(7.0),
                                  decoration: BoxDecoration(
                                    color: controller.selectedSubContainerIndex
                                                .value ==
                                            1
                                        ? const Color.fromARGB(
                                            255, 175, 207, 233)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        "11:22 AM",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      Text(
                                        "#CS2024-00023",
                                        style: TextStyle(fontSize: 13),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
