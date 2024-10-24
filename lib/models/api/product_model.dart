import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String price;
  final String image;
  final bool stockable;
  final int categoryId;
  final String? categoryName; // Add category name
  final String? createdAt;
  final String? updatedAt;
  final String? createDate;
  final String createBy;
  final bool isDeleted;
  final String? deletedDate;
  final String? deletedBy;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.stockable,
    required this.categoryId,
    this.categoryName, // Initialize category name
    this.createdAt,
    this.updatedAt,
    this.createDate,
    required this.createBy,
    required this.isDeleted,
    this.deletedDate,
    this.deletedBy,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      stockable: json['stockable'] == 1,
      categoryId: json['category_id'],
      categoryName: json['category_name'], // Extract category name from JSON
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      createDate: json['create_date'],
      createBy: json['create_by'],
      isDeleted: json['is_deleted'] == 1,
      deletedDate: json['deleted_date'],
      deletedBy: json['deleted_by'],
    );
  }

  // Convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'stockable': stockable ? 1 : 0,
      'category_id': categoryId,
      'category_name': categoryName, // Include category name in JSON
      'created_at': createdAt,
      'updated_at': updatedAt,
      'create_date': createDate,
      'create_by': createBy,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_date': deletedDate,
      'deleted_by': deletedBy,
    };
  }
}
