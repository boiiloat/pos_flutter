import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/receipt_controller.dart';

class ReportSaleOverviewWidget extends StatefulWidget {
  const ReportSaleOverviewWidget({super.key});

  @override
  _ReportSaleOverviewWidgetState createState() =>
      _ReportSaleOverviewWidgetState();
}

class _ReportSaleOverviewWidgetState extends State<ReportSaleOverviewWidget> {
  final ReceiptController receiptController = Get.find<ReceiptController>();
  int _currentFilterIndex = 2; // Default: Year (index 1)
  final List<String> _filters = ['today', 'month', 'year']; // Removed 'all'

  void _cycleFilter() {
    setState(() {
      _currentFilterIndex = (_currentFilterIndex + 1) % _filters.length;
    });
  }

  String get _currentFilter => _filters[_currentFilterIndex];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getChartTitle(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: _cycleFilter,
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (receiptController.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Get all sales data (not filtered by ReportScreen)
                final salesData = receiptController.sales;
                final chartData = _getChartData(salesData);
                final maxY = _getMaxYValue(chartData);

                return Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 400,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY + (maxY * 0.1), // Add 10% padding
                      minY: 0,
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final label = _getTooltipLabel(group.x.toInt());
                            final value = rod.toY.toInt();
                            return BarTooltipItem(
                              '$label: $value orders',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        touchCallback: (event, response) {
                          if (response != null && response.spot != null) {
                            // Handle touch interaction if needed
                          }
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: _getYAxisInterval(maxY),
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final labels = _getBottomTitles();
                              if (value.toInt() < labels.length) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 4.0,
                                  child: Text(
                                    labels[value.toInt()],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      barGroups: chartData,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        drawHorizontalLine: true,
                        horizontalInterval: _getYAxisInterval(maxY),
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(
                            color: Color(0xffe2e2e2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _getChartTitle() {
    switch (_currentFilter) {
      case 'today':
        return "Sale Overview (Current Day)";
      case 'month':
        return "Sale Overview (Current Month)";
      case 'year':
      default:
        return "Sale Overview (Current Year)";
    }
  }

  List<String> _getBottomTitles() {
    switch (_currentFilter) {
      case 'today':
        return _getHourlyLabels();
      case 'month':
        return _getDailyLabelsForMonth();
      case 'year':
      default:
        return _getMonthlyLabelsForYear();
    }
  }

  List<String> _getHourlyLabels() {
    return List.generate(
        24, (index) => '${index.toString().padLeft(2, '0')}:00');
  }

  List<String> _getDailyLabelsForMonth() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return List.generate(daysInMonth, (index) => (index + 1).toString());
  }

  List<String> _getMonthlyLabelsForYear() {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
  }

  String _getTooltipLabel(int index) {
    final labels = _getBottomTitles();
    if (index < labels.length) {
      return labels[index];
    }
    return 'Day ${index + 1}';
  }

  List<BarChartGroupData> _getChartData(List<dynamic> salesData) {
    switch (_currentFilter) {
      case 'today':
        return _getHourlyData(salesData);
      case 'month':
        return _getDailyData(salesData);
      case 'year':
      default:
        return _getYearlyData(salesData);
    }
  }

  List<BarChartGroupData> _getHourlyData(List<dynamic> salesData) {
    final salesByHour = _groupSalesByHour(salesData);

    return List.generate(24, (index) {
      final hourSales = salesByHour[index] ?? [];
      final totalOrders = hourSales.length;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalOrders.toDouble(),
            width: 15,
            borderRadius: BorderRadius.zero,
            color: _getColorForIndex(index),
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _getDailyData(List<dynamic> salesData) {
    final salesByDay = _groupSalesByDayOfMonth(salesData);
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return List.generate(daysInMonth, (index) {
      final day = index + 1;
      final daySales = salesByDay[day] ?? [];
      final totalOrders = daySales.length;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalOrders.toDouble(),
            width: 20,
            borderRadius: BorderRadius.zero,
            color: _getColorForIndex(index),
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _getYearlyData(List<dynamic> salesData) {
    final salesByMonth = _groupSalesByMonthForCurrentYear(salesData);

    return List.generate(12, (index) {
      final month = index + 1;
      final monthSales = salesByMonth[month] ?? [];
      final totalOrders = monthSales.length;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalOrders.toDouble(),
            width: 25,
            borderRadius: BorderRadius.zero,
            color: _getColorForIndex(index),
          ),
        ],
      );
    });
  }

  // Data grouping methods - filter for current period only
  Map<int, List<dynamic>> _groupSalesByHour(List<dynamic> salesData) {
    final Map<int, List<dynamic>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var sale in salesData) {
      final saleDate = sale.saleDate;
      // Only include sales from today
      if (saleDate.year == now.year &&
          saleDate.month == now.month &&
          saleDate.day == now.day) {
        final hour = saleDate.hour;
        if (!grouped.containsKey(hour)) {
          grouped[hour] = [];
        }
        grouped[hour]!.add(sale);
      }
    }

    return grouped;
  }

  Map<int, List<dynamic>> _groupSalesByDayOfMonth(List<dynamic> salesData) {
    final Map<int, List<dynamic>> grouped = {};
    final now = DateTime.now();

    for (var sale in salesData) {
      final saleDate = sale.saleDate;
      // Only include sales from current month
      if (saleDate.year == now.year && saleDate.month == now.month) {
        final day = saleDate.day;
        if (!grouped.containsKey(day)) {
          grouped[day] = [];
        }
        grouped[day]!.add(sale);
      }
    }

    return grouped;
  }

  Map<int, List<dynamic>> _groupSalesByMonthForCurrentYear(
      List<dynamic> salesData) {
    final Map<int, List<dynamic>> grouped = {};
    final now = DateTime.now();

    for (var sale in salesData) {
      final saleDate = sale.saleDate;
      // Only include sales from current year
      if (saleDate.year == now.year) {
        final month = saleDate.month;
        if (!grouped.containsKey(month)) {
          grouped[month] = [];
        }
        grouped[month]!.add(sale);
      }
    }

    return grouped;
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.yellow,
      Colors.cyan,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.lightBlue,
    ];
    return colors[index % colors.length];
  }

  double _getMaxYValue(List<BarChartGroupData> data) {
    if (data.isEmpty) return 10.0;

    double max = 0;
    for (var group in data) {
      for (var rod in group.barRods) {
        if (rod.toY > max) {
          max = rod.toY;
        }
      }
    }
    return max == 0 ? 10.0 : max;
  }

  double _getYAxisInterval(double maxY) {
    if (maxY <= 5) return 1;
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    return 50;
  }
}
