import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/table_plan_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/pos/Widgets/table_plan_widget.dart';
import 'package:pos_system/screen/sale/sale_menu_screen.dart';

class TablePlanScreen extends StatelessWidget {
  const TablePlanScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TablePlanController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          leading: IconButton(
            onPressed: controller.onBackPressed,
            icon: Icon(
              Icons.arrow_back,
              color: arrowback,
            ),
          ),
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
        body: Obx(
          () => Column(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
