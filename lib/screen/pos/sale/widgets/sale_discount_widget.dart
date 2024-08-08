import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/discount_controller.dart';

class SaleDiscountWidget extends StatelessWidget {
  const SaleDiscountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DiscountController discountController = Get.put(DiscountController());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.red,
            child: Center(
              child: Text(
                'Discount Item',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => discountController.selectPercentage(),
                    child: Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: discountController.isPercentageSelected.value
                                ? Colors.red.shade900
                                : Colors.red.shade100,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Discount By (%)",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => discountController.selectAmount(),
                    child: Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                !discountController.isPercentageSelected.value
                                    ? Colors.red.shade900
                                    : Colors.red.shade100,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Discount By (\$)",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Obx(() {
            return Center(
              child: discountController.isPercentageSelected.value
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                style: TextStyle(
                                  color:
                                      Colors.black, // Set the text color here
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .red), // Color when not focused
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.red), // Color when focused
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  prefixIcon: Icon(Icons.percent_outlined,
                                      color: Colors.red),
                                  hintText: 'Discount Percent',
                                  hintStyle: TextStyle(
                                      color: Colors.red), // Hint text color
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 40),
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Accpet',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                style: TextStyle(
                                  color: Colors
                                      .black, // Set the input text color here
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .red), // Border color when not focused
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .red), // Border color when focused
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  prefixIcon: Icon(Icons.monetization_on,
                                      color: Colors.red),
                                  hintText: 'Discount Amount',
                                  hintStyle: TextStyle(
                                      color: Colors.red), // Hint text color
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 40),
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Accpet',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            );
          }),
        )
      ],
    );
  }
}
