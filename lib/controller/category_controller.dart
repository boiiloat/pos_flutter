import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/program.dart';
import '../../models/api/category_model.dart';

class CategoryController extends GetxController {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final TextEditingController searchController = TextEditingController();

  var categories = <Category>[].obs;
  var filteredCategories = <Category>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    fetchCategories();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
      filterCategories();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    try {
      loading.value = true;
      errorMessage.value = '';
      final token = _storage.read('token');
      final response = await _dio.get(
        '/categories',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        categories.value = (response.data['data'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
        filterCategories();
      } else {
        errorMessage.value = 'Failed to fetch categories';
        Program.showError(errorMessage.value);
      }
    } on DioException catch (e) {
      errorMessage.value = e.response?.data?['message'] ??
          'Failed to fetch categories: ${e.message}';
      Program.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Program.showError(errorMessage.value);
    } finally {
      loading.value = false;
    }
  }

  void filterCategories() {
    if (searchQuery.isEmpty) {
      filteredCategories.value = List.from(categories);
    } else {
      filteredCategories.value = categories.where((category) {
        return category.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
  }

  Future<void> handleAddCategory(String name) async {
    try {
      loading.value = true;
      errorMessage.value = '';
      final token = _storage.read('token');

      final response = await _dio.post(
        '/categories',
        data: {'name': name},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final newCategory = Category.fromJson(response.data['data']);
        categories.add(newCategory);
        filterCategories();
        Get.back(); // Close dialog
        Program.showSuccess("Category added successfully");
      } else {
        errorMessage.value = 'Failed to add category';
        Program.showError(errorMessage.value);
      }
    } on DioException catch (e) {
      errorMessage.value = e.response?.data?['message'] ??
          'Failed to add category: ${e.message}';
      Program.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Program.showError(errorMessage.value);
    } finally {
      loading.value = false;
    }
  }

  Future<void> handleEditCategory(int id, String name) async {
    try {
      loading.value = true;
      errorMessage.value = '';
      final token = _storage.read('token');

      final response = await _dio.put(
        '/categories/$id',
        data: {'name': name},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final index = categories.indexWhere((c) => c.id == id);
        if (index != -1) {
          categories[index] = Category.fromJson(response.data['data']);
          filterCategories();
        }
        Get.back(); // Close dialog
        Program.showSuccess("Category updated successfully");
      } else {
        errorMessage.value = 'Failed to update category';
        Program.showError(errorMessage.value);
      }
    } on DioException catch (e) {
      errorMessage.value = e.response?.data?['message'] ??
          'Failed to update category: ${e.message}';
      Program.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Program.showError(errorMessage.value);
    } finally {
      loading.value = false;
    }
  }

  Future<void> handleDeleteCategory(int id) async {
    try {
      final category = categories.firstWhere((c) => c.id == id);

      if (category.products.isNotEmpty) {
        Program.showWarning(
            "This category cannot be deleted because it has associated products.");
        return;
      }

      loading.value = true;
      errorMessage.value = '';
      final token = _storage.read('token');

      final response = await _dio.delete(
        '/categories/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        categories.removeWhere((c) => c.id == id);
        filterCategories();
        Get.back(); // Close dialog
        Program.showSuccess("Category deleted successfully");
      } else {
        errorMessage.value = 'Failed to delete category';
        Program.showError(errorMessage.value);
      }
    } on DioException catch (e) {
      errorMessage.value = e.response?.data?['message'] ??
          'Failed to delete category: ${e.message}';
      Program.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Program.showError(errorMessage.value);
    } finally {
      loading.value = false;
    }
  }

  void showAddCategoryDialog() {
    final nameController = TextEditingController();

    Get.defaultDialog(
      title: "Add Category",
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Category Name',
          border: OutlineInputBorder(),
        ),
      ),
      textConfirm: "Add",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (nameController.text.trim().isNotEmpty) {
          await handleAddCategory(nameController.text.trim());
        } else {
          Program.showError("Please enter category name");
        }
      },
    );
  }

  void showEditCategoryDialog(int id) {
    final category = categories.firstWhere((c) => c.id == id);
    final nameController = TextEditingController(text: category.name);

    Get.defaultDialog(
      title: "Edit Category",
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Category Name',
          border: OutlineInputBorder(),
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (nameController.text.trim().isNotEmpty) {
          await handleEditCategory(id, nameController.text.trim());
        } else {
          Program.showError("Please enter category name");
        }
      },
    );
  }

  void showDeleteCategoryDialog(int id) {
    Get.defaultDialog(
      title: "Confirm Delete",
      content: const Text("Are you sure you want to delete this category?"),
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await handleDeleteCategory(id);
      },
    );
  }
}
