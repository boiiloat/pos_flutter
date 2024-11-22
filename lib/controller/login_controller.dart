import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/models/api/user_model.dart';
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
  var loggedInUser = Rxn<User>();

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
    // print(response.body); 

    loading.value = false; // End loading

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('status') &&
          responseData['status'] == 'success' &&
          responseData.containsKey('user') && // Change from 'users' to 'user'
          responseData['user'] is Map<String, dynamic>) {
        try {
          User user = User.fromJson(
              responseData['user']); // Corrected from 'users' to 'user'
          loggedInUser.value = user;

          usernameController.clear();
          passwordController.clear();
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

  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }

  String _getRoleName(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cashier';
      default:
        return 'Unknown Role';
    }
  }
}
