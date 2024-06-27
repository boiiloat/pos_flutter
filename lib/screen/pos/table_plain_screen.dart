import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/table_plan_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/sale/sale_menu_screen.dart';

class TablePlainScreen extends StatelessWidget {
  const TablePlainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TablePlanController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          leading:IconButton(onPressed: controller.onBackPressed, icon: Icon(Icons.arrow_back,color: arrowback,),),
          backgroundColor: Colors.red,
          title: const Row(
            children: [
               Text(
                "Table layout",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 10),
              Icon(Icons.add_shopping_cart),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
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
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          controller.selectIndex(index);
                          Get.to(const SaleMenuScreen());
                        },
                        child: Obx(() {
                          bool isSelected =
                              controller.selectedIndex.value == index;
                          return Ink(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('T1',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                Icon(
                                  Icons.deck,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.red,
                                  size: 35,
                                ),
                              ],
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
