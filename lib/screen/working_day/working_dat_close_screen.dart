import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/working_day/widgets/footer_action_widget.dart';
import 'package:pos_system/screen/working_day/widgets/kpi_working_day_widget.dart';

class WorkingDayCloseScreen extends StatelessWidget {
  const WorkingDayCloseScreen({super.key});

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
                Icon(Icons.event),
                SizedBox(width: 5),
                Text(
                  'Working Day #WD2024-0018',
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
              SizedBox(width: 15),
              KpiWorkingDayWidget(
                label: 'Working Date',
                data: '01/08/2024',
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 574,
            child: Card(
              elevation: 3,
              child: SizedBox(
                height: 70, // Set the desired height here
                child: TextFormField(
                  maxLines: null,
                  expands:
                      true, // This makes the TextFormField take all available space
                  decoration: const InputDecoration(
                    labelText: "Closed Note",
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
                  Get.to(const HomeScreen());
                },
                label: 'CLOSE WORKING DAY',
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
