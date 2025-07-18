import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/pos/table/table_screen.dart';
import '../../controller/sale_controller.dart';

class WebReceiptScreen extends StatelessWidget {
  final SaleController saleController = Get.find();
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    final sale = saleController.currentSale.value!;
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');

    // Calculate totals from products as fallback
    final calculatedSubtotal = sale.products.fold(0.0, (sum, product) {
      final price = product['price'] is String
          ? double.tryParse(product['price']) ?? 0.0
          : (product['price'] as num).toDouble();
      return sum + (price * product['quantity']);
    });

    final calculatedGrandTotal = calculatedSubtotal - sale.discount;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header
            const Center(
              child: Text(
                'Snack & Relax Cafe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Invoice info
            const Center(
              child: Text(
                'INVOICE',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(child: Text('Invoice# ${sale.invoiceNumber}')),
            Center(child: Text('Date: ${dateFormat.format(sale.saleDate)}')),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // Products list
            if (sale.products.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Table(
                border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                },
                children: [
                  // Table header
                  const TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(6), child: Text('Item')),
                      Padding(padding: EdgeInsets.all(6), child: Text('Qty')),
                      Padding(padding: EdgeInsets.all(6), child: Text('Price')),
                      Padding(padding: EdgeInsets.all(6), child: Text('Dis')),
                      Padding(
                          padding: EdgeInsets.all(6), child: Text('Amount')),
                    ],
                  ),
                  // Products
                  ...sale.products.map((product) {
                    final price = product['price'] is String
                        ? double.tryParse(product['price']) ?? 0.0
                        : (product['price'] as num).toDouble();
                    final amount = price * product['quantity'];

                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(product['product_name'] ?? 'Unknown'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(product['quantity'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(currencyFormat.format(price)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(6),
                          child: Text('-'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(currencyFormat.format(amount)),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ] else ...[
              const Text('No items in this sale',
                  style: TextStyle(color: Colors.grey)),
            ],

            // Totals - Use calculated values if API values are incorrect
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTotalRow('Discount', sale.discount),
                  _buildTotalRow('Sub Total',
                      sale.subTotal > 0 ? sale.subTotal : calculatedSubtotal),
                  _buildTotalRow(
                      'Grand Total',
                      sale.grandTotal > 0
                          ? sale.grandTotal
                          : calculatedGrandTotal,
                      isBold: true),
                ],
              ),
            ),

            // Payment info
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Payment Type: ',
                      children: [
                        TextSpan(
                          text: saleController.selectedPaymentMethod.value
                                  ?.paymentMethodName ??
                              'N/A',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text('Time: ${timeFormat.format(sale.saleDate)}'),
                  const SizedBox(height: 10),
                  Text(
                    'Cashier: ',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Done button
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('$label ',
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              )),
          Text(currencyFormat.format(value),
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              )),
        ],
      ),
    );
  }
}
