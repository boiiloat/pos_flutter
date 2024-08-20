import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/table_plan_controller.dart';
import 'package:pos_system/screen/pos/table_plan/widgets/table_plan_widget.dart';

import 'widgets/table_plan_add_new.dart';

class TablePlanScreen extends StatelessWidget {
  const TablePlanScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TablePlanController());

    return SafeArea(
      child: Scaffold(
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
        body: Obx(
          () => Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.add_shopping_cart),
                    SizedBox(width: 5),
                    Text(
                      'Table Layout',
                    ),
                  ],
                ),
              ),
              TablePlanAddNewWidget(
                onPressed: () {},
              ),
              SingleChildScrollView(
                child: Wrap(
                  children: List.generate(
                    controller.tableData.length,
                    (index) => TablePlanWidget(
                      table_label: controller.tableData[index]['name'],
                      onPressed: controller.onTablePlanPressed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
