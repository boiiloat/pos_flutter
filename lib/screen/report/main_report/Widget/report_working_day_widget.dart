import 'package:flutter/material.dart';

class ReportWorkingDayWidget extends StatelessWidget {
  const ReportWorkingDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              children: [
                Text(
                  "Working day & Shift Report",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              'Grid 2',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
