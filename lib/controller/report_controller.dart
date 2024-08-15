import 'dart:ui';

import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportController extends GetxController {
  // Example data, you can modify it according to your requirements
  final RxList<BarChartGroupData> barGroups = <BarChartGroupData>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load your data here. For example:
    loadBarChartData();
  }

  void loadBarChartData() {
    // Dummy data for demonstration purposes
    barGroups.value = [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: 8,
            color: const Color(0xff1d6f42),
            width: 22,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: 6,
            color: const Color(0xff1d6f42),
            width: 22,
          ),
        ],
      ),
      // Add more BarChartGroupData objects for more bars
    ];
  }
}
