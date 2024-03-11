import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_image.jpg"),
          fit: BoxFit.cover,
        ),
      ),
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
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                  child: VerticalDivider(
                                    thickness: 1.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      border: Border(
                                        left: BorderSide(
                                          width: 0.25,
                                          color: Colors.grey[400]!,
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "1",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "2",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "3",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "4",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "5",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "6",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "7",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "8",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "9",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 105,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    child: InkWell(
                                      onTap: controller.onLoginPressed,
                                      child: Container(
                                        height: 50,
                                        width: 210,
                                        color: Colors.white,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.login),
                                              SizedBox(width: 10),
                                              Text(
                                                "LogIn",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
    );
  }
}
