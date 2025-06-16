import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/sale_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/pos/sale/widgets/sale_order_widget.dart';

import '../../../../controller/product_controller.dart';
import 'sale_item_note_widget.dart';
import 'sale_product_widget.dart';
import 'sale_widget.dart';

class BodySaleMenuWidget extends StatelessWidget {
  const BodySaleMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(SaleController());
    final controller = Get.put(ProductController());

    return Obx(
      () => Row(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(children: [
                          SaleItemNoteWidget(
                            label: 'Desert',
                          ),
                          SaleItemNoteWidget(
                            label: 'Mian Course',
                          ),
                          SaleItemNoteWidget(
                            label: 'Smothie',
                          ),
                          SaleItemNoteWidget(
                            label: 'Frappe',
                          ),
                          SaleItemNoteWidget(
                            label: 'Soda',
                          ),
                          SaleItemNoteWidget(
                            label: 'Asia',
                          ),
                        ]),
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
                          flex: 17,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Wrap(
                                  children: controller.products.map((product) {
                                    return Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          // Print the product details when tapped
                                          print(
                                              'Product Clicked: ${product.name}');
                                          print('Price: \$${product.price}');
                                          print('Image: ${product.image}');
                                        },
                                        child: SaleProductWidget(
                                          imageUrl:
                                              'http://localhost:8000${product.image}',
                                          productPrice: '\$${product.price}',
                                          productName: product.name,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_rounded,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Go back'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Hold bill',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
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
                  color: const Color.fromARGB(255, 212, 229, 245),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Table # :',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(' T04'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: SaleOrderWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
