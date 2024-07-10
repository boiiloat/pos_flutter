class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final bool stockable;
  final int categoryId;
  final DateTime createDate;
  final int createBy;
  final bool isDeleted;
  final DateTime? deletedDate;
  final int? deletedBy;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.stockable,
    required this.categoryId,
    required this.createDate,
    required this.createBy,
    required this.isDeleted,
    this.deletedDate,
    this.deletedBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price:
          json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      image: json['image'] ?? '',
      stockable: json['stockable'] == 1, // Convert int to bool
      categoryId: json['category_id'] ?? 0,
      createDate: DateTime.parse(json['create_date'] ?? ''),
      createBy: json['create_by'] ?? 0,
      isDeleted: json['is_deleted'] == 1, // Convert int to bool
      deletedDate: json['deleted_date'] != null
          ? DateTime.parse(json['deleted_date'])
          : null,
      deletedBy: json['deleted_by'] ?? null,
    );
  }
}
