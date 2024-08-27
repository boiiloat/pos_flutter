import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/sale_controller.dart';
import 'package:pos_system/program.dart';

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
                                              'http://127.0.0.1:8000${product.image}',
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
                  child: Container(
                    color: Colors.grey
                        .shade200, // Background color for the full expanded area
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.grey
                            .shade200, // Background color for the container
                        child: Column(
                          children: [
                            // const SizedBox(height: 15),
                            // Icon(
                            //   Icons.shopping_cart_outlined,
                            //   color: Colors.grey.shade400,
                            //   size: 50,
                            // ),
                            // const SizedBox(height: 5),
                            // Text(
                            //   "Data is empty",
                            //   style: TextStyle(
                            //     fontStyle: FontStyle.italic,
                            //     color: Colors.grey.shade500,
                            //     fontSize: 10,
                            //   ),
                            // )
                            SaleWidget(
                              imageUrl: 'assets/images/1.jpg',
                              qty: '1',
                              productnam: 'ណែម',
                              price: '1.00',
                            ),
                            SaleWidget(
                              imageUrl: 'assets/images/2.jpg',
                              qty: '2',
                              productnam: 'ឆាត្រប់',
                              price: '2.00',
                            ),
                            SaleWidget(
                              imageUrl: 'assets/images/3.jpg',
                              qty: '3',
                              productnam: 'ប្រហុកខ្ទឹមស',
                              price: '4.50',
                            ),
                            SaleWidget(
                              imageUrl: 'assets/images/8.webp',
                              qty: '1',
                              productnam: 'ស្ទេកសាច់គោខ្មែរ',
                              price: '1.50',
                            ),

                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     color: Colors.white,
                //     child: Row(
                //       children: [
                //         Expanded(
                //           flex: 7,
                //           child: InkWell(
                //             onTap: controller.onPaymentPressed,
                //             child: Container(
                //               color: Colors.green,
                //               child: const Column(
                //                 children: [
                //                   Padding(
                //                     padding: EdgeInsets.only(
                //                         left: 10.0, right: 5, top: 2),
                //                     child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Text(
                //                           'Payment',
                //                           style: TextStyle(color: Colors.white),
                //                         ),
                //                         Text(
                //                           '\$ 9.00',
                //                           style: TextStyle(
                //                             fontSize: 20,
                //                             color: Colors.white,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                   Padding(
                //                     padding: EdgeInsets.only(left: 10.0),
                //                     child: Row(
                //                       children: [
                //                         Text(
                //                           'Total quantity : 7',
                //                           style: TextStyle(
                //                               fontSize: 10, color: Colors.white),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Expanded(
                //           flex: 3,
                //           child: InkWell(
                //             onTap: () {
                //               Program.alert("title", "description");
                //             },
                //             child: Container(
                //               color: Colors.blue,
                //               child: const Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Icon(
                //                     Icons.arrow_forward,
                //                     size: 15,
                //                     color: Colors.white,
                //                   ),
                //                   Text(
                //                     'Submit Order',
                //                     style: TextStyle(
                //                         color: Colors.white, fontSize: 13),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
