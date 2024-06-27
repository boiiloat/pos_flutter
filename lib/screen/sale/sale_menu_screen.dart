import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';

import '../../controller/sale_controller.dart';
import 'widgets/menu_item_widget.dart';
import 'widgets/sale_buttom_action_widget.dart';
import 'widgets/sale_item_note_widget.dart';
import 'widgets/sale_product_widget.dart';

class SaleMenuScreen extends StatelessWidget {
  const SaleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SaleController());

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('POS', style: TextStyle(color: arrowback)),
      //   backgroundColor: appColor,
      //   leading: IconButton(
      //     onPressed: controller.onBackPressed,
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: arrowback,
      //     ),
      //   ),
      // ),
      body: Row(
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
                            5,
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
                        // Expanded(
                        //   flex: 8,
                        //   child: Container(
                        //     child: SingleChildScrollView(
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Row(
                        //           crossAxisAlignment:
                        //               CrossAxisAlignment.stretch,
                        //           children: [
                        //             Container(
                        //               height: 50,
                        //               width: 160,
                        //               color: Colors.orange,
                        //             )
                        //             // MenuItemWidget(),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          flex: 9,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Wrap(
                                  children: List.generate(
                                    100,
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SaleProductWidget(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SaleButtomActionWidget(
                                    color: Colors.green,
                                    icon: Icon(Icons.arrow_back),
                                    label: 'Back',
                                  ),
                                ),
                                Row(
                                  children: [
                                    SaleButtomActionWidget(
                                      color: Colors.red,
                                      icon: Icon(Icons.cancel),
                                      label: 'CANCEL BILL',
                                    ),
                                    SaleButtomActionWidget(
                                      color: Colors.blue,
                                      icon: Icon(Icons.print),
                                      label: 'PRINT BILL',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
