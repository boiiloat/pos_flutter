import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:pos_system/program.dart';
import '../../models/api/category_model.dart' as category_model;
import '../../models/api/product_model.dart' as product_model;
import '../../models/api/sale_model.dart' as sale_model;

class SaleController extends GetxController {
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

  void _configureDio() {
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessage(statusCode);
        errorMessage.value = message;
        Program.showError(message);
        handler.next(error);
      },
    ));
  }

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

// Update addProductToCart with type safety
  void addProductToCart(product_model.Product product) {
    final key = _getProductKey(product);
    if (cartQuantities.containsKey(key)) {
      cartQuantities[key] = (cartQuantities[key] ?? 0) + 1;
    } else {
      cartItems.add(product);
      cartQuantities[key] = 1;
    }
    updateSaleTotals();
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
    clearDiscount(); // This will also clear any applied discount
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
    try {
      loading(true);
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      final response = await _dio.post(
        '/sales',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'status': 'pending',
          'table': selectedTable.value,
        },
      );

      if (response.statusCode == 201) {
        currentSale.value = sale_model.Sale.fromJson(response.data['data']);
        _resetSaleTotals();
        clearCart();
        Program.success("Sale Started", "New sale created successfully");
      }
    } catch (e) {
      Program.showError('Failed to start new sale: $e');
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

    try {
      loading(true);
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      await _dio.put(
        '/sales/${currentSale.value!.id}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'status': 'completed',
          'sub_total': saleSubtotal.value,
          // 'tax': saleTax.value,
          'discount': saleDiscount.value,
          'grand_total': saleTotal.value,
          'completed_at': DateTime.now().toIso8601String(),
        },
      );

      await _saveSaleItems(currentSale.value!.id);

      Program.success("Sale Completed", "Transaction completed successfully");
      _clearCurrentSale();
      clearCart();
    } catch (e) {
      Program.showError('Failed to complete sale: $e');
    } finally {
      loading(false);
    }
  }

  Future<void> _saveSaleItems(int saleId) async {
    try {
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      final items = cartItems.map((product) {
        final key = _getProductKey(product);
        return {
          'sale_id': saleId,
          'product_id': product.id,
          'quantity': cartQuantities[key] ?? 1,
          'unit_price': product.price,
          'total_price': product.price * (cartQuantities[key] ?? 1),
        };
      }).toList();

      await _dio.post(
        '/sale-items',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'items': items},
      );
    } catch (e) {
      Program.showError('Failed to save sale items: $e');
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

  void onPayPressed() {
    if (saleTotal.value <= 0) {
      Program.showError('No items in cart');
      return;
    }
    completeCurrentSale();
  }

  // --- GETTERS for UI display ---
  bool get hasPendingSale => currentSale.value != null;

  String get formattedSubtotal => '\$${saleSubtotal.value.toStringAsFixed(2)}';
  // String get formattedTax => '\$${saleTax.value.toStringAsFixed(2)}';
  String get formattedDiscount => '-\$${saleDiscount.value.toStringAsFixed(2)}';
  String get formattedTotal => '\$${saleTotal.value.toStringAsFixed(2)}';
}
