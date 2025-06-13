import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:pos_system/program.dart';

// Use alias to resolve name conflicts
import '../../models/api/category_model.dart' as category_model;
import '../../models/api/product_model.dart' as product_model;

class SaleController extends GetxController {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  // Search + Admin
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  final RxBool isAdmin = false.obs;

  // Category
  var categories = <category_model.Category>[].obs;
  var filteredCategories = <category_model.Category>[].obs;

  // Product
  var products = <product_model.Product>[].obs;
  var filteredProducts = <product_model.Product>[].obs;

  var loading = false.obs;
  var errorMessage = ''.obs;

  final RxInt selectedCategoryId = 0.obs; // 0 means 'All'

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';

    updateAdminStatus();
    fetchCategories();
    fetchProducts();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
      filterProducts();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void updateAdminStatus() {
    final user = _storage.read('user') ?? {};
    final roleId = int.tryParse(user['role_id'].toString()) ?? 0;
    isAdmin.value = roleId == 1;
  }

  Future<void> fetchCategories() async {
    try {
      loading.value = true;
      final token = _storage.read('token');
      final response = await _dio.get(
        '/categories',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final rawList = (response.data['data'] as List)
            .map((json) => category_model.Category.fromJson(json))
            .toList();

        // Inject "All" category at the start
        categories.value = [
              category_model.Category(
                  id: 0,
                  name: 'All',
                  createdDate: '',
                  createdBy: '',
                  products: [])
            ] +
            rawList;

        filteredCategories.assignAll(categories);
      } else {
        Program.showError('Failed to fetch categories');
      }
    } catch (e) {
      Program.showError('Category fetch error: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      loading.value = true;
      final token = _storage.read('token');
      final response = await _dio.get(
        '/products',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        products.value = (response.data['data'] as List)
            .map((json) => product_model.Product.fromJson(json))
            .toList();
        filteredProducts.assignAll(products);
      } else {
        Program.showError('Failed to fetch products');
      }
    } catch (e) {
      Program.showError('Product fetch error: $e');
    } finally {
      loading.value = false;
    }
  }

  void filterProducts() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((p) => p.name.toLowerCase().contains(query)).toList(),
      );
    }
  }

  void filterProductsByCategory(int categoryId) {
    if (categoryId == 0) {
      filteredProducts.assignAll(products); // 'All' selected
    } else {
      filteredProducts.assignAll(
        products.where((p) => p.categoryId == categoryId).toList(),
      );
    }
  }

  void onPayPressed() {
    Program.success("Pay", "Processing payment...");
  }

  void onSubmitPre() {
    Program.success("Submit", "Pre-order submitted.");
  }

  void filterProductsByName(String query) {}
}
