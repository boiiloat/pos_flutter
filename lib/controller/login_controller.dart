import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  var isLoading = true.obs;
  var pinCode = ''.obs;
  var isLoginProcess = false.obs;
  var isChecked = false.obs;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var rememberMe = false.obs;
  var loading = false.obs;

  void login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    loading.value = true; // Start loading

    if (username.isEmpty || password.isEmpty) {
      Program.error('Error', 'Username and Password cannot be empty');
      loading.value = false; // End loading
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    loading.value = false; // End loading

    if (response.statusCode == 200) {
      Get.to(() => const HomeScreen());
    } else {
      Program.error("Error", "Username or password not correct");
    }
  }

  void updateResult(String value) {
    pinCode.value += value;
  }

  void onKeyNumberPressed(String value) async {
    pinCode("${pinCode.value}$value");
  }

  void onBackspace() {
    pinCode("");
  }

  void onLoginPressed() {
    Get.to(() => const HomeScreen());
    // Get.to(() => const HomeScreen());
    // pinCode.value = '';
  }

  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }
}
