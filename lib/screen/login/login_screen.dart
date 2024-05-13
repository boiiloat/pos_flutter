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
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/logo_image.jpg",
                                      ),
                                    ),
                                  ),
                                ),
                                Text("dataxxxxxxxxxxxxxxxxxxxxxxxx"),
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
                color: Colors.white, // Second color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
