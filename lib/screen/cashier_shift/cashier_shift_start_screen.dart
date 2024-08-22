import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/main_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/working_day/widgets/footer_action_widget.dart';
import 'package:pos_system/screen/working_day/widgets/kpi_working_day_widget.dart';

class ShiftStartScreen extends StatelessWidget {
  const ShiftStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerx = Get.put(MainController());

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
                Icon(Icons.schedule),
                SizedBox(width: 5),
                Text(
                  'OPEN SHIFT',
                ),
              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KpiWorkingDayWidget(
                label: 'Working No',
                data: 'WD2024-0019',
              ),
              SizedBox(width: 20),
              KpiWorkingDayWidget(
                label: 'Working Date',
                data: '01/08/2024',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const KpiWorkingDayWidget(
                label: 'POS Profile',
                data: 'Admin',
              ),
              const SizedBox(width: 20),
              Obx(() {
                return Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shift', // Label text
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 20, // Adjust height as needed
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controllerx.selectedItem.value,
                              items: controllerx.dropdownItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item,
                                            style:
                                                const TextStyle(fontSize: 13)),
                                      ))
                                  .toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  controllerx.updateSelectedItem(newValue);
                                }
                              },
                              style: const TextStyle(fontSize: 13),
                              isExpanded: true,
                              iconSize: 22, // Adjust icon size if needed
                              alignment:
                                  Alignment.centerLeft, // Optional: align text
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0), // Remove extra padding
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 590,
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
                label: 'Cancel',
                width: 120,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Open Shift',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight
                                              .bold), // Optional: Customize text style
                                      // Center the text
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Are you sure to open shift?',
                                  style: TextStyle(
                                      fontSize:
                                          12.0), // Optional: Customize text style
                                  textAlign:
                                      TextAlign.center, // Center the text
                                ),
                                SizedBox(height: 25.0), // Optional: Add spacing
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
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
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
                label: 'OPEN SHIFT ',
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
