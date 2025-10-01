import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/receipt_controller.dart';

class ReportCircleChartWidget extends StatelessWidget {
  const ReportCircleChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ReceiptController receiptController = Get.find<ReceiptController>();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        'Top Sale (${receiptController.pieChartFilter.value == 'today' ? 'Today' : 'Month'})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        // Toggle filter button
                        Obx(() => Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  // Today button
                                  GestureDetector(
                                    onTap: () {
                                      receiptController
                                          .setPieChartFilter('today');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: receiptController
                                                    .pieChartFilter.value ==
                                                'today'
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                          left: Radius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'Day',
                                        style: TextStyle(
                                          color: receiptController
                                                      .pieChartFilter.value ==
                                                  'today'
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Month button
                                  GestureDetector(
                                    onTap: () {
                                      receiptController
                                          .setPieChartFilter('month');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: receiptController
                                                    .pieChartFilter.value ==
                                                'month'
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                          right: Radius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'Month',
                                        style: TextStyle(
                                          color: receiptController
                                                      .pieChartFilter.value ==
                                                  'month'
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (receiptController.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final topProducts = _getTopProducts(
                    receiptController.filteredSales,
                    receiptController.pieChartFilter.value);
                final totalQuantity = _getTotalQuantity(topProducts);

                // If no data, show empty state
                if (totalQuantity == 0) {
                  return const Center(
                    child: Text(
                      'No sales data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PieChart(
                    PieChartData(
                      sections: topProducts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final product = entry.value;
                        final percentage = totalQuantity > 0
                            ? (product['quantity'] / totalQuantity * 100)
                            : 0;

                        return PieChartSectionData(
                          value: percentage.toDouble(),
                          color: _getColorForIndex(index),
                          title: '${percentage.round()}%',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      borderData: FlBorderData(show: false),
                      centerSpaceRadius: 0,
                      sectionsSpace: 0,
                    ),
                  ),
                );
              }),
            ),
            Obx(() {
              if (receiptController.loading.value) {
                return const SizedBox();
              }

              final topProducts = _getTopProducts(
                  receiptController.filteredSales,
                  receiptController.pieChartFilter.value);

              // If no data, don't show labels
              if (topProducts.isEmpty || _getTotalQuantity(topProducts) == 0) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < topProducts.length; i++)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getColorForIndex(i),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _truncateText(topProducts[i]['name'], 10),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTopProducts(
      List<dynamic> sales, String filter) {
    final Map<String, num> productCount = {};

    try {
      final now = DateTime.now();

      // Count products from filtered sales based on time filter
      for (var sale in sales) {
        final saleDate = sale.saleDate;

        // Apply time filter
        if (filter == 'today') {
          // Only include sales from today
          if (!_isSameDay(saleDate, now)) {
            continue;
          }
        } else if (filter == 'month') {
          // Only include sales from current month
          if (!_isSameMonth(saleDate, now)) {
            continue;
          }
        }

        // Access products from Sale object
        if (sale.products != null && sale.products is List) {
          for (var product in sale.products) {
            _addProductToCount(productCount, product);
          }
        }
      }
    } catch (e) {
      print('Error processing sales data: $e');
    }

    // Sort by quantity and take top 4
    final sortedProducts = productCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Get top 4 or all if less than 4
    final topProducts = sortedProducts
        .take(4)
        .map((entry) => {
              'name': entry.key,
              'quantity': entry.value,
            })
        .toList();

    // If we have less than 4 products, fill with "Other Products"
    while (topProducts.length < 4) {
      topProducts.add({
        'name': 'Other Products',
        'quantity': 0,
      });
    }

    return topProducts;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  void _addProductToCount(Map<String, num> productCount, dynamic product) {
    try {
      String productName = 'Unknown Product';
      num quantity = 1;

      // Product data can be either JSON map or Product object
      if (product is Map) {
        // JSON map - use bracket notation
        if (product['product_name'] != null) {
          productName = product['product_name'].toString();
        } else if (product['name'] != null) {
          productName = product['name'].toString();
        }

        if (product['quantity'] != null) {
          quantity = product['quantity'] is int
              ? product['quantity']
              : (product['quantity'] as num).toInt();
        }
      } else {
        // Product object - use dot notation
        if (product.product_name != null) {
          productName = product.product_name.toString();
        } else if (product.name != null) {
          productName = product.name.toString();
        }

        if (product.quantity != null) {
          quantity = product.quantity is int
              ? product.quantity
              : (product.quantity as num).toInt();
        }
      }

      productCount[productName] = (productCount[productName] ?? 0) + quantity;
    } catch (e) {
      print('Error adding product to count: $e');
    }
  }

  num _getTotalQuantity(List<Map<String, dynamic>> topProducts) {
    return topProducts.fold<num>(
        0, (sum, product) => sum + (product['quantity'] as num));
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
