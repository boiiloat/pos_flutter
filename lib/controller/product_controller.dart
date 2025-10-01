import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import '../models/api/product_model.dart';
import '../screen/product/category_screen.dart';

class WebImageInfo {
  final Uint8List bytes;
  final String filename;

  WebImageInfo({required this.bytes, required this.filename});
}

class ProductController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final GetStorage _storage = GetStorage();

  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  final RxBool isAdmin = false.obs;
  final RxBool isCashier = false.obs;
  final Rx<WebImageInfo?> selectedImage = Rx<WebImageInfo?>(null);
  var categories = <Map<String, dynamic>>[].obs;
  var selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    updateUserStatus();

    // Load categories first, then products
    fetchCategories().then((_) {
      fetchProducts();
    }).catchError((error) {
      debugPrint('Error in initialization: $error');
      fetchProducts(); // Still try to fetch products even if categories fail
    });

    searchController.addListener(filterProducts);
  }

  Future<void> retryFetchCategories() async {
    try {
      loading.value = true;
      await fetchCategories();
    } catch (e) {
      debugPrint('Retry failed: $e');
    } finally {
      loading.value = false;
    }
  }

  void updateUserStatus() {
    final user = _storage.read('user') ?? {};
    final roleId = int.tryParse(user['role_id'].toString()) ?? 0;
    isAdmin.value = roleId == 1;
    isCashier.value =
        roleId == 2 || roleId == 3; // Adjust based on your cashier role IDs
  }

  void filterProducts() {
    searchQuery.value = searchController.text;

    // Apply both search and category filters
    if (searchQuery.isEmpty && selectedCategoryId.value == 0) {
      // No filters - show all products
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(products.where((product) {
        final searchMatch = searchQuery.isEmpty ||
            product.name
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
        final categoryMatch = selectedCategoryId.value == 0 ||
            product.categoryId == selectedCategoryId.value;

        return searchMatch && categoryMatch;
      }).toList());
    }
  }

  void onCategoryPressed() {
    Get.to(CategoryScreen());
  }

  Future<void> fetchCategories() async {
    try {
      final token = _storage.read('token');
      if (token == null) {
        debugPrint('No token found');
        return;
      }

      final response = await _dio.get(
        '/categories',
        options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data is Map && response.data.containsKey('data')) {
          // Format: { "data": [ ... ] }
          final data = response.data['data'] as List;
          categories.assignAll(data
              .map((category) => {
                    'id': _safeParseInt(category['id']),
                    'name': _safeParseString(category['name']),
                  })
              .toList());
        } else if (response.data is List) {
          // Format: [ ... ]
          categories.assignAll((response.data as List)
              .map((category) => {
                    'id': _safeParseInt(category['id']),
                    'name': _safeParseString(category['name']),
                  })
              .toList());
        } else {
          debugPrint('Unexpected categories response format: ${response.data}');
        }

        debugPrint('Fetched ${categories.length} categories for user');
      } else {
        debugPrint('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      // Add fallback categories for testing
      _addFallbackCategories();
    }
  }

// Fallback method in case API fails
  void _addFallbackCategories() {
    categories.assignAll([
      {'id': 1, 'name': 'Food'},
      {'id': 2, 'name': 'Drinks'},
      {'id': 3, 'name': 'Snacks'},
    ]);
    debugPrint('Using fallback categories');
  }

  Future<void> fetchProducts() async {
    try {
      loading.value = true;
      errorMessage.value = '';
      final response = await _dio.get(
        '/products',
        options: dio.Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );

      if (response.statusCode == 200) {
        products.value = (response.data['data'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        filteredProducts.assignAll(products);
      } else {
        throw response.data['message']?.toString() ??
            'Failed to fetch products';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<bool> createProduct({
    required String name,
    required double price,
    WebImageInfo? imageInfo,
    required int categoryId,
  }) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      dio.FormData formData = dio.FormData.fromMap({
        'name': name,
        'price': price.toString(),
        'category_id': categoryId.toString(),
      });

      if (imageInfo != null) {
        final extension = imageInfo.filename.toLowerCase().split('.').last;
        final contentType = _getContentType(extension);

        formData.files.add(MapEntry(
          'image',
          dio.MultipartFile.fromBytes(
            imageInfo.bytes,
            filename: imageInfo.filename,
            contentType: MediaType.parse(contentType),
          ),
        ));
      }

      final response = await _dio.post(
        '/products',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Product created successfully');
        await fetchProducts();
        return true;
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to create product';
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> updateProduct({
    required int productId,
    required String name,
    required double price,
    WebImageInfo? imageInfo,
    required int categoryId,
  }) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      dio.FormData formData = dio.FormData.fromMap({
        'name': name,
        'price': price.toString(),
        'category_id': categoryId.toString(),
        '_method': 'PUT',
      });

      if (imageInfo != null) {
        final extension = imageInfo.filename.toLowerCase().split('.').last;
        final contentType = _getContentType(extension);

        formData.files.add(MapEntry(
          'image',
          dio.MultipartFile.fromBytes(
            imageInfo.bytes,
            filename: imageInfo.filename,
            contentType: MediaType.parse(contentType),
          ),
        ));
      }

      final response = await _dio.post(
        '/products/$productId',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Product updated successfully');
        await fetchProducts();
        return true;
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to update product';
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      final response = await _dio.delete(
        '/products/$productId',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar('Success', 'Product deleted successfully');
        await Future.delayed(const Duration(milliseconds: 300));
        await fetchProducts();
        return true;
      } else {
        final data = response.data;
        final errorMsg = data is Map && data.containsKey('message')
            ? data['message']
            : 'Failed to delete product';
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  void filterByCategory(int categoryId) {
    if (categoryId == 0) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((product) => product.categoryId == categoryId).toList(),
      );
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

  static int _safeParseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String _safeParseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
