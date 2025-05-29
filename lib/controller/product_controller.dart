import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import '../models/api/product_model.dart';

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
  final Rx<WebImageInfo?> selectedImage = Rx<WebImageInfo?>(null);

 @override
void onInit() {
  super.onInit();
  _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
  _dio.options.connectTimeout = const Duration(seconds: 30);
  _dio.options.receiveTimeout = const Duration(seconds: 30);
  updateAdminStatus();
  fetchProducts();
  searchController.addListener(filterProducts); // Changed from _filterProducts
}

  void updateAdminStatus() {
    final user = _storage.read('user') ?? {};
    final roleId = int.tryParse(user['role_id'].toString()) ?? 0;
    isAdmin.value = roleId == 1;
  }

  void filterProducts() {  // Removed the underscore
  searchQuery.value = searchController.text;
  if (searchQuery.isEmpty) {
    filteredProducts.assignAll(products);
  } else {
    filteredProducts.assignAll(products.where((product) {
      return product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList());
  }
}

  Future<void> fetchProducts() async {
    try {
      loading.value = true;
      errorMessage.value = '';
      final response = await _dio.get(
        '/products',
        options: dio.Options(headers: {
          'Authorization': 'Bearer ${_storage.read('token')}'
        }),
      );

      if (response.statusCode == 200) {
        products.value = (response.data['data'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        filteredProducts.assignAll(products);
      } else {
        throw response.data['message']?.toString() ?? 'Failed to fetch products';
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
    required int categoryId,
    WebImageInfo? imageInfo,
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

  Future<bool> updateProduct({
    required int productId,
    required String name,
    required double price,
    required int categoryId,
    WebImageInfo? imageInfo,
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

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Product deleted successfully');
        await fetchProducts();
        return true;
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to delete product';
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

  void sortByPrice({bool ascending = true}) {
    final sortedProducts = List<Product>.from(filteredProducts);
    sortedProducts.sort((a, b) => 
      ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    filteredProducts.assignAll(sortedProducts);
  }

  void sortByName({bool ascending = true}) {
    final sortedProducts = List<Product>.from(filteredProducts);
    sortedProducts.sort((a, b) => 
      ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    filteredProducts.assignAll(sortedProducts);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}