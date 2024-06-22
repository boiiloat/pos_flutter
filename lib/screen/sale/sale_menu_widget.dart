import 'package:flutter/material.dart';
import 'package:pos_system/constans/constan.dart';

import 'sale_menu_shot_cut_widget.dart';

class SaleMenuScreen extends StatelessWidget {
  const SaleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back,
            color: arrowback,
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          SaleMenuShotCutWidget(),
                          Container(
                            height: 40,
                            width: 50,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/bg_image.jpg',
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
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
