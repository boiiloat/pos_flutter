import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/receipt/web_receipt_screen.dart';
import '../../models/api/category_model.dart' as category_model;
import '../../models/api/product_model.dart' as product_model;
import '../../models/api/sale_model.dart' as sale_model;
import '../models/api/payment_method_model.dart';
import '../models/api/sale_model.dart';
import 'table_controller.dart';

class SaleController extends GetxController {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final searchController = TextEditingController();
  final TableController tableController = Get.put(TableController());
  var exchangeRate = 4000.0.obs; // Based on your image showing 4,000 Rials
  var dollarPayment = 0.0.obs;
  var rialsPayment = 0.0.obs;
  var remainingAmount = 0.0.obs;

  var currentTableId = 0.obs;
  var currentTableName = 'No Table Selected'.obs;

  // Add these to your SaleControllerx
  var paymentMethods = <PaymentMethod>[].obs;
  var selectedPaymentMethod = Rxn<PaymentMethod>();
  var paymentAmountController = TextEditingController();
  var exchangeRateController = TextEditingController(text: '1.0');
  var receiptProducts = <Map<String, dynamic>>[].obs;
  var receiptSaleData = Rxn<Map<String, dynamic>>();
  bool get hasActiveSale {
    return currentSale.value != null || cartItems.isNotEmpty;
  }

  void preserveSaleState() {
    print('💾 Preserving sale state for navigation...');
    // This method intentionally does nothing - just preserves the current state
    // The sale data remains in the controller for when we return
  }

  void resetSaleState() {
    print('🔄 Resetting sale state (manual reset)...');
    safeClearAllData();
  }

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
  var selectedTableId = 0.obs;

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

    if (Get.isRegistered<TableController>()) {
      final tableController = Get.put(TableController());
      if (tableController.selectedTableId.value > 0) {
        setCurrentTable(tableController.selectedTableId.value,
            tableController.selectedTableName.value);
      }
    }

    // Also check navigation arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['table_id'] != null) {
        setCurrentTable(args['table_id'] as int,
            args['table_name'] as String? ?? 'Table ${args['table_id']}');
      }
    }
    _initializeData();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
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
    fetchPaymentMethods();
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

    try {
      // Validate table selection
      if (!_validateTableSelection()) {
        throw Exception('Please select a table before adding products');
      }

      print('✅ Table validation passed - Using table ${currentTableId.value}');

      // Check/Create sale
      if (currentSale.value == null) {
        await checkExistingSaleForTable(currentTableId.value);

        if (currentSale.value == null) {
          print('🆕 Starting new sale for table ${currentTableId.value}');
          await startNewSale();
        } else {
          print('🔄 Using existing sale: ${currentSale.value!.id}');
        }
      }

      // Rest of your existing cart logic...
      final key = _getProductKey(product);
      if (cartQuantities.containsKey(key)) {
        cartQuantities[key] = (cartQuantities[key] ?? 0) + 1;
      } else {
        cartItems.add(product);
        cartQuantities[key] = 1;
      }

      updateSaleTotals();
    } catch (e) {
      // Your existing error handling...
    }
  }

  bool _validateTableSelection() {
    // Check current table selection
    if (currentTableId.value > 0) {
      return true;
    }

    // Try to get from TableController
    if (Get.isRegistered<TableController>()) {
      final tableController = Get.put(TableController());
      if (tableController.selectedTableId.value > 0) {
        print('📋 Using table from TableController');
        setCurrentTable(tableController.selectedTableId.value,
            tableController.selectedTableName.value);
        return true;
      }
    }

    // Try to get from navigation arguments
    final args = Get.arguments;
    if (args != null && args is Map && args['table_id'] != null) {
      print('📋 Using table from navigation arguments');
      setCurrentTable(args['table_id'] as int,
          args['table_name'] as String? ?? 'Table ${args['table_id']}');
      return true;
    }

    return false;
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
    print('Table ID for sale: ${currentTableId.value}');

    // Don't create a new sale if one already exists for this table
    if (currentSale.value != null &&
        currentSale.value!.tableId == currentTableId.value) {
      print('⚠️ Sale already exists for this table, reusing...');
      return;
    }

    try {
      loading(true);
      final token = _storage.read('token');
      final user = _storage.read('user');

      if (currentTableId.value <= 0) {
        throw Exception('Invalid table selection');
      }

      final saleData = {
        'status': 'pending',
        'table_id': currentTableId.value,
        'sub_total': 0.0,
        'discount': 0.0,
        'grand_total': 0.0,
        'sale_date': DateTime.now().toIso8601String(),
        'is_paid': false,
        'created_by': user['id'],
      };

      print('📤 Creating sale with data: $saleData');

      final response = await _dio.post(
        '/sales',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        ),
        data: saleData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        print('📥 Sale creation response: $responseData');

        if (responseData is Map<String, dynamic>) {
          currentSale.value =
              sale_model.Sale.fromJson(responseData['data'] ?? responseData);
          print(
              '✅ Sale created with ID: ${currentSale.value!.id} for table ${currentTableId.value}');
        }
      } else {
        throw Exception('Failed to create sale: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in startNewSale: $e');
      if (e is DioException) {
        print('DioException details: ${e.response?.data}');
      }
      Program.showError('Failed to create sale: ${e.toString()}');
      rethrow;
    } finally {
      loading(false);
    }
  }

// Update the completeCurrentSale method to preserve data
  Future<void> completeCurrentSale() async {
    try {
      // Convert payment amount safely
      final paymentAmount =
          double.tryParse(paymentAmountController.text) ?? saleTotal.value;
      final exchangeRateValue =
          double.tryParse(exchangeRateController.text) ?? 1.0;

      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      print('💰 Starting sale completion process...');

      // 1. Prepare receipt data FIRST (before any API calls)
      prepareReceiptData();
      print('✅ Receipt data prepared successfully');

      // 2. Save sale items (try API, but don't fail completely)
      bool itemsSaved = false;
      try {
        if (currentSale.value != null) {
          await _saveSaleItems(currentSale.value!.id);
          itemsSaved = true;
          print('✅ Sale items saved to API');
        }
      } catch (e) {
        print('⚠️ Sale items API save failed: $e');
        // CONTINUE - we have offline data
      }

      // 3. Update sale status (optional)
      try {
        if (currentSale.value != null && itemsSaved) {
          final updateData = {
            'status': 'completed',
            'sub_total': saleSubtotal.value,
            'discount': saleDiscount.value,
            'grand_total': saleTotal.value,
            'is_paid': true,
          };

          final token = _storage.read('token');
          await _dio.patch(
            '/sales/${currentSale.value!.id}',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              },
            ),
            data: updateData,
          );
          print('✅ Sale status updated in API');
        }
      } catch (saleError) {
        print('⚠️ Sale status update failed: $saleError');
      }

      // 4. Create payment record (optional)
      try {
        if (currentSale.value != null && itemsSaved) {
          final paymentData = {
            'payment_amount': paymentAmount,
            'exchange_rate': exchangeRateValue,
            'payment_method_name':
                selectedPaymentMethod.value!.paymentMethodName,
            'sale_id': currentSale.value!.id,
            'payment_method_id': selectedPaymentMethod.value!.id,
            'created_day': DateTime.now().toIso8601String(),
            'created_by': _storage.read('user')?['id']?.toString(),
          };

          await _dio.post(
            '/sale-payments',
            options: Options(
                headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
            data: paymentData,
          );
          print('✅ Payment record created in API');
        }
      } catch (paymentError) {
        print('⚠️ Payment record creation failed: $paymentError');
      }

      // 5. Close loading dialog
      Get.back();

      // 6. Navigate to receipt - data is preserved in receiptSaleData
      print('🎯 Navigating to receipt screen with preserved data...');
      Get.offAllNamed('/web_receipt_screen');
    } catch (e) {
      print('❌ Critical error in completeCurrentSale: $e');

      // Close loading dialog
      if (Get.isDialogOpen!) Get.back();

      Program.showError('Payment completed with minor issues: ${e.toString()}');

      // Still navigate to receipt with preserved data
      Get.offAllNamed('/web_receipt_screen');
    }
  }

// Add these methods to your SaleController

  void clearDataAfterReceipt() {
    print('🧹 Clearing sale data after receipt viewed');

    // Clear cart data
    cartItems.clear();
    cartQuantities.clear();

    // Reset sale totals
    saleSubtotal.value = 0.0;
    saleDiscount.value = 0.0;
    saleTotal.value = 0.0;

    // Reset payment fields
    paymentAmountController.clear();
    exchangeRateController.text = '1.0';
    dollarPayment.value = 0.0;
    rialsPayment.value = 0.0;
    remainingAmount.value = 0.0;

    // Reset table selection
    currentTableId.value = 0;
    currentTableName.value = 'No Table Selected';
    selectedTableId.value = 0;

    // DON'T clear currentSale here - let it be cleared by finalizeSale
    print('✅ Sale data cleared successfully');
  }

  void finalizeCurrentSale() {
    print('🎫 Finalizing sale - clearing current sale');
    // Only clear the current sale, other data is already cleared
    currentSale.value = null;
  }

// Call this when leaving receipt screen
  void finalizeSale() {
    print('🎫 Finalizing sale - clearing all data');
    currentSale.value = null;
    clearDataAfterReceipt();
  }

  void clearAllSaleDataFull() {
    print('🧹 Clearing ALL sale data');

    // Clear everything at once
    currentSale.value = null;
    cartItems.clear();
    cartQuantities.clear();
    saleSubtotal.value = 0.0;
    saleDiscount.value = 0.0;
    saleTotal.value = 0.0;
    paymentAmountController.clear();
    exchangeRateController.text = '1.0';
    dollarPayment.value = 0.0;
    rialsPayment.value = 0.0;
    remainingAmount.value = 0.0;
    currentTableId.value = 0;
    currentTableName.value = 'No Table Selected';
    selectedTableId.value = 0;

    print('✅ All sale data cleared successfully');
  }

// In SaleController - Make sure safeClearAllData clears everything
  void safeClearAllData() {
    print('🧹 SAFE Clearing all sale data...');

    try {
      // Clear reactive variables first
      saleSubtotal.value = 0.0;
      saleDiscount.value = 0.0;
      saleTotal.value = 0.0;
      dollarPayment.value = 0.0;
      rialsPayment.value = 0.0;
      remainingAmount.value = 0.0;
      currentTableId.value = 0;
      currentTableName.value = 'No Table Selected';
      selectedTableId.value = 0;

      // Clear non-reactive data
      cartItems.clear();
      cartQuantities.clear();
      receiptProducts.clear();
      receiptSaleData.value = null;

      // Clear controllers
      paymentAmountController.clear();
      exchangeRateController.text = '1.0';
      searchController.clear();

      // Clear current sale
      currentSale.value = null;

      print('✅ All sale data cleared safely - Ready for fresh start');
    } catch (e) {
      print('⚠️ Error during data clearing: $e');
      // Even if there's an error, try to clear the most important data
      cartItems.clear();
      cartQuantities.clear();
      currentSale.value = null;
      receiptSaleData.value = null;
    }
  }

  // In SaleController, update the safeClearSaleDataOnly method:
  void safeClearSaleDataOnly() {
    print('🧹 SAFE Clearing only sale-related data (preserving sale state)...');

    try {
      // Clear only cart data and totals, but keep the sale active
      saleSubtotal.value = 0.0;
      saleDiscount.value = 0.0;
      saleTotal.value = 0.0;
      dollarPayment.value = 0.0;
      rialsPayment.value = 0.0;
      remainingAmount.value = 0.0;

      // Clear cart data
      cartItems.clear();
      cartQuantities.clear();

      // Clear payment controllers
      paymentAmountController.clear();
      exchangeRateController.text = '1.0';
      searchController.clear();

      // DO NOT clear currentSale - keep the sale active
      // currentSale.value = null;

      print('✅ Cart cleared but sale remains active');
    } catch (e) {
      print('⚠️ Error during sale data clearing: $e');
      cartItems.clear();
      cartQuantities.clear();
      // Still don't clear currentSale
    }
  }

  void clearAllSaleData() {
    print('🧹 Clearing ALL sale data (but keeping table info)...');

    try {
      // Clear sale data but preserve table selection
      currentSale.value = null;
      cartItems.clear();
      cartQuantities.clear();
      saleSubtotal.value = 0.0;
      saleDiscount.value = 0.0;
      saleTotal.value = 0.0;
      paymentAmountController.clear();
      exchangeRateController.text = '1.0';
      dollarPayment.value = 0.0;
      rialsPayment.value = 0.0;
      remainingAmount.value = 0.0;

      // DO NOT clear these - they should persist
      // currentTableId.value
      // currentTableName.value
      // selectedTableId.value

      print(
          '✅ All sale data cleared - Table preserved: ${currentTableName.value}');
    } catch (e) {
      print('❌ Error clearing sale data: $e');
    }
  }

  Future<void> _closeAllDialogsSafely() async {
    try {
      if (Get.isDialogOpen == true) {
        Get.back();
        // Small delay to ensure dialog is fully closed
        await Future.delayed(Duration(milliseconds: 100));
      }

      // Also check for any open snackbars and close them
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
    } catch (e) {
      print('⚠️ Error closing dialogs: $e');
      // Ignore errors when closing dialogs
    }
  }

  Future<void> checkExistingSaleForTable(int tableId) async {
    try {
      final token = _storage.read('token');
      if (token == null) return;

      final response = await _dio.get(
        '/sales?table_id=$tableId&status=pending',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List? ?? [];
        if (data.isNotEmpty) {
          // Use existing pending sale
          currentSale.value = sale_model.Sale.fromJson(data.first);
          print('🔄 Using existing sale: ${currentSale.value!.id}');

          // Load existing sale items
          await _loadSaleItems(currentSale.value!.id);
        }
      }
    } catch (e) {
      print('Error checking existing sales: $e');
    }
  }

  Future<void> _loadSaleItems(int saleId) async {
    try {
      final token = _storage.read('token');
      final response = await _dio.get(
        '/sale-products?$saleId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final items = response.data['data'] as List? ?? [];

        // Clear current cart
        cartItems.clear();
        cartQuantities.clear();

        // Load items into cart
        for (final item in items) {
          final productId = item['product_id'];
          final product = products.firstWhere(
            (p) => p.id == productId,
            orElse: () => throw Exception('Product $productId not found'),
          );

          final quantity = item['quantity'] ?? 1;
          final price = item['price'] ?? product.price;

          // Add to cart
          final updatedProduct = product.copyWith(price: price.toDouble());
          final key = _getProductKey(updatedProduct);

          cartItems.add(updatedProduct);
          cartQuantities[key] = quantity;
        }

        updateSaleTotals();
        print('🔄 Loaded ${items.length} items from existing sale');
      }
    } catch (e) {
      print('Error loading sale items: $e');
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

      print('📦 Saving ${items.length} items to sale $saleId');

      // Make bulk API call with timeout
      final response = await _dio.post(
        '/sale-products/bulk',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
        data: {
          'sale_id': saleId,
          'items': items,
        },
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save sale items: ${response.statusCode}');
      }

      print('✅ Sale items saved successfully');
    } catch (e) {
      String errorMessage = 'Failed to save sale items: $e';
      print('❌ Error saving sale items: $errorMessage');
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
          data: {'status': 'completed'},
        );
      }
      _clearCurrentSale();
      clearCart();
      Program.success("Sale Completed", "Current sale has been completed");
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
    debugPrint('Cart items: ${cartItems.length}');
    debugPrint('Sale total: ${saleTotal.value}');
    debugPrint('Current sale: ${currentSale.value?.id}');

    try {
      showPaymentDialog();
    } catch (e) {
      debugPrint('Error showing payment dialog: $e');
      Program.showError('Failed to start payment: ${e.toString()}');
    }
  }

  void _configureDio() {
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.sendTimeout = const Duration(seconds: 15);

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

        // Don't automatically show errors for network issues
        // Let individual methods handle them
        handler.next(error);
      },
    ));
  }

  Future<void> fetchPaymentMethods() async {
    try {
      loading(true);
      final token = _storage.read('token');
      if (token == null) throw Exception('No authentication token found');

      final response = await _dio.get(
        '/payment-methods',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data as List? ?? [];
        paymentMethods
            .assignAll(data.map((json) => PaymentMethod.fromJson(json)));

        // Auto-select the first payment method if none is selected
        if (selectedPaymentMethod.value == null && paymentMethods.isNotEmpty) {
          selectedPaymentMethod.value = paymentMethods.first;
        }
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch payment methods';
      Program.showError('Payment method fetch error: $e');
    } finally {
      loading(false);
    }
  }

// In your SaleController class
  void showPaymentDialog() {
    // Initialize payment values
    paymentAmountController.text = saleTotal.value.toStringAsFixed(2);
    dollarPayment.value = saleTotal.value;
    rialsPayment.value = saleTotal.value * exchangeRate.value;
    remainingAmount.value = 0.0;

    // Ensure selected payment method exists in available methods
    if (selectedPaymentMethod.value == null ||
        !paymentMethods.any((m) => m.id == selectedPaymentMethod.value?.id)) {
      if (paymentMethods.isNotEmpty) {
        selectedPaymentMethod.value = paymentMethods.first;
      }
    }

    Get.dialog(
      AlertDialog(
        title: const Center(child: Text('Payment')),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('TOTAL:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Obx(() => Text(
                      '\$${saleTotal.value.toStringAsFixed(2)} R ${formatRielAmount(saleTotal.value * exchangeRate.value)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                const SizedBox(height: 20),

                // Payment method dropdown - Fixed version
                Obx(() {
                  // Find the selected method in available methods
                  final selected = paymentMethods.firstWhereOrNull(
                      (method) => method.id == selectedPaymentMethod.value?.id);

                  return DropdownButtonFormField<PaymentMethod>(
                    value: selected,
                    items: paymentMethods.map((method) {
                      return DropdownMenuItem<PaymentMethod>(
                        value: method,
                        child: Text(method.paymentMethodName),
                      );
                    }).toList(),
                    onChanged: (PaymentMethod? method) {
                      if (method != null) {
                        selectedPaymentMethod.value = method;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select a payment method' : null,
                  );
                }),
                const SizedBox(height: 20),

                // Dollar payment input
                TextField(
                  controller: paymentAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Dollar Pay:',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final dollars = double.tryParse(value) ?? 0;
                    updateDollarPayment(dollars);
                  },
                ),
                const SizedBox(height: 10),

                // Riels payment input
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Riels Pay:',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final rials = double.tryParse(value) ?? 0;
                    updateRialsPayment(rials);
                  },
                ),
                const SizedBox(height: 10),

                // Remaining amount
                Obx(() => Text(
                      'Remaining: \$${remainingAmount.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: remainingAmount.value > 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 45),
            ),
            onPressed: () async {
              if (selectedPaymentMethod.value == null) {
                Program.showError('Please select a payment method');
                return;
              }

              if (remainingAmount.value > 0) {
                Program.showError('Please pay the full amount');
                return;
              }

              // Close payment dialog first safely
              Get.back();

              // Show loading indicator
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              try {
                await completeCurrentSale();
                // completeCurrentSale now handles navigation and keeps data
              } catch (e) {
                Get.back();
                Program.showError(
                    'Payment completed with minor issues: ${e.toString()}');
                // Still navigate to receipt with available data
                Get.offAllNamed('/web_receipt_screen');
              }
            },
            child: const Text('PAY & PRINT'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

// Currency conversion methods
  void updateDollarPayment(double dollars) {
    dollarPayment.value = dollars;
    rialsPayment.value = dollars * exchangeRate.value;
    remainingAmount.value = saleTotal.value - dollars;
    paymentAmountController.text =
        dollars.toStringAsFixed(2); // Ensure proper format
    update();
  }

  void updateRialsPayment(double rials) {
    rialsPayment.value = rials;
    dollarPayment.value = rials / exchangeRate.value;
    remainingAmount.value = saleTotal.value - dollarPayment.value;
    paymentAmountController.text =
        dollarPayment.value.toStringAsFixed(2); // Ensure proper format
    update();
  }

  Future<void> loadExistingSale(int saleId) async {
    try {
      final response = await _dio.get('/sales/$saleId');
      final sale = Sale.fromJson(response.data['data']);

      if (sale.tableId != null) {
        print('📊 Loaded sale ${sale.id} for table ${sale.tableId}');
        // Set the table context
        final tableController = Get.put(TableController());
        tableController.selectedTableId.value = sale.tableId!;
        tableController.selectedTableName.value = 'Table ${sale.tableId}';
        selectedTable.value = 'Table ${sale.tableId}';
      }

      currentSale.value = sale;
    } catch (e) {
      // Handle error
    }
  }

  void setCurrentTable(int tableId, String tableName) async {
    print(
        '🏁 SaleController.setCurrentTable called - ID: $tableId, Name: $tableName');

    currentTableId.value = tableId;
    currentTableName.value = tableName;
    selectedTableId.value = tableId;

    // Check for existing pending sale for this table
    await checkExistingSaleForTable(tableId);

    print(
        '✅ Table set in SaleController - currentTableId: ${currentTableId.value}');
    update();
  }

  void addProductToCartById(int productId, {int quantity = 1}) {
    final product = products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    for (int i = 0; i < quantity; i++) {
      addProductToCart(product);
    }
  }

  void clearSaleData() {
    cartItems.clear();
    cartQuantities.clear();
    currentSale.value = null;
    saleSubtotal.value = 0.0;
    saleDiscount.value = 0.0;
    saleTotal.value = 0.0;
    // Reset any other sale-related state
  }

// Add this method to preserve sale data for receipt
  void prepareReceiptData() {
    print('📋 Preparing receipt data...');

    // Convert cart items to receipt format
    receiptProducts.clear();

    for (var product in cartItems) {
      final key = _getProductKey(product);
      final quantity = cartQuantities[key] ?? 1;

      receiptProducts.add({
        'product_id': product.id,
        'product_name': product.name,
        'price': product.price,
        'quantity': quantity,
        'amount': product.price * quantity,
      });
    }

    // Store complete sale data for receipt
    receiptSaleData.value = {
      'id': currentSale.value?.id,
      'invoice_number': currentSale.value?.invoiceNumber ??
          'OFFLINE-${DateTime.now().millisecondsSinceEpoch}',
      'sale_date': currentSale.value?.saleDate ?? DateTime.now(),
      'table_id': currentTableId.value,
      'table_name': currentTableName.value,
      'sub_total': saleSubtotal.value,
      'discount': saleDiscount.value,
      'grand_total': saleTotal.value,
      'is_paid': true,
      'status': 'completed',
      'payment_method':
          selectedPaymentMethod.value?.paymentMethodName ?? 'Unknown',
      'products': receiptProducts.toList(),
    };

    print('✅ Receipt data prepared with ${receiptProducts.length} products');
  }

  String formatRielAmount(double amount) {
    int intAmount = amount.toInt();

    // Round to nearest hundred (419960 -> 420000)
    int roundedAmount = ((intAmount / 100).round() * 100).toInt();

    // Add comma formatting
    return _formatNumberWithCommas(roundedAmount);
  }

  String _formatNumberWithCommas(int number) {
    String numberStr = number.toString();
    String result = '';
    int count = 0;

    for (int i = numberStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result = ',$result';
      }
      result = numberStr[i] + result;
      count++;
    }

    return result;
  }

  // --- GETTERS for UI display ---
  bool get hasPendingSale => currentSale.value != null;

  String get formattedSubtotal => '\$${saleSubtotal.value.toStringAsFixed(2)}';
  // String get formattedTax => '\$${saleTax.value.toStringAsFixed(2)}';
  String get formattedDiscount => '-\$${saleDiscount.value.toStringAsFixed(2)}';
  String get formattedTotal => '\$${saleTotal.value.toStringAsFixed(2)}';
}
