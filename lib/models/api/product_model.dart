class Product {
  final int id;
  final String name;
  final double price;
  final String? image;
  final int categoryId;
  final String? categoryName;
  final String? creatorName;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? createdBy;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    required this.categoryId,
    this.categoryName,
    this.creatorName,
    this.createdDate,
    this.updatedDate,
    this.createdBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _safeParseInt(json['id']),
      name: _safeParseString(json['name']),
      price: _safeParseDouble(json['price']),
      image: _safeParseString(json['image']),
      categoryId: json['category'] != null 
          ? _safeParseInt(json['category']['id'])
          : _safeParseInt(json['category_id']),
      categoryName: json['category'] != null
          ? _safeParseString(json['category']['name'])
          : _safeParseString(json['category_name']),
      creatorName: _safeParseString(json['creator_name']),
      createdDate: _safeParseDateTime(json['created_at']),
      updatedDate: _safeParseDateTime(json['updated_at']),
      createdBy: _safeParseString(json['created_by']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image': image,
        'category_id': categoryId,
        'category_name': categoryName,
        'creator_name': creatorName,
        'created_at': createdDate?.toIso8601String(),
        'updated_at': updatedDate?.toIso8601String(),
        'created_by': createdBy,
      };

  // Helper methods
  static int _safeParseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String _safeParseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime? _safeParseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}