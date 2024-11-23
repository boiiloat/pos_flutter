import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/login_controller.dart';

class LoginInputWidget extends StatelessWidget {
  const LoginInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                'WELCOME BACK',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
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
              Obx(
                () => SizedBox(
                  child: TextFormField(
                    controller: loginController.passwordController,
                    obscureText: loginController.isPasswordHidden.value,
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue.shade700,
                        ),
                        onPressed: loginController.togglePasswordVisibilityTemporarily,
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
                                strokeWidth: 2.0,
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
        ),
      ),
    );
  }
}
