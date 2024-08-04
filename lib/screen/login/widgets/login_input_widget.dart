import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/login_controller.dart';

class LoginInputWidget extends StatelessWidget {
  const LoginInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // var controller = Get.find<LoginController>();
    // final LoginController loginController = get
    final LoginController loginController = Get.find<LoginController>();
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'WELCOME BACK',
            style: TextStyle(
                fontSize: 22,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          SizedBox(
            child: TextFormField(
              controller: loginController.usernameController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade700,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Colors.blue.shade700,
                  size: 25,
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            child: TextFormField(
              controller: loginController.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade700,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock_outline_sharp,
                  color: Colors.blue.shade700,
                  size: 25,
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 35),
          Obx(
            () => InkWell(
              onTap: loginController.loading.value
                  ? null
                  : () {
                      loginController.login();
                    },
              child: Ink(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: loginController.loading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0, // Adjust size as needed
                          ),
                        )
                      : const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
