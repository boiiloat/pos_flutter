import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/workingday_start_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/working_day/widgets/footer_action_widget.dart';

import 'widgets/kpi_working_day_widget.dart';

class WorkingDayStartScreen extends StatelessWidget {
  const WorkingDayStartScreen({super.key});

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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.event),
                SizedBox(width: 5),
                Text(
                  'Start working Day',
                ),
              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KpiWorkingDayWidget(
                label: 'Working Date',
                data: '01/08/2024',
              ),
              SizedBox(width: 20),
              KpiWorkingDayWidget(
                label: 'POS Profile',
                data: 'Admin',
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 600,
            child: Card(
              elevation: 3,
              child: SizedBox(
                height: 70, // Set the desired height here
                child: TextFormField(
                  maxLines: null,
                  expands:
                      true, // This makes the TextFormField take all available space
                  decoration: const InputDecoration(
                    labelText: "Note",
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FooterActionWidget(
                onPressed: () {
                  Get.back();
                },
                label: 'Cancal',
                width: 100,
                color: Colors.red,
              ),
              const SizedBox(width: 280),
              FooterActionWidget(
                onPressed: () {
                  Get.dialog(
                    Dialog(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            5)), // Optional: Adjust the border radius
                      ),
                      child: IntrinsicWidth(
                        child: IntrinsicHeight(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 15, 30,
                                15), // Optional: Add padding to the content
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Working Day',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight
                                              .bold), // Optional: Customize text style
                                      // Center the text
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Are you sure to start working day?',
                                  style: TextStyle(
                                      fontSize:
                                          12.0), // Optional: Customize text style
                                  textAlign:
                                      TextAlign.center, // Center the text
                                ),
                                const SizedBox(height: 25.0), // Optional: Add spacing
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Okay',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                label: 'START WORKING DAY',
                width: 180,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
