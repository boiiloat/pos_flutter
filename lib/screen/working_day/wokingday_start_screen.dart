import 'package:flutter/material.dart';

class WorkingdayStartScreen extends StatelessWidget {
  const WorkingdayStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade600,
          title: const Text(
            "Start working day",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "XXXX XXX XXX XXXXX",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("data: xxxxxxxx"),
                  Text("data: xxxxxxxx"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
