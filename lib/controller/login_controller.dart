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
  
  // Add observable for logged in user
  var loggedInUser = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    // Load user data from storage when controller initializes
    _loadUserFromStorage();
    super.onInit();
  }

  void _loadUserFromStorage() {
    final userData = _storage.read('user');
    print('Loading user data from storage: $userData'); // Debug print
    if (userData != null) {
      loggedInUser.value = Map<String, dynamic>.from(userData);
      print('Loaded user: ${loggedInUser.value}'); // Debug print
    } else {
      print('No user data found in storage'); // Debug print
    }
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
        print('Login response: $response'); // Debug print
        _storage.write('token', response['token']);
        _storage.write('user', response['user']); // Store entire user object
        
        // Update the observable user data
        loggedInUser.value = Map<String, dynamic>.from(response['user']);
        print('Stored user data: ${loggedInUser.value}'); // Debug print
        
        Get.offAllNamed('/home');
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

  // Helper methods to get user data
  String get userFullName {
    return loggedInUser.value?['full_name'] ?? 'Unknown User';
  }
  
  String get username {
    return loggedInUser.value?['username'] ?? 'Unknown';
  }
  
  int? get roleId => loggedInUser.value?['role_id'];
  
  String? get profileImage => loggedInUser.value?['profile_image'];
  
  int? get userId => loggedInUser.value?['id'];
  
  // Method to clear user data on logout
  void logout() {
    _storage.erase();
    loggedInUser.value = null;
    usernameController.clear();
    passwordController.clear();
  }

  // Debug method to check stored data
  void checkStoredData() {
    print('=== Storage Debug ===');
    print('Token: ${_storage.read('token')}');
    print('User: ${_storage.read('user')}');
    print('LoggedInUser value: ${loggedInUser.value}');
    print('==================');
  }

  // Alternative method to get user data directly from storage
  Map<String, dynamic>? getUserFromStorage() {
    final userData = _storage.read('user');
    return userData != null ? Map<String, dynamic>.from(userData) : null;
  }
}