import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../controller/sale_controller.dart';
import '../../controller/table_controller.dart';
import '../../controller/user_controller.dart';
import '../../models/api/sale_model.dart' as sale_model;

class WebReceiptScreen extends StatelessWidget {
  final SaleController saleController = Get.find();
  final UserController userController = Get.find();
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  bool _isNavigating = false;

  // Helper method to format invoice number (extract only first part)
  String _formatInvoiceNumber(String invoiceNumber) {
    if (invoiceNumber.isEmpty) return 'OFFLINE';

    // Split by dash and take only the first two parts
    final parts = invoiceNumber.split('-');
    if (parts.length >= 3) {
      // Return format: INV-20250930
      return '${parts[0]}-${parts[1]}';
    }

    // If format doesn't match, return original
    return invoiceNumber;
  }

  @override
  Widget build(BuildContext context) {
    final receiptData = saleController.receiptSaleData.value;
    final currentSale = saleController.currentSale.value;

    if (receiptData != null) {
      return _buildReceiptFromPreservedData(receiptData);
    } else if (currentSale != null) {
      return _buildReceiptFromSale(currentSale);
    } else {
      return _buildReceiptFromCartData();
    }
  }

  String _getCurrentUserFullName() {
    try {
      final GetStorage storage = GetStorage();
      final userData = storage.read('user');

      if (userData != null && userData is Map) {
        final fullname = userData['fullname']?.toString();
        if (fullname != null && fullname.isNotEmpty) {
          return fullname;
        }
      }

      final currentUser = userController.users
          .firstWhereOrNull((user) => user.id == (userData?['id'] ?? 0));
      if (currentUser != null) {
        return currentUser.fullname;
      }

      return 'Cashier';
    } catch (e) {
      print('Error getting user full name: $e');
      return 'Cashier';
    }
  }

  Widget _buildReceiptFromPreservedData(Map<String, dynamic> receiptData) {
    final products = receiptData['products'] as List<dynamic>? ?? [];
    final originalInvoiceNumber =
        receiptData['invoice_number'] as String? ?? 'OFFLINE';
    final invoiceNumber = _formatInvoiceNumber(originalInvoiceNumber);
    final saleDate = receiptData['sale_date'] is DateTime
        ? receiptData['sale_date'] as DateTime
        : DateTime.now();
    final tableName = receiptData['table_name'] as String? ?? 'No Table';
    final subTotal = receiptData['sub_total'] as double? ?? 0.0;
    final discount = receiptData['discount'] as double? ?? 0.0;
    final grandTotal = receiptData['grand_total'] as double? ?? 0.0;
    final paymentMethod = receiptData['payment_method'] as String? ?? 'Unknown';
    final currentUserFullName = _getCurrentUserFullName();

    return WillPopScope(
      onWillPop: () async {
        _navigateBackToTableScreen();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1000),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildWebHeaderWithLogo(
                    tableName: tableName,
                    casherName: currentUserFullName,
                    invoiceNumber: invoiceNumber,
                    saleDate: saleDate,
                  ),
                  const SizedBox(height: 16),
                  _buildProductsTable(products),
                  const SizedBox(height: 16),
                  _buildTotalsSection(
                      subTotal, discount, grandTotal, paymentMethod),
                  const SizedBox(height: 32),
                  _buildWebActionButtons(
                    invoiceNumber: invoiceNumber,
                    saleDate: saleDate,
                    tableName: tableName,
                    casherName: currentUserFullName,
                    products: products,
                    subTotal: subTotal,
                    discount: discount,
                    grandTotal: grandTotal,
                    paymentMethod: paymentMethod,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptFromSale(sale_model.Sale sale) {
    final products = sale.products ?? [];
    final originalInvoiceNumber = sale.invoiceNumber ?? 'N/A';
    final invoiceNumber = _formatInvoiceNumber(originalInvoiceNumber);
    final currentUserFullName = _getCurrentUserFullName();

    return _buildWebLayout(
      invoiceNumber: invoiceNumber,
      saleDate: sale.saleDate ?? DateTime.now(),
      tableName: saleController.currentTableName.value,
      products: products,
      subTotal: sale.subTotal,
      discount: sale.discount ?? 0.0,
      grandTotal: sale.grandTotal,
      paymentMethod:
          saleController.selectedPaymentMethod.value?.paymentMethodName ??
              'Unknown',
      isPaid: sale.isPaid == true,
      casherName: currentUserFullName,
    );
  }

  Widget _buildReceiptFromCartData() {
    final cartItems = saleController.cartItems;
    final cartQuantities = saleController.cartQuantities;

    if (cartItems.isEmpty) {
      return _buildErrorScreen('No sale data available');
    }

    final products = cartItems.map((product) {
      final key = '${product.id}_${product.price}';
      final quantity = cartQuantities[key] ?? 1;
      return {
        'product_name': product.name,
        'price': product.price,
        'quantity': quantity,
      };
    }).toList();

    final currentUserFullName = _getCurrentUserFullName();
    final invoiceNumber = _formatInvoiceNumber('OFFLINE-CART');

    return _buildWebLayout(
      invoiceNumber: invoiceNumber,
      saleDate: DateTime.now(),
      tableName: saleController.currentTableName.value,
      products: products,
      subTotal: saleController.saleSubtotal.value,
      discount: saleController.saleDiscount.value,
      grandTotal: saleController.saleTotal.value,
      paymentMethod:
          saleController.selectedPaymentMethod.value?.paymentMethodName ??
              'Unknown',
      isPaid: true,
      isOffline: true,
      casherName: currentUserFullName,
    );
  }

  Widget _buildWebLayout({
    required String invoiceNumber,
    required DateTime saleDate,
    required String tableName,
    required List<dynamic> products,
    required double subTotal,
    required double discount,
    required double grandTotal,
    required String paymentMethod,
    required bool isPaid,
    bool isOffline = false,
    required String casherName,
  }) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBackToTableScreen();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1000),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildWebHeaderWithLogo(
                    isOffline: isOffline,
                    tableName: tableName,
                    casherName: casherName,
                    invoiceNumber: invoiceNumber,
                    saleDate: saleDate,
                  ),
                  const SizedBox(height: 16),
                  _buildProductsTable(products),
                  const SizedBox(height: 16),
                  _buildTotalsSection(
                      subTotal, discount, grandTotal, paymentMethod),
                  const SizedBox(height: 32),
                  _buildWebActionButtons(
                    invoiceNumber: invoiceNumber,
                    saleDate: saleDate,
                    tableName: tableName,
                    casherName: casherName,
                    products: products,
                    subTotal: subTotal,
                    discount: discount,
                    grandTotal: grandTotal,
                    paymentMethod: paymentMethod,
                    isOffline: isOffline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // HEADER: Logo and INVOICE label in one row, Table/Cashier and Invoice#/Date in columns below
  Widget _buildWebHeaderWithLogo({
    bool isOffline = false,
    String tableName = '',
    String casherName = '',
    required String invoiceNumber,
    required DateTime saleDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First row: Logo and INVOICE label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo_black.jpg',
              width: 80,
              height: 60,
              fit: BoxFit.contain,
            ),
            // INVOICE label
            const Text(
              'INVOICE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Second row: Table/Cashier and Invoice#/Date in two columns
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left column: Table and Cashier
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tableName.isNotEmpty)
                  Text(
                    'Table: $tableName',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                if (casherName.isNotEmpty)
                  Text(
                    'Cashier: $casherName',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
              ],
            ),

            // Right column: Invoice number and Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Invoice# $invoiceNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'Date: ${DateFormat('dd-MM-yyyy').format(saleDate)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Offline badge below everything
        if (isOffline)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'OFFLINE',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductsTable(List<dynamic> products) {
    if (products.isEmpty) {
      return const Text(
        'No items in this sale',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: const [
                  Expanded(
                      flex: 1,
                      child: Text('N°',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13),
                          textAlign: TextAlign.center)),
                  Expanded(
                      flex: 4,
                      child: Text('Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13),
                          textAlign: TextAlign.center)),
                  Expanded(
                      flex: 1,
                      child: Text('Qty',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13),
                          textAlign: TextAlign.center)),
                  Expanded(
                      flex: 1,
                      child: Text('Price',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13),
                          textAlign: TextAlign.center)),
                  Expanded(
                      flex: 1,
                      child: Text('Dis',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13),
                          textAlign: TextAlign.center)),
                  Expanded(
                      flex: 1,
                      child: Text('Amount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13),
                          textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
          ...products.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final product = entry.value;
            final productName = product['product_name']?.toString() ??
                product['name']?.toString() ??
                'Unknown';
            final price = _parsePrice(product['price']);
            final quantity = _parseQuantity(product['quantity']);
            final amount = price * quantity;

            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.grey.shade100 : Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(index.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13))),
                    Expanded(
                        flex: 4,
                        child: Text(productName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13))),
                    Expanded(
                        flex: 1,
                        child: Text(quantity.toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13))),
                    Expanded(
                        flex: 1,
                        child: Text(currencyFormat.format(price),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13))),
                    Expanded(
                        flex: 1,
                        child: Text('-',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey))),
                    Expanded(
                        flex: 1,
                        child: Text(currencyFormat.format(amount),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(double subTotal, double discount,
      double grandTotal, String paymentMethod) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTotalRow('Discount', discount, isBold: true),
          const SizedBox(height: 8),
          _buildTotalRow('Sub Total', subTotal, isBold: true),
          const SizedBox(height: 8),
          _buildTotalRow('Grand Total', grandTotal,
              isBold: true, isGrandTotal: true),
          const SizedBox(height: 12),
          // Payment Type under Grand Total
          Container(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  paymentMethod,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double value,
      {bool isBold = false, bool isGrandTotal = false}) {
    return Container(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isGrandTotal ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(currencyFormat.format(value),
              style: TextStyle(
                  fontSize: isGrandTotal ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildWebActionButtons({
    required String invoiceNumber,
    required DateTime saleDate,
    required String tableName,
    required String casherName,
    required List<dynamic> products,
    required double subTotal,
    required double discount,
    required double grandTotal,
    required String paymentMethod,
    bool isOffline = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            _navigateToMobileReceipt(
              invoiceNumber: invoiceNumber,
              saleDate: saleDate,
              tableName: tableName,
              casherName: casherName,
              products: products,
              subTotal: subTotal,
              discount: discount,
              grandTotal: grandTotal,
              paymentMethod: paymentMethod,
              isOffline: isOffline,
            );
          },
          icon: const Icon(Icons.print, size: 18),
          label: const Text('Print Receipt'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 15),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton.icon(
          onPressed: _isNavigating ? null : _navigateBackToTableScreen,
          icon: const Icon(Icons.done_all, size: 18),
          label: _isNavigating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Done & Return to Tables'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  void _navigateToMobileReceipt({
    required String invoiceNumber,
    required DateTime saleDate,
    required String tableName,
    required String casherName,
    required List<dynamic> products,
    required double subTotal,
    required double discount,
    required double grandTotal,
    required String paymentMethod,
    bool isOffline = false,
  }) {
    Get.to(() => MobileReceiptScreen(
          invoiceNumber: invoiceNumber,
          saleDate: saleDate,
          tableName: tableName,
          casherName: casherName,
          products: products,
          subTotal: subTotal,
          discount: discount,
          grandTotal: grandTotal,
          paymentMethod: paymentMethod,
          isOffline: isOffline,
        ));
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 18),
            Text(message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _navigateBackToTableScreen,
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              child: const Text('Return to Tables'),
            ),
          ],
        ),
      ),
    );
  }

  void _printReceipt() {
    Get.snackbar(
      'Print',
      'Receipt sent to printer',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _navigateBackToTableScreen() async {
    if (_isNavigating) return;
    _isNavigating = true;
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      saleController.receiptSaleData.value = null;
      saleController.receiptProducts.clear();
      saleController.safeClearAllData();
      if (Get.isRegistered<TableController>()) {
        final tableController = Get.find<TableController>();
        tableController.clearSelection();
      }
      await Future.delayed(const Duration(milliseconds: 50));
      Get.offAllNamed('/table');
    } catch (e) {
      Get.offAllNamed('/table');
    } finally {
      _isNavigating = false;
    }
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is String) return double.tryParse(price) ?? 0.0;
    if (price is num) return price.toDouble();
    return 0.0;
  }

  int _parseQuantity(dynamic quantity) {
    if (quantity == null) return 1;
    if (quantity is String) return int.tryParse(quantity) ?? 1;
    if (quantity is num) return quantity.toInt();
    return 1;
  }
}

// Mobile Receipt Screen
class MobileReceiptScreen extends StatelessWidget {
  final String invoiceNumber;
  final DateTime saleDate;
  final String tableName;
  final String casherName;
  final List<dynamic> products;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final String paymentMethod;
  final bool isOffline;
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  final NumberFormat khrFormat =
      NumberFormat.currency(symbol: '៛', decimalDigits: 0);

  MobileReceiptScreen({
    required this.invoiceNumber,
    required this.saleDate,
    required this.tableName,
    required this.casherName,
    required this.products,
    required this.subTotal,
    required this.discount,
    required this.grandTotal,
    required this.paymentMethod,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Receipt Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Store Info
                    _buildStoreInfo(),
                    const SizedBox(height: 16),

                    // INVOICE Title
                    _buildInvoiceTitle(),
                    const SizedBox(height: 12),

                    // Sale Info
                    _buildSaleInfo(),
                    const SizedBox(height: 12),

                    // Products
                    _buildMobileProducts(),
                    const SizedBox(height: 12),

                    // Totals
                    _buildMobileTotals(),
                    const SizedBox(height: 16),

                    // Footer
                    _buildMobileFooter(),
                  ],
                ),
              ),
            ),

            // Done Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back(); // Go back to web receipt
                },
                icon: const Icon(Icons.done_all),
                label: const Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInfo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo_black.jpg',
          width: 90,
          height: 70,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Text(
          'SNACK & RELAX CAFE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Salakomerk comminue, Siem Reap City',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          'Tel: (+865) 76 58 89 898',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceTitle() {
    return Container(
      width: double.infinity,
      child: const Text(
        'INVOICE',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSaleInfo() {
    return Column(
      children: [
        // First row: Date and Cashier
        Container(
          padding: const EdgeInsets.only(left: 510, right: 510),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${DateFormat('dd-MM-yyyy').format(saleDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                'Cashier: $casherName',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
        // Second row: Table and Invoice No
        Container(
          padding: const EdgeInsets.only(left: 510, right: 510),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Table #: $tableName',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                'No: $invoiceNumber',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileProducts() {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(left: 510, right: 510),
        child: Text(
          'No items in this sale',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 510, right: 510),
      child: Column(
        children: [
          // Table Header - Only top and bottom border
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade400),
                bottom: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Name',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Text('Qty',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text('Price',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text('Dis.',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text('Amt.',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right),
                  ),
                ],
              ),
            ),
          ),

          // Products - Only bottom border for the last product
          ...products.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            final productName = product['product_name']?.toString() ??
                product['name']?.toString() ??
                'Unknown';
            final price = _parsePrice(product['price']);
            final quantity = _parseQuantity(product['quantity']);
            final amount = price * quantity;

            // Only add bottom border to the last product
            final isLastProduct = index == products.length - 1;

            return Container(
              decoration: BoxDecoration(
                border: isLastProduct
                    ? Border(
                        bottom: BorderSide(color: Colors.grey.shade400),
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(productName,
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Expanded(
                      child: Text(quantity.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text(currencyFormat.format(price),
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('-',
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text(currencyFormat.format(amount),
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.right),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMobileTotals() {
    return Padding(
      padding: const EdgeInsets.only(left: 510, right: 510),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          children: [
            // Grand Total USD
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Grand Total (USD)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(width: 35),
                  Text(
                    currencyFormat.format(grandTotal),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Grand Total KHR
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Grand Total (KHR)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(width: 35),
                  Text(
                    khrFormat.format(grandTotal * 4000),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 510, right: 510),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            '*អរគុណ! សូមអញ្ចើញមកម្តងទៀត*',
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Thank You! Please come again',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is String) return double.tryParse(price) ?? 0.0;
    if (price is num) return price.toDouble();
    return 0.0;
  }

  int _parseQuantity(dynamic quantity) {
    if (quantity == null) return 1;
    if (quantity is String) return int.tryParse(quantity) ?? 1;
    if (quantity is num) return quantity.toInt();
    return 1;
  }
}
