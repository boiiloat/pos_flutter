import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';

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
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(23.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/logo_image.jpg'),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "SNACK & RELAX",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "xxxxxxxxxxxxxx",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 17),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "xxxxxxxxxxxxxx",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 17),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "xxxxx xxxxx xxxxxxxxxxxxxxxxxxxxx",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  "Location",
                                  style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 17),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(),
                      )
                    ],
                  )),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black26,
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
                                  const EdgeInsets.fromLTRB(40, 20, 40, 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LoginPinCodeBoxWidget(
                                    pinCode: controller.pinCode.value,
                                    onBackspacePressed: controller.onBackspace,
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
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
                                          ),
                                          LoginKeyNumberWidget(
                                            name: "2",
                                            title: "2",
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
                                          ),
                                          LoginKeyNumberWidget(
                                            name: "3",
                                            title: "3",
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
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
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
                                          ),
                                          LoginKeyNumberWidget(
                                            name: "5",
                                            title: "5",
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
                                          ),
                                          LoginKeyNumberWidget(
                                            name: "6",
                                            title: "6",
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
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
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
                                          ),
                                          LoginKeyNumberWidget(
                                            name: "8",
                                            title: "8",
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
                                          ),
                                          LoginKeyNumberWidget(
                                            name: "9",
                                            title: "9",
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
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
                                            disabled:
                                                controller.isLoginProcess.value,
                                            onPressed:
                                                controller.onKeyNumberPressed,
                                          ),
                                          LoginKeyNumberWidget(
                                            flex: 4,
                                            name: "Login",
                                            disabled:
                                                controller.isLoginProcess.value,
                                            title: "Login",
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
    );
  }
}
