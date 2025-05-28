import 'dart:io' as io show File, Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import '../models/api/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../screen/user/Widgets/user_add_dailog.dart';

class UserController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  final GetStorage _storage = GetStorage();
  late final dio.Dio _dio;

  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  final RxBool isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
    updateAdminStatus();
    _initializeAdminStatus();
    fetchUsers();
    searchController.addListener(_filterUsers);
  }

  void _initializeDio() {
    _dio = dio.Dio();

    // Configure Dio for better web compatibility
    if (kIsWeb) {
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);
      _dio.options.sendTimeout = const Duration(seconds: 30);
    }
  }

  void updateAdminStatus() {
    final user = _storage.read('user') ?? {};
    final roleId = int.tryParse(user['role_id'].toString()) ?? 0;
    isAdmin.value = roleId == 1;
  }

  void _initializeAdminStatus() {
    final user = _storage.read('user') ?? {};
    final roleId = int.tryParse(user['role_id'].toString()) ?? 0;
    isAdmin.value = roleId == 1;
  }

  void _filterUsers() {
    searchQuery.value = searchController.text;
    if (searchQuery.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(users.where((user) {
        return user.username
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            user.fullname
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
      }).toList());
    }
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
        users.value = (response.body['data'] as List)
            .map((userJson) => User.fromJson(userJson))
            .toList();
        filteredUsers.assignAll(users);
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

  // Remove the separate uploadImage method since we'll include the image in the user creation request

  Future<bool> createUser({
    required String username,
    required String password,
    required String fullname,
    required int roleId,
    io.File? profileImage,
    Uint8List? webImageBytes,
    String? webFilename,
  }) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      // Use HTTP instead of HTTPS for localhost
      final baseUrl =
          kIsWeb ? 'http://127.0.0.1:8000' : 'https://127.0.0.1:8000';

      print('Creating user with image...'); // Debug log

      // Create FormData to include both user data and image
      dio.FormData formData = dio.FormData.fromMap({
        'username': username,
        'password': password,
        'fullname': fullname,
        'role_id': roleId.toString(),
      });

      // Add image to form data if provided
      if (kIsWeb && webImageBytes != null && webFilename != null) {
        // Determine content type based on file extension
        String contentType = 'image/jpeg';
        final extension = webFilename.toLowerCase().split('.').last;
        if (extension == 'png') contentType = 'image/png';
        if (extension == 'gif') contentType = 'image/gif';
        if (extension == 'webp') contentType = 'image/webp';

        formData.files.add(MapEntry(
          'profile_image', // This should match your Laravel backend field name
          dio.MultipartFile.fromBytes(
            webImageBytes,
            filename: webFilename,
            contentType: MediaType.parse(contentType),
          ),
        ));
        print('Added web image to form data: $webFilename'); // Debug log
      } else if (profileImage != null) {
        formData.files.add(MapEntry(
          'profile_image', // This should match your Laravel backend field name
          await dio.MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
          ),
        ));
        print(
            'Added file image to form data: ${profileImage.path}'); // Debug log
      }

      print('Sending request to: $baseUrl/api/users'); // Debug log

      final response = await _dio.post(
        '$baseUrl/api/users',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            // Don't set Content-Type here, let Dio handle it for multipart
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      print(
          'Create user response: ${response.statusCode} ${response.data}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'User created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchUsers(); // Refresh user list
        return true;
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to create user';
        Get.snackbar('Error', errorMsg);
        print("Create user failed: ${response.statusCode} ${response.data}");
        return false;
      }
    } on dio.DioException catch (e) {
      print("Dio Create user error: ${e.type} - ${e.message}");
      if (e.response != null) {
        print("Response data: ${e.response?.data}");
      }

      String errorMessage = 'Failed to create user';

      if (e.type == dio.DioExceptionType.connectionError) {
        errorMessage =
            'Cannot connect to server. Please check your connection.';
      } else if (e.type == dio.DioExceptionType.connectionTimeout) {
        errorMessage = 'Request timed out. Please try again.';
      } else if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      }

      Get.snackbar('Error', errorMessage);
      return false;
    } catch (e) {
      print("General Create user error: $e");
      Get.snackbar('Error', 'Failed to create user: $e');
      return false;
    } finally {
      loading.value = false;
    }
  }

  void onAddNewUserPressed() {
    if (!isAdmin.value) {
      Get.snackbar(
        'Permission Denied',
        'Only admin users can add new users',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      const AddUserDialog(),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
