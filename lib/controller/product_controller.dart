import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/api/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        products.value = data.map((json) => Product.fromJson(json)).toList();
   
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Handle error
      print('Error fetching products: $e');
    }
  }
}
