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
        appBar: AppBar(
          leading:IconButton(onPressed: controller.onBackPressed, icon: Icon(Icons.arrow_back,color: arrowback,)),
          backgroundColor: Colors.red,
          title: Row(
            children: [
              const Text(
                "Table layout",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 10),
              Icon(Icons.add_shopping_cart),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
              
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle,size: 30,),
                  ),
                  Text('Add Table',style: TextStyle(color: Colors.white,fontSize: 16),),
                ],
              ),
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
