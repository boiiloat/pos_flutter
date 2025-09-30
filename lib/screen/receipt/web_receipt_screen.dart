import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/sale_controller.dart';
import '../../controller/table_controller.dart';
import '../../models/api/sale_model.dart' as sale_model;

class WebReceiptScreen extends StatelessWidget {
  final SaleController saleController = Get.find();
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    // Use preserved receipt data first, then fallback to current sale
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

  // Build from preserved data (most reliable)
  Widget _buildReceiptFromPreservedData(Map<String, dynamic> receiptData) {
    final products = receiptData['products'] as List<dynamic>? ?? [];
    final invoiceNumber = receiptData['invoice_number'] as String? ?? 'OFFLINE';
    final saleDate = receiptData['sale_date'] is DateTime
        ? receiptData['sale_date'] as DateTime
        : DateTime.now();
    final tableName = receiptData['table_name'] as String? ?? 'No Table';
    final subTotal = receiptData['sub_total'] as double? ?? 0.0;
    final discount = receiptData['discount'] as double? ?? 0.0;
    final grandTotal = receiptData['grand_total'] as double? ?? 0.0;
    final paymentMethod = receiptData['payment_method'] as String? ?? 'Unknown';

    return WillPopScope(
      onWillPop: () async {
        _navigateBackToTableScreen();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              // Header
              _buildWebHeader(),
              const SizedBox(height: 30),

              // Sale Info
              _buildPreservedSaleInfo(invoiceNumber, saleDate, tableName),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 30),

              // Products List
              _buildPreservedProductsList(products),
              const SizedBox(height: 30),

              // Totals
              _buildPreservedTotals(subTotal, discount, grandTotal),
              const SizedBox(height: 30),

              // Payment Info
              _buildPreservedPaymentInfo(paymentMethod, saleDate),
              const SizedBox(height: 40),

              // Action Buttons
              _buildWebActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Build from current sale (API data)
  Widget _buildReceiptFromSale(sale_model.Sale sale) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    final products = sale.products ?? [];

    return _buildWebLayout(
      invoiceNumber: sale.invoiceNumber ?? 'N/A',
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
    );
  }

  // Build from cart data (fallback)
  Widget _buildReceiptFromCartData() {
    final cartItems = saleController.cartItems;
    final cartQuantities = saleController.cartQuantities;

    if (cartItems.isEmpty) {
      return _buildErrorScreen('No sale data available');
    }

    // Convert cart items to product list format
    final products = cartItems.map((product) {
      final key = '${product.id}_${product.price}';
      final quantity = cartQuantities[key] ?? 1;
      return {
        'product_name': product.name,
        'price': product.price,
        'quantity': quantity,
      };
    }).toList();

    return _buildWebLayout(
      invoiceNumber: 'OFFLINE-CART',
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
    );
  }

  // Generic web layout builder
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
  }) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBackToTableScreen();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              // Header
              _buildWebHeader(isOffline: isOffline),
              const SizedBox(height: 30),

              // Invoice info
              _buildWebInvoiceInfo(invoiceNumber, saleDate, tableName,
                  isOffline: isOffline),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 30),

              // Products list
              _buildWebProductsList(products),
              const SizedBox(height: 30),

              // Totals
              _buildWebTotals(subTotal, discount, grandTotal),
              const SizedBox(height: 30),

              // Payment info
              _buildWebPaymentInfo(paymentMethod, saleDate, isPaid,
                  isOffline: isOffline),
              const SizedBox(height: 40),

              // Action Buttons
              _buildWebActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ========== PRESERVED DATA COMPONENTS ==========
  Widget _buildPreservedSaleInfo(
      String invoiceNumber, DateTime saleDate, String tableName) {
    return Center(
      child: Column(
        children: [
          Text(
            'Invoice# $invoiceNumber',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Date: ${DateFormat('yyyy-MM-dd').format(saleDate)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Table: $tableName',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPreservedProductsList(List<dynamic> products) {
    if (products.isEmpty) {
      return const Text(
        'No items in this sale',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
        columns: const [
          DataColumn(
              label:
                  Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: products.map((product) {
          final productName = product['product_name']?.toString() ?? 'Unknown';
          final price = _parsePrice(product['price']);
          final quantity = _parseQuantity(product['quantity']);
          final amount = price * quantity;

          return DataRow(cells: [
            DataCell(Text(productName)),
            DataCell(Text(quantity.toString())),
            DataCell(Text(currencyFormat.format(price))),
            DataCell(Text(currencyFormat.format(amount))),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildPreservedTotals(
      double subTotal, double discount, double grandTotal) {
    return SizedBox(
      width: 400,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            _buildTotalRow('Subtotal', subTotal),
            if (discount > 0) _buildTotalRow('Discount', -discount),
            const Divider(thickness: 1),
            _buildTotalRow('GRAND TOTAL', grandTotal, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPreservedPaymentInfo(String paymentMethod, DateTime saleDate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Payment Type: $paymentMethod',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Time: ${DateFormat('HH:mm:ss').format(saleDate)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Status: PAID',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ========== SHARED COMPONENTS ==========
  Widget _buildWebHeader({bool isOffline = false}) {
    return Center(
      child: Column(
        children: [
          Text(
            'Snack & Relax Cafe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isOffline ? Colors.orange : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOffline ? 'INVOICE - OFFLINE MODE' : 'INVOICE',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isOffline ? Colors.orange : Colors.black,
            ),
          ),
          if (isOffline) ...[
            const SizedBox(height: 8),
            Text(
              'Data preserved from sale transaction',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWebInvoiceInfo(
      String invoiceNumber, DateTime saleDate, String tableName,
      {bool isOffline = false}) {
    return Center(
      child: Column(
        children: [
          Text(
            'Invoice# $invoiceNumber',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isOffline ? Colors.orange : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Date: ${DateFormat('yyyy-MM-dd').format(saleDate)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Table: ${tableName.isNotEmpty ? tableName : 'No Table'}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildWebProductsList(List<dynamic> products) {
    if (products.isEmpty) {
      return const Text(
        'No items in this sale',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
        columns: const [
          DataColumn(
              label:
                  Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: products.map((product) {
          final productName = product['product_name']?.toString() ??
              product['name']?.toString() ??
              'Unknown';
          final price = _parsePrice(product['price']);
          final quantity = _parseQuantity(product['quantity']);
          final amount = price * quantity;

          return DataRow(cells: [
            DataCell(Text(productName)),
            DataCell(Text(quantity.toString())),
            DataCell(Text(currencyFormat.format(price))),
            DataCell(Text(currencyFormat.format(amount))),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildWebTotals(double subTotal, double discount, double grandTotal) {
    return SizedBox(
      width: 400,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            _buildTotalRow('Subtotal', subTotal),
            if (discount > 0) _buildTotalRow('Discount', -discount),
            const Divider(thickness: 1),
            _buildTotalRow('GRAND TOTAL', grandTotal, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildWebPaymentInfo(
      String paymentMethod, DateTime saleDate, bool isPaid,
      {bool isOffline = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Payment Type: $paymentMethod',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Time: ${DateFormat('HH:mm:ss').format(saleDate)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            isOffline
                ? 'Status: PROCESSED OFFLINE'
                : isPaid
                    ? 'Status: PAID'
                    : 'Status: PENDING',
            style: TextStyle(
              fontSize: 16,
              color: isOffline
                  ? Colors.orange
                  : isPaid
                      ? Colors.green
                      : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _printReceipt,
          icon: const Icon(Icons.print),
          label: const Text('Print Receipt'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton.icon(
          onPressed: _isNavigating ? null : _navigateBackToTableScreen,
          icon: const Icon(Icons.done_all),
          label: _isNavigating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Done & Return to Tables'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 16,
            ),
          ),
          Text(
            currencyFormat.format(value),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateBackToTableScreen,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
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

// In WebReceiptScreen - REPLACE the _navigateBackToTableScreen method
  void _navigateBackToTableScreen() async {
    if (_isNavigating) return;

    _isNavigating = true;
    print('🔄 Starting navigation back to Table Screen...');

    try {
      // Small delay to let UI update
      await Future.delayed(const Duration(milliseconds: 100));

      // CLEAR ALL SALE DATA to start fresh
      print('🧹 Clearing ALL sale data for fresh start...');
      saleController.receiptSaleData.value = null;
      saleController.receiptProducts.clear();
      saleController.safeClearAllData(); // This will clear everything

      // Also clear table selection to force fresh table selection
      if (Get.isRegistered<TableController>()) {
        final tableController = Get.find<TableController>();
        tableController.clearSelection();
      }

      // Another small delay
      await Future.delayed(const Duration(milliseconds: 50));

      // Navigate back to TABLE SCREEN with fresh state
      print('🚀 Navigating to Table Screen with fresh state...');
      Get.offAllNamed('/table');

      print('✅ Navigation completed - All sale data cleared for fresh start');
    } catch (e) {
      print('❌ Navigation error: $e');
      Get.offAllNamed('/table'); // Fallback
    } finally {
      _isNavigating = false;
    }
  }

  // ========== HELPER METHODS ==========
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
