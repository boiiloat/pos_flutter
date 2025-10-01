import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/receipt_controller.dart';
import 'package:pos_system/controller/table_controller.dart';
import 'package:pos_system/controller/user_controller.dart';
import 'package:pos_system/controller/product_controller.dart';
import '../../../utils/constants.dart';
import '../../receipt/Widget/report_kpi_widget.dart';
import 'Widget/report_circle_chartWidget.dart';
import 'Widget/report_sale_overview_widget.dart';

class ReportScreen extends StatelessWidget {
  final ReceiptController receiptController = Get.put(ReceiptController());
  final TableController tableController = Get.put(TableController());
  final UserController userController = Get.put(UserController());
  final ProductController productController = Get.put(ProductController());

  ReportScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      receiptController.refreshSales();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Report Screen',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: appColor,
        actions: [
          // Filter dropdown menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: _handleMenuSelection,
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
            // KPI Widgets from ReceiptScreen
            _buildKpiWidgets(),

            // Main content area
            Expanded(
              child: Column(
                children: [
                  // Top section: Charts
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: ReportSaleOverviewWidget(),
                          ),
                          Expanded(
                            flex: 3,
                            child: ReportCircleChartWidget(),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Bottom section: Receipt table and summary
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        children: [
                          // Receipt Table (extracted from ReceiptScreen)
                          Expanded(
                            flex: 7,
                            child: _buildReceiptTable(),
                          ),
                          // Integrated Report Summary Widget directly here
                          Expanded(
                            flex: 3,
                            child: _buildReportSummaryWidget(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

// Integrated Report Summary Widget
  Widget _buildReportSummaryWidget() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // Fixed header
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'System Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.0),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Invoice Count
                        _buildSummaryRow(
                          label: 'Total Invoices',
                          value:
                              receiptController.filteredSales.length.toString(),
                          color: Colors.blue,
                        ),
                        const Divider(),

                        // Table Count
                        _buildSummaryRow(
                          label: 'Total Tables',
                          value: tableController.tableData.length.toString(),
                          color: Colors.green,
                        ),
                        const Divider(),

                        // User Count
                        _buildSummaryRow(
                          label: 'Total Users',
                          value: userController.users.length.toString(),
                          color: Colors.orange,
                        ),
                        const Divider(),

                        // Product Count
                        _buildSummaryRow(
                          label: 'Total Products',
                          value: productController.products.length.toString(),
                          color: Colors.purple,
                        ),
                        const Divider(),
                        // Admin Users
                        _buildSummaryRow(
                          label: 'Admin Users',
                          value: userController.users
                              .where((user) => user.roleId == 1)
                              .length
                              .toString(),
                          color: Colors.red,
                        ),
                        const Divider(),

                        // Cashier Users
                        _buildSummaryRow(
                          label: 'Cashier Users',
                          value: userController.users
                              .where((user) => user.roleId == 2)
                              .length
                              .toString(),
                          color: Colors.amber,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Summary Row Builder - Smaller version
  Widget _buildSummaryRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 6.0, vertical: 4.0), // Reduced padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14, // Smaller font
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6), // Smaller border radius
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4), // Reduced padding
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12, // Smaller font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // KPI Widgets from ReceiptScreen
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

  // Extracted Receipt Table from ReceiptScreen
  Widget _buildReceiptTable() {
    if (receiptController.loading.value) return _buildLoadingState();
    if (receiptController.errorMessage.value.isNotEmpty)
      return _buildErrorState();
    if (receiptController.filteredSales.isEmpty) return _buildEmptyState();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Total Receipts Header
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _getReceiptHeaderText(),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Table Header
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: const Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text('Invoice No.',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Table',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Text('Date Time',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Created By',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Subtotal',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Discount',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Grand Total',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text('Status',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Table Rows
            Expanded(
              child: ListView.builder(
                itemCount: receiptController.filteredSales.length,
                itemBuilder: (context, index) {
                  final sale = receiptController.filteredSales[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color:
                            index.isEven ? Colors.white : Colors.grey.shade50,
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(sale.formattedInvoiceNumber,
                                  style: const TextStyle(fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text(sale.tableName,
                                  style: const TextStyle(fontSize: 12))),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  receiptController
                                      .formatDateTime(sale.saleDate),
                                  style: const TextStyle(fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text(sale.creatorName,
                                  style: const TextStyle(fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  '\$${sale.subTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  '\$${sale.discount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  '\$${sale.grandTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12))),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.green.shade700),
                              ),
                              child: const Text('Paid',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get Receipt Header Text based on filter
  String _getReceiptHeaderText() {
    switch (receiptController.currentFilter.value) {
      case 'today':
        return '  Total Receipt (Current Day)';
      case 'month':
        return '  Total Receipt (Month)';
      case 'year':
        return '  Total Receipt (Year)';
      case 'all':
      default:
        return '  Total Receipt (All Time)';
    }
  }

  // Loading State
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading sales data...'),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorState() {
    return Center(
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
    );
  }

  // Empty State
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

    return Center(
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
    );
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
