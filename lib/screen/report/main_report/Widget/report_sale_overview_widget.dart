import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportSaleOverviewWidget extends StatefulWidget {
  const ReportSaleOverviewWidget({super.key});

  @override
  _ReportSaleOverviewWidgetState createState() =>
      _ReportSaleOverviewWidgetState();
}

class _ReportSaleOverviewWidgetState extends State<ReportSaleOverviewWidget> {
  bool showWeekly = true; // Toggle between Week and Month

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Rounded corners
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
                  Text(showWeekly
                      ? "Sale Overview (Week)"
                      : "Sale Overview (Month)"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showWeekly =
                            !showWeekly; // Toggle between Week and Month
                      });
                    },
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0), // Padding around chart
                height: 400, // Adjusted height for a taller chart
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(
                      show: false, // Hide all borders
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize:
                              40, // Allocate space for the left numbers
                          interval: 1, // Set the interval to 1
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
                        sideTitles:
                            SideTitles(showTitles: false), // Remove top titles
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false), // Remove right titles
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (showWeekly) {
                              const days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ];
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 4.0,
                                child: Text(
                                  days[value.toInt()],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            } else {
                              const months = [
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
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 4.0,
                                child: Text(
                                  months[value.toInt()],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                          },
                          reservedSize: 40, // Adjust to fit month names
                        ),
                      ),
                    ),
                    barGroups: showWeekly
                        ? weeklyData()
                        : monthlyData(), // Use different data sets
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: 1, // Adjust horizontal line intervals
                      verticalInterval: 1, // Adjust vertical line intervals
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Color(0xffe2e2e2),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return const FlLine(
                          color: Color(0xffe2e2e2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Weekly data for the bar chart
  List<BarChartGroupData> weeklyData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 8, // Adjusted to fit the new y-axis range
            width: 50,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.blue,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 6, // Adjusted to fit the new y-axis range
            width: 50,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.green,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 7, // Adjusted to fit the new y-axis range
            width: 50,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.orange,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: 9, // Adjusted to fit the new y-axis range
            width: 50,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.red,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: 6, // Adjusted to fit the new y-axis range
            width: 50,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.purple,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
            toY: 7, // Adjusted to fit the new y-axis range
            width: 50,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.teal,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(
            toY: 5, // Adjusted to fit the new y-axis range
            width: 50,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.yellow,
          ),
        ],
      ),
    ];
  }

  // Monthly data for the bar chart
  List<BarChartGroupData> monthlyData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 10, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.blue,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 8, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.green,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 9, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.orange,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: 10, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.red,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: 9, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.purple,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
            toY: 8, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.teal,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(
            toY: 7, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.yellow,
          ),
        ],
      ),
      BarChartGroupData(
        x: 7,
        barRods: [
          BarChartRodData(
            toY: 6, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.cyan,
          ),
        ],
      ),
      BarChartGroupData(
        x: 8,
        barRods: [
          BarChartRodData(
            toY: 5, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.indigo,
          ),
        ],
      ),
      BarChartGroupData(
        x: 9,
        barRods: [
          BarChartRodData(
            toY: 4, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.grey,
          ),
        ],
      ),
      BarChartGroupData(
        x: 10,
        barRods: [
          BarChartRodData(
            toY: 3, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.orangeAccent,
          ),
        ],
      ),
      BarChartGroupData(
        x: 11,
        barRods: [
          BarChartRodData(
            toY: 2, // Adjusted to fit the new y-axis range
            width: 30,
            borderRadius: BorderRadius.zero, // Sharp corners
            color: Colors.pink,
          ),
        ],
      ),
    ];
  }
}
