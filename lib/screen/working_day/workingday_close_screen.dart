import 'package:flutter/material.dart';

class WorkingdayCloseScreen extends StatelessWidget {
  const WorkingdayCloseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade600,
          title: const Text(
            "Close working day",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
