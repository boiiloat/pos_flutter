// models/api/category_model.dart

class Product {
  final int id;
  final String name;

  Product({
    required this.id,
    required this.name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Category {
  final int id;
  final String name;
  final String createdDate;
  final String createdBy;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.createdBy,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List<dynamic>? ?? [];
    List<Product> productsList =
        productsJson.map((p) => Product.fromJson(p)).toList();

    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      createdDate: json['created_date'] ?? '',
      createdBy: json['created_by'] ?? '',
      products: productsList,
    );
  }
}
