import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';


class ReportExpanseScreen extends StatelessWidget {
  const ReportExpanseScreen({super.key});

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
    );
  }
}
