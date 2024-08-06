import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sale_item_note_widget.dart';
import 'sale_product_widget.dart';
import 'testing.dart';

class BodySaleMenuWidget extends StatelessWidget {
  const BodySaleMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: List.generate(
                          20,
                          (index) => const SaleItemNoteWidget(
                            label: 'Khmer food',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                  100, // fixed number of items
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SaleProductWidget(
                                      imageUrl:
                                          'assets/images/khmer_food.webp', // example fixed image URL
                                      productPrice:
                                          '\$${(index + 1) * 10}', // example fixed price
                                      productName:
                                          'Product $index', // example fixed name
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        size: 20,
                                      ),
                                      SizedBox(width: 3),
                                      Text('Go back'),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Hold bill',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.blue.shade100,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Table # :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' T03'),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                      fuck(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          color: Colors.green,
                          child: const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '65000\$',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Total quantity : 10',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            color: Colors.blue,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
