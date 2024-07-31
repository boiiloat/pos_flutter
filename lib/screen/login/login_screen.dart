import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';
import 'widgets/login_input_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return SafeArea(
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
                                image:
                                    AssetImage("assets/images/logo_image.jpg"),
                              ),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.grey.shade200)),
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
                          "Name",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          " POS Restaurant",
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
                          "+855 76 58 89 898",
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
            const Expanded(
              flex: 3,
              child: LoginInputWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
