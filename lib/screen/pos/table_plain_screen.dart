import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/table_plan_controller.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/sale/sale_menu_widget.dart';

class TablePlainScreen extends StatelessWidget {
  const TablePlainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TablePlanController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Sale",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.grid_view),
            ),
          ],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  children: List.generate(
                    25,
                    (index) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          controller.selectIndex(index);
                          Get.to(SaleMenuScreen());
                        },
                        child: Obx(() {
                          bool isSelected =
                              controller.selectedIndex.value == index;
                          return Ink(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.deck,
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                                size: 35,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
