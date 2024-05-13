import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';

import '../../constans/constan.dart';
import '../login/widgets/login_pin_code_box_widget.dart';
import '../login/widgets/login_key_number_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade600,
          automaticallyImplyLeading: false,
          title: const Text(
            'ePOS ',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/logo_image.jpg",
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Snack & Relax",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 35),
                                const Text(
                                  "090934872",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Contact",
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Pouk / Siem Reap / Cambodia",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Address",
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Snakandrelax@gmail.com",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    ],
                  )),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoginPinCodeBoxWidget(
                      pinCode: controller.pinCode.value,
                      onBackspacePressed: controller.onBackspace,
                      disabled: controller.isLoginProcess.value,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LoginKeyNumberWidget(
                              name: "1",
                              title: "1",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                            LoginKeyNumberWidget(
                              name: "2",
                              title: "2",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                            LoginKeyNumberWidget(
                              name: "3",
                              title: "3",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LoginKeyNumberWidget(
                              name: "4",
                              title: "4",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                            LoginKeyNumberWidget(
                              name: "5",
                              title: "5",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                            LoginKeyNumberWidget(
                              name: "6",
                              title: "6",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LoginKeyNumberWidget(
                              name: "7",
                              title: "7",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                            LoginKeyNumberWidget(
                              name: "8",
                              title: "8",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                            LoginKeyNumberWidget(
                              name: "9",
                              title: "9",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LoginKeyNumberWidget(
                              flex: 2,
                              name: "0",
                              title: "0",
                              disabled: controller.isLoginProcess.value,
                              onPressed: controller.onKeyNumberPressed,
                            ),
                            LoginKeyNumberWidget(
                              flex: 4,
                              name: "Login",
                              disabled: controller.isLoginProcess.value,
                              // customTitle: TextIconLoadingWidget(
                              //   color: controller.isLoginProcess.value
                              //       ? Colors.grey[500]!
                              //       : appColor,
                              //   // isSuffixIcon: true,
                              //   isLoading: controller.isLoginProcess.value,
                              //   title: "Login".tr,
                              //   icon: Icons.login,
                              //   fontSize: 14,
                              // ),
                              title: "Login".tr,
                              onPressed: controller.onLoginPressed,
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
    );
  }
}
