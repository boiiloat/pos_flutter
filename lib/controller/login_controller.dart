import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/api/user_model.dart';
import '../program.dart';
import '../screen/home/home_screen.dart';

class LoginController extends GetxController {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var loading = false.obs;
  var loggedInUser = Rxn<User>();

  // Toggles password visibility temporarily
  void togglePasswordVisibilityTemporarily() {
    isPasswordHidden.value = false; // Show password

    // Automatically hide password after 2 seconds
    Timer(const Duration(seconds: 1), () {
      isPasswordHidden.value = true;
    });
  }

  void login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    loading.value = true; // Start loading
    await Future.delayed(const Duration(seconds: 1));

    if (username.isEmpty || password.isEmpty) {
      Program.error('Error', 'Username and Password cannot be empty');
      loading.value = false; // End loading
      return;
    }

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
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('status') &&
          responseData['status'] == 'success' &&
          responseData.containsKey('user') &&
          responseData['user'] is Map<String, dynamic>) {
        try {
          User user = User.fromJson(responseData['user']);
          loggedInUser.value = user;

          usernameController.clear();
          passwordController.clear();
          Program.alert("Login", "Login Successfull ");
          Get.off(() => const HomeScreen());
        } catch (e) {
          Program.error('Error', 'Failed to parse user data');
        }
      } else {
        Program.error("Error", "Invalid response format");
      }
    } else {
      Program.error("Error", "Username or password not correct");
    }
  }
}
