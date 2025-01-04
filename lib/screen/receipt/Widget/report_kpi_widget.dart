import 'package:flutter/material.dart';

class ReceiptKpiWidget extends StatelessWidget {
  final String label;
  final String value;
  final Icon icon;
  final Color color;
  const ReceiptKpiWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 330,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5), // Apply radius here
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                color: Colors.white,
                child: Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Current Day',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 2),
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: color,
                                ),
                                child: Center(
                                  child: Icon(
                                    icon.icon,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: color,
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
