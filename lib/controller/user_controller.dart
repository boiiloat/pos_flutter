import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/api/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
class UserController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  final GetStorage _storage = GetStorage();
  
  var users = <User>[].obs; // Changed to List<User>
  var loading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

Future<void> fetchUsers() async {
  try {
    loading.value = true;
    errorMessage.value = '';
    
    final response = await _apiService.get(
      '/users',
      headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
    );

    if (response.statusCode == 200) {
      // Add debug print to see raw response
      
      users.value = (response.body['data'] as List)
          .map((userJson) {
            // Debug print each user JSON
            return User.fromJson(userJson);
          })
          .toList();
    } else {
      throw response.body['message']?.toString() ?? 'Failed to fetch users';
    }
  } catch (e) {
    errorMessage.value = e.toString();
    Get.snackbar('Error', e.toString());
  } finally {
    loading.value = false;
  }
}
  // Update other methods to work with User model
  Future<void> createUser({
    required String username,
    required String password,
    required String fullname,
    required int roleId,
  }) async {
    try {
      loading.value = true;
      errorMessage.value = '';

      final response = await _apiService.post(
        '/users',
        {
          'username': username,
          'password': password,
          'fullname': fullname,
          'role_id': roleId,
        },
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
        },
      );

      if (response.statusCode == 201) {
        await fetchUsers(); // Refresh the list with User objects
        Get.back(); // Close dialog
        Get.snackbar(
          'Success',
          'User created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw response.body['message'] ?? 'Failed to create user';
      }
    } catch (e) {
      errorMessage.value = e.toString();
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