import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/product_controller.dart';

class Testing extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Obx(
        () {
          if (controller.products.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return ListTile(
                leading: Image.network(
                  'http://127.0.0.1:8000${product.image}',
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text('Price: \$${product.price}'),
              );
            },
          );
        },
      ),
    );
  }
}
