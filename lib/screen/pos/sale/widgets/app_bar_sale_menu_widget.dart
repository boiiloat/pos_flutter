import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/home_screen.dart';

class AppBarSaleMenuWidget extends StatelessWidget {
  const AppBarSaleMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.to(const HomeScreen());
                    },
                    icon: const Icon(
                      Icons.home,
                      size: 25,
                      color: Colors.white,
                    )),
                const Text(
                  'POS',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Text(
                  'T04',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 200,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search....',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
            ),
            const Text(
              '23-05-2024   10 : 11 PM',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
