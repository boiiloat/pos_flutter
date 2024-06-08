import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';
import 'package:pos_system/screen/login/widgets/clear_key.dart';

import '../login/widgets/login_pin_code_box_widget.dart';
import '../login/widgets/login_key_number_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return Obx(() => SafeArea(
          child: Scaffold(
            body: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg_image.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 420,
                        width: 310,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Container(
                              height: 82,
                              width: 82,
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/logo_image.jpg"),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(color: Colors.grey.shade200)),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              " SNACK & RELAX",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              " SNACK & RELAX ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Bussiness",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              " Cashier ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "POS Profile",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "+855 90 93 48 72",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Salakomrerk comminue, Siem Reap City ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Address",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 9,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(70, 20, 70, 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      LoginPinCodeBoxWidget(
                                        pinCode: controller.pinCode.value,
                                        onBackspacePressed:
                                            controller.onBackspace,
                                        disabled:
                                            controller.isLoginProcess.value,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoginKeyNumberWidget(
                                                name: "1",
                                                title: "1",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                              LoginKeyNumberWidget(
                                                name: "2",
                                                title: "2",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                              LoginKeyNumberWidget(
                                                name: "3",
                                                title: "3",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoginKeyNumberWidget(
                                                name: "4",
                                                title: "4",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                              LoginKeyNumberWidget(
                                                name: "5",
                                                title: "5",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                              LoginKeyNumberWidget(
                                                name: "6",
                                                title: "6",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoginKeyNumberWidget(
                                                name: "7",
                                                title: "7",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                              LoginKeyNumberWidget(
                                                name: "8",
                                                title: "8",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                              LoginKeyNumberWidget(
                                                name: "9",
                                                title: "9",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoginKeyNumberWidget(
                                                flex: 2,
                                                name: "0",
                                                title: "0",
                                                disabled: controller
                                                    .isLoginProcess.value,
                                                onPressed: controller
                                                    .onKeyNumberPressed,
                                              ),
                                              ClearKeyWidget(
                                                title: 'CLEAR',
                                                flex: 4,
                                                btnColor: Colors.red.shade800,
                                                onPressed:
                                                    controller.onBackspace,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              ClearKeyWidget(
                                                title: 'Login',
                                                btnColor: Colors.blue.shade800,
                                                onPressed:
                                                    controller.onLoginPressed,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
