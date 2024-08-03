import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/main_controller.dart';

class testing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the DropdownController
    final  controllerx = Get.put(MainController());

    return Scaffold(
      appBar: AppBar(title: Text('DropdownButton with GetX')),
      body: Center(
        child: Obx(() {
          return DropdownButton<String>(
            value: controllerx.selectedItem.value,
            items: controllerx.dropdownItems
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                controllerx.updateSelectedItem(newValue);
              }
            },
          );
        }),
      ),
    );
  }
}
