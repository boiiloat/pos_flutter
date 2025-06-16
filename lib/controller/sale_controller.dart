import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:pos_system/program.dart';
import '../../models/api/category_model.dart' as category_model;
import '../../models/api/product_model.dart' as product_model;
import '../../models/api/sale_model.dart' as sale_model;

class SaleControllerx extends GetxController {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final searchController = TextEditingController();

  // UI State
  var searchQuery = ''.obs;
  var isAdmin = false.obs;
  var categories = <category_model.Category>[].obs;
  var filteredCategories = <category_model.Category>[].obs;
  var products = <product_model.Product>[].obs;
  var filteredProducts = <product_model.Product>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;
  var selectedCategoryId = 0.obs;

  // Sale
  var currentSale = Rxn<sale_model.Sale>();
  var saleSubtotal = 0.0.obs;
  // var saleTax = 0.0.obs;
  var saleDiscount = 0.0.obs;
  var saleTotal = 0.0.obs;
  var selectedTable = 'None'.obs;
  var lastDiscountType = 'percent'.obs;

  Timer? _debounceTimer;

  String getProductKey(product_model.Product product) {
    return '${product.id}_${product.price.toString()}';
  }

  // Cart Management
  var cartItems = <product_model.Product>[].obs;
  var cartQuantities = <String, int>{}.obs; // Key format: "id_price"

  @override
  void onInit() {
    super.onInit();
    _configureDio();
    _initializeData();
    _setupSearchListener();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // void _configureDio() {
  //   _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
  //   _dio.interceptors.add(InterceptorsWrapper(
  //     onError: (error, handler) {
  //       final statusCode = error.response?.statusCode;
  //       final message = _getErrorMessage(statusCode);
  //       errorMessage.value = message;
  //       Program.showError(message);
  //       handler.next(error);
  //     },
  //   ));
  // }

  String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 401:
        return 'Authentication failed. Please login again.';
      case 403:
        return 'Access denied';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Network error occurred';
    }
  }

  void _initializeData() {
    updateAdminStatus();
    fetchCategories();
    fetchProducts();
  }

  void _setupSearchListener() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text.trim();
    _filterProductsWithDebounce();
  }

  void _filterProductsWithDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), filterProducts);
  }

  void updateAdminStatus() {
    try {
      final user = _storage.read('user');
      if (user != null && user is Map) {
        isAdmin.value = (int.tryParse(user['role_id']?.toString() ?? '0') == 1);
      }
    } catch (e) {
      isAdmin.value = false;
      Program.showError('Error reading user data: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      loading(true);
      errorMessage.value = '';
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      final response = await _dio.get(
        '/categories',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List? ?? [];
        final categoryList =
            data.map((json) => category_model.Category.fromJson(json)).toList();

        categories.value = [
          category_model.Category(
              id: 0, name: 'All', createdDate: '', createdBy: '', products: [])
        ]..addAll(categoryList);

        filteredCategories.assignAll(categories);
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch categories';
      Program.showError('Category fetch error: $e');
    } finally {
      loading(false);
    }
  }

  Future<void> fetchProducts() async {
    try {
      loading(true);
      errorMessage.value = '';
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      final response = await _dio.get(
        '/products',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List? ?? [];
        products.value =
            data.map((json) => product_model.Product.fromJson(json)).toList();
        filteredProducts.assignAll(products);
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch products';
      Program.showError('Product fetch error: $e');
    } finally {
      loading(false);
    }
  }

  void filterProducts() {
    final query = searchQuery.value.toLowerCase();
    var filtered = products.toList();

    if (query.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              (p.description?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    if (selectedCategoryId.value != 0) {
      filtered = filtered
          .where((p) => p.categoryId == selectedCategoryId.value)
          .toList();
    }

    filteredProducts.assignAll(filtered);
  }

  void filterProductsByName(String query) {
    searchQuery.value = query.trim();
    filterProducts();
  }

  void filterProductsByCategory(int categoryId) {
    selectedCategoryId.value = categoryId;
    filterProducts();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filterProducts();
  }

  // --- CART MANAGEMENT ---
// Modify the product key generation
  String _getProductKey(product_model.Product product) {
    // Ensure both id and price are converted to strings
    return '${product.id.toString()}_${product.price.toString()}';
  }

  void addProductToCart(product_model.Product product) async {
    print('=== Adding product to cart ===');
    print(
        'Product: ${product.name}, ID: ${product.id}, Price: ${product.price}');

    try {
      // Add to cart immediately for better UX
      final key = _getProductKey(product);
      if (cartQuantities.containsKey(key)) {
        cartQuantities[key] = (cartQuantities[key] ?? 0) + 1;
      } else {
        cartItems.add(product);
        cartQuantities[key] = 1;
      }
      updateSaleTotals();

      // Create sale if it doesn't exist
      if (currentSale.value == null) {
        await startNewSale();
      }
    } catch (e) {
      print('Error in addProductToCart: $e');
      // The product was already added to cart, so we just show an error
      Program.showError(
          'Added to cart but sale creation failed: ${e.toString()}');
    }
  }

  void addProductToCartSimple(product_model.Product product) {
    print('=== Adding product to cart (Simple) ===');
    print(
        'Product: ${product.name}, ID: ${product.id}, Price: ${product.price}');

    final key = _getProductKey(product);
    print('Product key: $key');

    if (cartQuantities.containsKey(key)) {
      cartQuantities[key] = (cartQuantities[key] ?? 0) + 1;
      print('Updated quantity: ${cartQuantities[key]}');
    } else {
      cartItems.add(product);
      cartQuantities[key] = 1;
      print('Added new item');
    }

    updateSaleTotals();
    print('Subtotal: ${saleSubtotal.value}, Total: ${saleTotal.value}');
  }

// Update removeProductFromCart
  void removeProductFromCart(product_model.Product product) {
    final key = _getProductKey(product);
    final currentQty = cartQuantities[key] ?? 0;

    if (currentQty > 1) {
      cartQuantities[key] = currentQty - 1;
    } else {
      cartQuantities.remove(key);
      cartItems.removeWhere((p) => _getProductKey(p) == key);
    }
    updateSaleTotals();
  }

  void clearCart() {
    cartItems.clear();
    cartQuantities.clear();
    clearDiscount();

    // If there's an active sale with no items, cancel it
    if (currentSale.value != null && cartItems.isEmpty) {
      cancelCurrentSale();
    }

    updateSaleTotals();
  }

  void updateSaleTotals() {
    saleSubtotal.value = cartItems.fold(0.0, (sum, product) {
      final key = _getProductKey(product);
      return sum + (product.price * (cartQuantities[key] ?? 1));
    });

    saleTotal.value = saleSubtotal.value - saleDiscount.value;
    update();
  }

  void updateProductQuantity(product_model.Product product, int newQuantity) {
    final key = getProductKey(product);
    if (newQuantity > 0) {
      cartQuantities[key] = newQuantity;
    } else {
      removeProductFromCartById(product.id, price: product.price);
    }
    updateSaleTotals();
  }

  void updateProductPrice(product_model.Product product, double newPrice) {
    final oldKey = getProductKey(product);
    if (cartQuantities.containsKey(oldKey)) {
      final currentQuantity = cartQuantities[oldKey] ?? 1;
      cartQuantities.remove(oldKey);
      cartItems.removeWhere((p) => getProductKey(p) == oldKey);

      final updatedProduct = product.copyWith(price: newPrice);
      cartItems.add(updatedProduct);
      cartQuantities[getProductKey(updatedProduct)] = currentQuantity;
    }
    updateSaleTotals();
  }

  void removeProductFromCartById(int productId, {double? price}) {
    if (price != null) {
      // Remove specific price variant
      final key = '${productId}_${price.toString()}';
      cartQuantities.remove(key);
      cartItems.removeWhere((p) => p.id == productId && p.price == price);
    } else {
      // Remove all variants (if price not specified)
      final keysToRemove =
          cartQuantities.keys.where((key) => key.startsWith('${productId}_'));
      for (final key in keysToRemove) {
        final price = double.parse(key.split('_')[1]);
        cartItems.removeWhere((p) => p.id == productId && p.price == price);
        cartQuantities.remove(key);
      }
    }
    updateSaleTotals();
  }

  // --- DISCOUNT MANAGEMENT ---
  void applyDiscount(double amount) {
    saleDiscount.value = amount;
    updateSaleTotals();
  }

  void clearDiscount() {
    saleDiscount.value = 0.0;
    updateSaleTotals();
  }

  void applyPercentDiscount(double percent) {
    lastDiscountType.value = 'percent';
    if (percent < 0) percent = 0;
    if (percent > 100) percent = 100;

    final discountAmount = saleSubtotal.value * (percent / 100);
    saleDiscount.value = discountAmount;
    updateSaleTotals();
  }

  void applyAmountDiscount(double amount) {
    lastDiscountType.value = 'amount';
    if (amount < 0) amount = 0;
    saleDiscount.value = amount;
    updateSaleTotals();
  }

  // --- SALE MANAGEMENT ---
  void setTable(String table) {
    selectedTable.value = table;
  }

  Future<void> startNewSale() async {
    print('=== Starting new sale ===');

    try {
      loading(true);
      final token = _storage.read('token');
      final user = _storage.read('user');

      if (token == null) throw Exception('No authentication token found');
      if (user == null || user['id'] == null)
        throw Exception('User data not found');

      final response = await _dio.post(
        '/sales',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'content-type': 'application/json'
          },
        ),
        data: {
          'status': 'pending',
          'table': selectedTable.value,
          'sub_total': 0.0,
          'discount': 0.0,
          'grand_total': 0.0,
          'sale_date': DateTime.now().toIso8601String(),
          'is_paid': false,
          'created_by': user['id'],
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          currentSale.value =
              sale_model.Sale.fromJson(responseData['data'] ?? responseData);
          print('Sale created with ID: ${currentSale.value!.id}');
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to create sale: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in startNewSale: $e');
      Program.showError('Failed to create sale: ${e.toString()}');
      rethrow;
    } finally {
      loading(false);
    }
  }

  Future<void> completeCurrentSale() async {
    if (currentSale.value == null) {
      Program.showError('No active sale to complete');
      return;
    }

    if (cartItems.isEmpty) {
      Program.showError('Cannot complete sale with empty cart');
      return;
    }

    try {
      loading(true);

      // First save all sale products
      await _saveSaleItems(currentSale.value!.id);

      // Then update the sale status and totals
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      final response = await _dio.put(
        '/sales/${currentSale.value!.id}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'status': 'completed',
          'sub_total': saleSubtotal.value,
          'discount': saleDiscount.value,
          'grand_total': saleTotal.value,
          'is_paid': true,
          'sale_date': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        Program.success("Payment Successful", "Sale completed successfully!");
        _clearCurrentSale();
        clearCart();
      }
    } catch (e) {
      Program.showError('Payment failed: ${e.toString()}');
      print('Payment error: $e');
    } finally {
      loading(false);
    }
  }

  Future<void> _saveSaleItems(int saleId) async {
    try {
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      // Prepare items
      final items = cartItems.map((product) {
        final key = _getProductKey(product);
        final quantity = cartQuantities[key] ?? 1;
        return {
          'product_id': product.id,
          'quantity': quantity,
          'price': product.price,
          'is_free': product.price == 0.0,
        };
      }).toList();

      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Make bulk API call
      final response = await _dio.post(
        '/sale-products/bulk',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
        data: {
          'sale_id': saleId,
          'items': items,
        },
      );

      // Close loading
      Get.back();

      if (response.statusCode != 201) {
        throw Exception('Failed to save sale items');
      }
    } catch (e) {
      Get.back(); // Close any open dialogs
      String errorMessage = 'Failed to save sale items';

      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          errorMessage = 'Endpoint not found. Please check API configuration.';
        } else {
          errorMessage = e.response?.data?['message'] ?? e.message;
        }
      }

      Program.showError(errorMessage);
      rethrow;
    }
  }

  Future<void> cancelCurrentSale() async {
    if (currentSale.value == null) return;

    try {
      loading(true);
      final token = _storage.read('token');
      if (token != null) {
        await _dio.put(
          '/sales/${currentSale.value!.id}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {'status': 'cancelled'},
        );
      }
      _clearCurrentSale();
      clearCart();
      Program.success("Sale Cancelled", "Current sale has been cancelled");
    } catch (e) {
      Program.showError('Failed to cancel sale: $e');
    } finally {
      loading(false);
    }
  }

  void _clearCurrentSale() {
    currentSale.value = null;
    _resetSaleTotals();
  }

  void _resetSaleTotals() {
    saleSubtotal.value = 0.0;
    // saleTax.value = 0.0;
    saleDiscount.value = 0.0;
    saleTotal.value = 0.0;
  }

  void onPayPressed() async {
    print('=== Pay button pressed ===');

    if (cartItems.isEmpty) {
      Program.showError('No items in cart');
      return;
    }

    if (saleTotal.value <= 0) {
      Program.showError('Invalid total amount');
      return;
    }

    try {
      // Create sale if it doesn't exist
      if (currentSale.value == null) {
        print('Creating sale for payment...');
        await startNewSale();
      }

      // Show confirmation dialog
      Get.dialog(
        AlertDialog(
          title: const Text('Confirm Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subtotal: ${formattedSubtotal}'),
              if (saleDiscount.value > 0)
                Text('Discount: ${formattedDiscount}',
                    style: const TextStyle(color: Colors.red)),
              const Divider(),
              Text('Total: ${formattedTotal}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                completeCurrentSale();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Confirm Payment',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error in onPayPressed: $e');
      Program.showError('Failed to process payment: ${e.toString()}');
    }
  }

  void _configureDio() {
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('=== API Request ===');
        print('URL: ${options.baseUrl}${options.path}');
        print('Method: ${options.method}');
        print('Data: ${options.data}');
        print('Headers: ${options.headers}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('=== API Response ===');
        print('Status: ${response.statusCode}');
        print('Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('=== API Error ===');
        print('Type: ${error.type}');
        print('Message: ${error.message}');
        print('Response: ${error.response?.data}');
        print('Status Code: ${error.response?.statusCode}');

        final statusCode = error.response?.statusCode;
        String message;

        switch (statusCode) {
          case 401:
            message = 'Authentication failed. Please login again.';
            break;
          case 403:
            message = 'Access denied';
            break;
          case 404:
            message = 'Resource not found';
            break;
          case 422:
            message = 'Validation error: ${error.response?.data}';
            break;
          case 500:
            message = 'Server error: ${error.response?.data}';
            break;
          default:
            message = 'Network error: ${error.message}';
        }

        errorMessage.value = message;
        // Only show error for critical operations, not for adding to cart
        if (error.requestOptions.path != '/sales') {
          Program.showError(message);
        }
        handler.next(error);
      },
    ));
  }

  // --- GETTERS for UI display ---
  bool get hasPendingSale => currentSale.value != null;

  String get formattedSubtotal => '\$${saleSubtotal.value.toStringAsFixed(2)}';
  // String get formattedTax => '\$${saleTax.value.toStringAsFixed(2)}';
  String get formattedDiscount => '-\$${saleDiscount.value.toStringAsFixed(2)}';
  String get formattedTotal => '\$${saleTotal.value.toStringAsFixed(2)}';
}
