import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import '../models/api/user_model.dart';

class WebImageInfo {
  final Uint8List bytes;
  final String filename;

  WebImageInfo({required this.bytes, required this.filename});
}

class UserController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final GetStorage _storage = GetStorage();

  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  final RxBool isAdmin = false.obs;
  final Rx<WebImageInfo?> selectedImage = Rx<WebImageInfo?>(null);
  var roles = <Map<String, dynamic>>[
    {'id': 1, 'name': 'Admin'},
    {'id': 2, 'name': 'Cashier'},
  ].obs;
  var selectedRoleId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    updateAdminStatus();
    fetchUsers();
    searchController.addListener(filterUsers);
  }

  void updateAdminStatus() {
    final user = _storage.read('user') ?? {};
    final roleId = int.tryParse(user['role_id'].toString()) ?? 0;
    isAdmin.value = roleId == 1;
  }

  void filterUsers() {
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
      final response = await _dio.get(
        '/users',
        options: dio.Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );

      if (response.statusCode == 200) {
        users.value = (response.data['data'] as List)
            .map((userJson) => User.fromJson(userJson))
            .toList();
        filteredUsers.assignAll(users);
      } else {
        throw response.data['message']?.toString() ?? 'Failed to fetch users';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<bool> createUser({
    required String username,
    required String password,
    required String fullname,
    required int roleId,
    WebImageInfo? imageInfo,
    File? profileImage,
    Uint8List? webImageBytes,
    String? webFilename,
  }) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      dio.FormData formData = dio.FormData.fromMap({
        'username': username,
        'password': password,
        'fullname': fullname,
        'role_id': roleId.toString(),
      });

      if (imageInfo != null) {
        final extension = imageInfo.filename.toLowerCase().split('.').last;
        final contentType = _getContentType(extension);

        formData.files.add(MapEntry(
          'profile_image',
          dio.MultipartFile.fromBytes(
            imageInfo.bytes,
            filename: imageInfo.filename,
            contentType: MediaType.parse(contentType),
          ),
        ));
      }

      final response = await _dio.post(
        '/users',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'User created successfully');
        await fetchUsers();
        return true;
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to create user';
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create user: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> updateUser({
    required int userId,
    required String username,
    required String fullname,
    required int roleId,
    String? password,
    WebImageInfo? imageInfo,
  }) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      dio.FormData formData = dio.FormData.fromMap({
        'username': username,
        'fullname': fullname,
        'role_id': roleId.toString(),
        '_method': 'PUT',
      });

      if (password != null && password.isNotEmpty) {
        formData.fields.add(MapEntry('password', password));
      }

      if (imageInfo != null) {
        final extension = imageInfo.filename.toLowerCase().split('.').last;
        final contentType = _getContentType(extension);

        formData.files.add(MapEntry(
          'profile_image',
          dio.MultipartFile.fromBytes(
            imageInfo.bytes,
            filename: imageInfo.filename,
            contentType: MediaType.parse(contentType),
          ),
        ));
      }

      final response = await _dio.post(
        '/users/$userId',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User updated successfully');
        await fetchUsers();
        return true;
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to update user';
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> deleteUser(int userId) async {
    try {
      final targetUser = users.firstWhereOrNull((user) => user.id == userId);
      if (targetUser == null) {
        Get.snackbar('Error', 'User not found.');
        return false;
      }

      if (targetUser.roleId == 1) {
        Get.snackbar('Warning', 'You cannot delete an Admin user.');
        return false;
      }

      loading.value = true;
      final token = _storage.read('token');

      final response = await _dio.delete(
        '/users/$userId',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar('Success', 'User deleted successfully');
        await fetchUsers();
        return true;
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to delete user';
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  String _getContentType(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
