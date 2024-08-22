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
        body: Column(
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
            // SingleChildScrollView(
            //   child: Wrap(
            //     children: List.generate(
            //       controller.tableData.length,
            //       (index) => TablePlanWidget(
            //         table_label: controller.tableData[index]['name'],
            //         onPressed: controller.onTablePlanPressed,
            //       ),
            //     ),
            //   ),
            // ),
            SingleChildScrollView(
              child: Wrap(
                children: [
                  TablePlanWidget(
                    onPressed: () {
                      controller.onTablePlanPressed();
                    },
                    table_label: 'T01',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T02',
                    color: Colors.red,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T03',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T04',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T05',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T06',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T07',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T08',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T09',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T10',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T11',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T12',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T13',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T14',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T15',
                    color: Colors.red,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T16',
                    color: Colors.red,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T17',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T17',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T8',
                    color: Colors.red,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T20',
                    color: Colors.grey.shade400,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T21',
                    color: Colors.red,
                  ),
                  TablePlanWidget(
                    onPressed: () {},
                    table_label: 'T22',
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
