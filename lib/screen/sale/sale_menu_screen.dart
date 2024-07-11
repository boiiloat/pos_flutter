import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/product_controller.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import 'package:pos_system/screen/sale/widgets/testing.dart';
import '../../controller/sale_controller.dart';
import '../../testing.dart';
import 'widgets/menu_item_widget.dart';
import 'widgets/sale_buttom_action_widget.dart';
import 'widgets/sale_item_note_widget.dart';
import 'widgets/sale_product_widget.dart';

class SaleMenuScreen extends StatelessWidget {
  const SaleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    // var controller = Get.put(SaleController());
    // var controller = Get.put(ProductController);
    return Scaffold(
      // body: Center(
      //   child: GetX<ProductController>(
      //     builder: (controller) {
      //       if (controller.productList.isEmpty) {
      //         return CircularProgressIndicator();
      //       }
      //       return ListView.builder(
      //         itemCount: controller.productList.length,
      //         itemBuilder: (context, index) {
      //           var product = controller.productList[index];
      //           return ListTile(
      //             title: Text(product.name),
      //             subtitle: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text('Price: ${product.price.toString()}'),
      //                 Text('Image: ${product.image}'),
      //                 Text('Stockable: ${product.stockable ? 'Yes' : 'No'}'),
      //                 Text('Category ID: ${product.categoryId}'),
      //                 Text('Created Date: ${product.createDate.toString()}'),
      //                 Text('Created By: ${product.createBy}'),
      //                 Text('Is Deleted: ${product.isDeleted ? 'Yes' : 'No'}'),
      //                 if (product.deletedDate != null)
      //                   Text(
      //                       'Deleted Date: ${product.deletedDate!.toString()}'),
      //                 if (product.deletedBy != null)
      //                   Text('Deleted By: ${product.deletedBy}'),
      //               ],
      //             ),
      //             // You can add more fields as needed
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),

      body: Obx(
        () => Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(const HomeScreen());
                              },
                              icon: const Icon(
                                Icons.home,
                                size: 25,
                                color: Colors.white,
                              )),
                          const Text(
                            'ePOS',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'T04',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade400),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        '23/05/2024   10 : 11 PM',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: Row(
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
                                            controller.productList.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SaleProductWidget(
                                                imageUrl: controller
                                                    .productList[index].image,
                                                productPrice: controller
                                                    .productList[index].price
                                                    .toString(),
                                                productName: controller
                                                    .productList[index].name,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Hold bill',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Payment',
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                                    fontSize: 10,
                                                    color: Colors.white),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
