import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_system/program.dart';
import 'dart:convert';

import '../models/api/product_model.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;

  // @override
  // void onInit() {
  //   // Fetch products when controller initializes
  //   fetchProducts();
  //   super.onInit();
  // }

  // Future<void> fetchProducts() async {
  //   try {
  //     var response =
  //         await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body) as List;
  //       List<Product> products =
  //           jsonData.map((json) => Product.fromJson(json)).toList();
  //       productList.assignAll(products);
  //       print(jsonData); // Print JSON data here
  //     } else {
  //       throw Exception('Failed to load products');
  //     }
  //   } catch (e) {
  //     Program.error('Program', 'Error');
  //   }
  // }

  // List to hold Product objects
  var products = <Product>[].obs;

  // Method to add fake data
  void addFakeProducts() {
    products.addAll([
      Product(
        productName: 'Burger',
        cost: 5.0,
        price: 8.0,
        category: 'Food',
        createdBy: 'Admin',
        action: 'Edit/Delete',
      ),
      Product(
        productName: 'Pizza',
        cost: 7.0,
        price: 10.0,
        category: 'Food',
        createdBy: 'Admin',
        action: 'Edit/Delete',
      ),
      Product(
        productName: 'Coffee',
        cost: 2.0,
        price: 4.0,
        category: 'Beverage',
        createdBy: 'Admin',
        action: 'Edit/Delete',
      ),
      Product(
        productName: 'Salad',
        cost: 3.0,
        price: 6.0,
        category: 'Food',
        createdBy: 'Admin',
        action: 'Edit/Delete',
      ),
      Product(
        productName: 'Juice',
        cost: 2.5,
        price: 5.0,
        category: 'Beverage',
        createdBy: 'Admin',
        action: 'Edit/Delete',
      ),
    ]);
  }

  @override
  void onInit() {
    super.onInit();
    // Add fake products when the controller is initialized
    addFakeProducts();
  }
  void onAddNewProductPressed() {
    Get.dialog(
      Dialog(
        child: Container(
          height: 600,
          width: 500,
          color: Colors.white,
          child: Expanded(
              child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Add New Product',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.white,
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
