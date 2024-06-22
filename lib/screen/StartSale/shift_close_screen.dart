import 'package:flutter/material.dart';

class ShiftCloseScreen extends StatelessWidget {
  const ShiftCloseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            'Clsoe Shift',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
