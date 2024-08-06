import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/main_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/working_day/widgets/footer_action_widget.dart';
import 'package:pos_system/screen/working_day/widgets/kpi_working_day_widget.dart';

class ShiftCloseScreen extends StatelessWidget {
  const ShiftCloseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SNACK AND RELAX',
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
                  'CLOSE SHIFT',
                ),
              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KpiWorkingDayWidget(
                label: 'Working Day',
                data: 'WD2024-0019',
              ),
              SizedBox(width: 20),
              KpiWorkingDayWidget(
                label: 'Cashier Shift',
                data: 'CS2024-0024',
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KpiWorkingDayWidget(
                label: 'Close Date',
                data: '02-08-2024',
              ),
              const SizedBox(width: 20),
              KpiWorkingDayWidget(
                label: 'Shift Name',
                data: 'Morning Shift',
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KpiWorkingDayWidget(
                label: 'POS Profile',
                data: 'Admin',
              ),
              SizedBox(width: 300),
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
                    labelText: "Close Note",
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
                  Program.alert("title", "description");
                },
                label: 'Close Shift ',
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
