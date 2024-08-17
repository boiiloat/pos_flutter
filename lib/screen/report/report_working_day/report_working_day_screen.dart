import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constans/constan.dart';

class ReportWorkingDayScreen extends StatelessWidget {
  const ReportWorkingDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: Column(
                        children: [
                          Text(
                            'Working Day #WD2024-00012',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text('data'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Container(
                        color: Colors.yellow,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
