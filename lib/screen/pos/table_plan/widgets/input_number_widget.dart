import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/table_plan_controller.dart';

import 'guest_cover_key_number_widget.dart';
import 'guest_cover_pin_code_box_widget.dart';

class InputNumberWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const InputNumberWidget(
      {super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TablePlanController());
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 21,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 10),
          GuestCoverPincodeBoxWidget(
            guestCover: controller.guestCover.value,
            onBackspacePressed: controller.onBackspace,
            disabled: controller.isLoginProcess.value,
            label: 'Enter number',
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GusetCoverKeyNumberWidget(
                    name: "1",
                    title: "1",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "2",
                    title: "2",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "3",
                    title: "3",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GusetCoverKeyNumberWidget(
                    name: "4",
                    title: "4",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "5",
                    title: "5",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "6",
                    title: "6",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GusetCoverKeyNumberWidget(
                    name: "7",
                    title: "7",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "8",
                    title: "8",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "9",
                    title: "9",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GusetCoverKeyNumberWidget(
                    name: "00",
                    title: "00",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "0",
                    title: "0",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                  GusetCoverKeyNumberWidget(
                    name: ".",
                    title: ".",
                    color: Colors.grey.shade600,
                    disabled: controller.isLoginProcess.value,
                    onPressed: controller.onKeyNumberPressed,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GusetCoverKeyNumberWidget(
                    name: "cancel",
                    title: "Cancel",
                    color: Colors.red,
                    disabled: controller.isLoginProcess.value,
                    onPressed: (val) => {
                      Get.back(),
                      controller.onCancelPressed,
                    },
                  ),
                  GusetCoverKeyNumberWidget(
                    name: "Accept",
                    title: "Accept",
                    color: Colors.green,
                    disabled: controller.isLoginProcess.value,
                    onPressed: (val) => {onPressed()},
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
