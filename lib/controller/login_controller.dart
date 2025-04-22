import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GetStorage _storage = GetStorage();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var loading = false.obs;

  @override
  void onInit() {
    // For testing: Clear storage when controller initializes
    // _storage.erase();
    super.onInit();
  }

  void togglePasswordVisibilityTemporarily() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    try {
      loading.value = true;
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        throw 'Please enter both username and password';
      }

      final response = await _authService.login(username, password);
      if (response != null) {
        _storage.write('token', response['token']);
        _storage.write('user', response['user']); // Store entire user object
        Get.offAllNamed('/home');

        print('--- Login Success ---');
        print('Storage User Data: ${_storage.read('user')}');
        print('Token: ${response['token']}');
        print('User Data: ${response['user']}');
        print('Full Name: ${response['user']['fullname']}');
        print('Profile Image: ${response['user']['profile_image']}');
      }
    } catch (e) {
      print('Login error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }
}
