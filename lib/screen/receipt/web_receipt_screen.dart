import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/sale_controller.dart';
import '../../models/api/sale_model.dart' as sale_model;

class WebReceiptScreen extends StatelessWidget {
  final SaleController saleController = Get.find();
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    // Safe access with comprehensive null checking
    final sale = saleController.currentSale.value;

    // If sale is null, try to get from cart data as fallback
    if (sale == null) {
      return _buildReceiptFromCartData();
    }

    return WillPopScope(
      onWillPop: () async {
        _navigateBackToTableScreen();
        return false;
      },
      child: Scaffold(
        body: _buildWebReceipt(sale),
      ),
    );
  }

  // Build receipt from cart data as fallback
  Widget _buildReceiptFromCartData() {
    final cartItems = saleController.cartItems;
    final cartQuantities = saleController.cartQuantities;

    if (cartItems.isEmpty) {
      return _buildErrorScreen('No sale data available');
    }

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
              _buildWebHeader(isOffline: true),
              const SizedBox(height: 30),

              // Sale Info
              _buildOfflineSaleInfo(),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 30),

              // Items from cart
              _buildCartItemsSection(cartItems, cartQuantities),

              const SizedBox(height: 30),

              // Totals from controller
              _buildCartTotalsSection(),

              const SizedBox(height: 30),

              // Payment Info
              _buildOfflinePaymentInfo(),

              const SizedBox(height: 40),

              // Action Buttons - Updated to go to table screen
              _buildWebActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Web Layout
  Widget _buildWebReceipt(sale_model.Sale sale) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    final products = sale.products ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          // Header
          _buildWebHeader(),
          const SizedBox(height: 30),

          // Invoice info
          _buildWebInvoiceInfo(sale, dateFormat),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 30),

          // Products list
          _buildWebProductsList(products),
          const SizedBox(height: 30),

          // Totals
          _buildWebTotals(sale),
          const SizedBox(height: 30),

          // Payment info
          _buildWebPaymentInfo(sale, timeFormat),
          const SizedBox(height: 40),

          // Action Buttons - Updated to go to table screen
          _buildWebActionButtons(),
        ],
      ),
    );
  }

  // ========== WEB COMPONENTS ==========
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
              'Data may be incomplete due to network issues',
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

  Widget _buildWebInvoiceInfo(sale_model.Sale sale, DateFormat dateFormat) {
    return Center(
      child: Column(
        children: [
          Text(
            'Invoice# ${sale.invoiceNumber ?? 'N/A'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Date: ${dateFormat.format(sale.saleDate ?? DateTime.now())}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Table: ${saleController.currentTableName.value.isNotEmpty ? saleController.currentTableName.value : 'No Table'}',
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

  Widget _buildWebTotals(sale_model.Sale sale) {
    final subtotal = sale.subTotal > 0
        ? sale.subTotal
        : _calculateSubtotal(sale.products ?? []);
    final discount = sale.discount ?? 0.0;
    final grandTotal =
        sale.grandTotal > 0 ? sale.grandTotal : (subtotal - discount);

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
            _buildTotalRow('Subtotal', subtotal),
            if (discount > 0) _buildTotalRow('Discount', -discount),
            const Divider(thickness: 1),
            _buildTotalRow('GRAND TOTAL', grandTotal, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildWebPaymentInfo(sale_model.Sale sale, DateFormat timeFormat) {
    final paymentMethod = saleController.selectedPaymentMethod.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Payment Type: ${paymentMethod?.paymentMethodName ?? 'N/A'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Time: ${timeFormat.format(sale.saleDate ?? DateTime.now())}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${sale.isPaid == true ? 'PAID' : 'PENDING'}',
            style: TextStyle(
              fontSize: 16,
              color: sale.isPaid == true ? Colors.green : Colors.orange,
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

  // ========== OFFLINE/CART DATA COMPONENTS ==========
  Widget _buildOfflineSaleInfo() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Invoice# OFFLINE',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Table: ${saleController.currentTableName.value.isNotEmpty ? saleController.currentTableName.value : 'No Table'}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsSection(
      List<dynamic> cartItems, Map<String, int> cartQuantities) {
    if (cartItems.isEmpty) {
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
        rows: cartItems.map((product) {
          final key = '${product.id}_${product.price}';
          final quantity = cartQuantities[key] ?? 1;
          final amount = product.price * quantity;

          return DataRow(cells: [
            DataCell(Text(product.name)),
            DataCell(Text(quantity.toString())),
            DataCell(Text(currencyFormat.format(product.price))),
            DataCell(Text(currencyFormat.format(amount))),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildCartTotalsSection() {
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
            _buildTotalRow('Subtotal', saleController.saleSubtotal.value),
            if (saleController.saleDiscount.value > 0)
              _buildTotalRow('Discount', -saleController.saleDiscount.value),
            const Divider(thickness: 1),
            _buildTotalRow('GRAND TOTAL', saleController.saleTotal.value,
                isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflinePaymentInfo() {
    final paymentMethod = saleController.selectedPaymentMethod.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Payment Type: ${paymentMethod?.paymentMethodName ?? 'N/A'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Status: PROCESSED OFFLINE',
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ========== SHARED COMPONENTS ==========
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

  void _navigateBackToTableScreen() async {
    if (_isNavigating) return;

    _isNavigating = true;
    print('🔄 Starting navigation back to Table Screen...');

    try {
      // Small delay to let UI update
      await Future.delayed(const Duration(milliseconds: 100));

      // Clear sale data but preserve table info
      print('🧹 Clearing sale data...');
      saleController.safeClearSaleDataOnly();

      // Another small delay
      await Future.delayed(const Duration(milliseconds: 50));

      // Navigate back to TABLE SCREEN
      print('🚀 Navigating to Table Screen...');
      Get.offAllNamed('/table');

      print('✅ Navigation completed successfully');
    } catch (e) {
      print('❌ Navigation error: $e');

      // Fallback navigation
      try {
        Get.offAllNamed('/table');
      } catch (e2) {
        print('❌ Fallback navigation also failed: $e2');
        Get.until((route) => route.isFirst);
      }
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

  double _calculateSubtotal(List<dynamic> products) {
    return products.fold(0.0, (sum, product) {
      final price = _parsePrice(product['price']);
      final quantity = _parseQuantity(product['quantity']);
      return sum + (price * quantity);
    });
  }
}
