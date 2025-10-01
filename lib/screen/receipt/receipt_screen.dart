import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/receipt_controller.dart';
import '../../utils/constants.dart';
import 'Widget/report_kpi_widget.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final ReceiptController receiptController = Get.put(ReceiptController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Receipts Screen',
            style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          // Simple dropdown menu button
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              _handleMenuSelection(value);
            },
            itemBuilder: (context) => [
              // Date Filters
              const PopupMenuItem<String>(
                value: 'today',
                child: ListTile(
                  leading: Icon(Icons.today),
                  title: Text('Today'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'month',
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('This Month'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'year',
                child: ListTile(
                  leading: Icon(Icons.calendar_view_month),
                  title: Text('This Year'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'all',
                child: ListTile(
                  leading: Icon(Icons.all_inclusive),
                  title: Text('All Time'),
                ),
              ),
              const PopupMenuDivider(),
              // Actions
              const PopupMenuItem<String>(
                value: 'refresh',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Refresh'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'force_refresh',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Force Refresh'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'debug',
                child: ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('Debug Info'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            // KPI Widgets
            _buildKpiWidgets(),
            // Main Content
            _buildMainContent(),
          ],
        );
      }),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'today':
      case 'month':
      case 'year':
      case 'all':
        receiptController.applyDateFilter(value);
        break;
      case 'refresh':
        receiptController.refreshSales();
        break;
      case 'force_refresh':
        receiptController.forceRefreshSales();
        break;
      case 'debug':
        _showDebugInfo();
        break;
    }
  }

  Widget _buildKpiWidgets() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReceiptKpiWidget(
            label: 'Total Items',
            value: receiptController.totalSale.value.toString(),
            icon: const Icon(Icons.sell, color: Colors.orange),
            color: Colors.orange,
          ),
          ReceiptKpiWidget(
            label: 'Total Orders',
            value: receiptController.totalOrder.value.toString(),
            icon: const Icon(Icons.shopping_cart, color: Colors.red),
            color: Colors.red,
          ),
          ReceiptKpiWidget(
            label: 'Total Revenue',
            value:
                '\$${receiptController.totalRevenue.value.toStringAsFixed(2)}',
            icon: const Icon(Icons.monetization_on, color: Colors.purple),
            color: Colors.purple,
          ),
          ReceiptKpiWidget(
            label: 'Total Profit',
            value:
                '\$${receiptController.totalProfit.value.toStringAsFixed(2)}',
            icon: const Icon(Icons.payment, color: Colors.blue),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (receiptController.loading.value) {
      return _buildLoadingState();
    }

    if (receiptController.errorMessage.value.isNotEmpty) {
      return _buildErrorState();
    }

    if (receiptController.filteredSales.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSalesTable();
  }

  Widget _buildLoadingState() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading sales data...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Error loading sales data',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                receiptController.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: receiptController.refreshSales,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = 'No sales found';
    String subtitle = 'There are no completed sales for the selected period';

    if (receiptController.currentFilter.value == 'today') {
      message = 'No sales today';
      subtitle = 'There are no completed sales for today';
    } else if (receiptController.currentFilter.value == 'month') {
      message = 'No sales this month';
      subtitle = 'There are no completed sales for this month';
    } else if (receiptController.currentFilter.value == 'year') {
      message = 'No sales this year';
      subtitle = 'There are no completed sales for this year';
    }

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTable() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Filter Info Header
              Container(
                color: Colors.blue.shade50,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.filter_alt, size: 16, color: appColor),
                    const SizedBox(width: 8),
                    Text(
                      _getFilterDescription(
                          receiptController.currentFilter.value),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: appColor,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${receiptController.filteredSales.length} sales',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: appColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Table Header
              Container(
                color: appColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Invoice No.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Table',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Date Time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Created By',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Subtotal',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Discount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Grand Total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Scrollable Data Rows
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: receiptController.filteredSales.length,
                    itemBuilder: (context, index) {
                      final sale = receiptController.filteredSales[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              index.isEven ? Colors.white : Colors.grey.shade50,
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                sale.formattedInvoiceNumber,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                sale.tableName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                receiptController.formatDateTime(sale.saleDate),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                sale.creatorName,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '\$${sale.subTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '\$${sale.discount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '\$${sale.grandTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.green.shade700),
                                ),
                                child: const Text(
                                  'Paid',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterDescription(String filterType) {
    switch (filterType) {
      case 'today':
        return 'Showing sales for today';
      case 'month':
        return 'Showing sales for this month';
      case 'year':
        return 'Showing sales for this year';
      case 'all':
      default:
        return 'Showing all sales';
    }
  }

  void _showDebugInfo() {
    final debugInfo = receiptController.debugInfo;
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bug_report, color: Colors.orange),
            SizedBox(width: 8),
            Text('Debug Information'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDebugItem('Current Filter', debugInfo['currentFilter']),
              _buildDebugItem('Date Range', debugInfo['dateRange']),
              _buildDebugItem('Total Sales in Memory',
                  debugInfo['totalSalesInMemory'].toString()),
              _buildDebugItem(
                  'Filtered Sales', debugInfo['filteredSales'].toString()),
              _buildDebugItem('Loading', debugInfo['loading'].toString()),
              _buildDebugItem('Error', debugInfo['error'].toString()),
              const SizedBox(height: 16),
              const Text('KPI Data:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _buildDebugItem(
                  'Total Orders', debugInfo['kpis']['totalOrder'].toString()),
              _buildDebugItem(
                  'Total Items', debugInfo['kpis']['totalSale'].toString()),
              _buildDebugItem('Total Revenue',
                  '\$${debugInfo['kpis']['totalRevenue'].toStringAsFixed(2)}'),
              _buildDebugItem('Total Profit',
                  '\$${debugInfo['kpis']['totalProfit'].toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              const Text('Recent Sales:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              for (var sale in debugInfo['recentSales'])
                Text('  • $sale', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              receiptController.forceRefreshSales();
            },
            child: const Text('Force Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
