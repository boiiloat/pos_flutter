import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportCircleChartWidget extends StatelessWidget {
  const ReportCircleChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Top Sale',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        size: 20,
                      )),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 30,
                        color: Colors.blue,
                        title: '30%',
                        radius: 80, // Adjusted radius
                        titleStyle: TextStyle(
                          fontSize: 14, // Adjusted font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Colors.red,
                        title: '20%',
                        radius: 80, // Adjusted radius
                        titleStyle: TextStyle(
                          fontSize: 14, // Adjusted font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 25,
                        color: Colors.green,
                        title: '25%',
                        radius: 80, // Adjusted radius
                        titleStyle: TextStyle(
                          fontSize: 14, // Adjusted font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 25,
                        color: Colors.orange,
                        title: '25%',
                        radius: 80, // Adjusted radius
                        titleStyle: TextStyle(
                          fontSize: 14, // Adjusted font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 0, // Adjusted center space radius
                    sectionsSpace: 0, // No space between sections
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Chip before first text
                  Container(
                    width: 12, // Width of the chip
                    height: 12, // Height of the chip
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // Color of the chip
                    ),
                  ),
                  SizedBox(width: 8), // Space between chip and text
                  Text(
                    'ឆាក្តៅសាច់មាន់',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(width: 8),

                  // Chip before second text
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'អាម៉ុក',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(width: 8),

                  // Chip before third text
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'មាន់ដុត',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(width: 8),

                  // Chip before fourth text
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Angkor beer',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
