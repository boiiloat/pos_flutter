import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/api/product_model.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;

  @override
  void onInit() {
    // Fetch products when controller initializes
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      var response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as List;
        List<Product> products =
            jsonData.map((json) => Product.fromJson(json)).toList();
        productList.assignAll(products); // Print JSON data here
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
