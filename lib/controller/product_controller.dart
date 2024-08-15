import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/product/Widgets/product_add_new.widget.dart';
import 'dart:convert';

import '../models/api/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;

  @override
  void onInit() {
    // Add some sample data to the products list
    products.addAll([
      Product(
        productImage: 'assets/images/1.jpg',
        productName: 'ណែម',
        cost: 50.0,
        price: 75.0,
        category: 'Asia',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/2.jpg',
        productName: 'ឆាត្រប់',
        cost: 30.0,
        price: 50.0,
        category: 'Asia',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/3.jpg',
        productName: 'ប្រហុកខ្ទឹមស',
        cost: 30.0,
        price: 50.0,
        category: 'Asia',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/4.jpg',
        productName: 'អាម៉ុក',
        cost: 30.0,
        price: 50.0,
        category: 'Asia',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/5.jpg',
        productName: 'ឆាជូអែម',
        cost: 30.0,
        price: 50.0,
        category: 'Asia',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/6.jpg',
        productName: 'ពងទាត្រីប្រម៉ា',
        cost: 30.0,
        price: 50.0,
        category: 'Asia',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/7.jpg',
        productName: 'ឆាឡុកឡាក់',
        cost: 30.0,
        price: 50.0,
        category: 'Asia',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/8.jpg',
        productName: 'Product 2',
        cost: 30.0,
        price: 50.0,
        category: 'Category 2',
        createdBy: 'Admin',
      ),
      Product(
        productImage: 'assets/images/9.jpg',
        productName: 'Product 2',
        cost: 30.0,
        price: 50.0,
        category: 'Category 2',
        createdBy: 'Admin',
      ),
    ]);
    super.onInit();
  }

  // Getter for products
  List<Product> get getProducts => products;

  void onAddNewProductPressed() {
    Get.dialog(
      Dialog(
        child: ProductAddNewWidget()
      ),
    );
  }
}
