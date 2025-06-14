
class SaleProduct {
  final int id;
  final int saleId;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final bool isFree;
  final String? image;
  final String createdAt;
  final int createdBy;

  SaleProduct({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.isFree,
    this.image,
    required this.createdAt,
    required this.createdBy,
  });

  factory SaleProduct.fromJson(Map<String, dynamic> json) {
    return SaleProduct(
      id: _safeParseInt(json['id']),
      saleId: _safeParseInt(json['sale_id']),
      productId: _safeParseInt(json['product_id']),
      productName: _safeParseStringNonNull(json['product_name']),
      price: _safeParseDouble(json['price']),
      quantity: _safeParseInt(json['quantity']) == 0 ? 1 : _safeParseInt(json['quantity']),
      isFree: json['is_free'] == true || json['is_free'] == 1,
      image: _safeParseString(json['image']),
      createdAt: _safeParseStringNonNull(json['created_at']) != '' 
          ? _safeParseStringNonNull(json['created_at']) 
          : DateTime.now().toIso8601String(),
      createdBy: _safeParseInt(json['created_by']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'is_free': isFree,
      'image': image,
      'created_at': createdAt,
      'created_by': createdBy,
    };
  }

  // Added copyWith method for SaleProduct
  SaleProduct copyWith({
    int? id,
    int? saleId,
    int? productId,
    String? productName,
    double? price,
    int? quantity,
    bool? isFree,
    String? image,
    String? createdAt,
    int? createdBy,
  }) {
    return SaleProduct(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isFree: isFree ?? this.isFree,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // Helper methods for SaleProduct
  static int _safeParseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String? _safeParseString(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isEmpty) return null;
    return value.toString();
  }

  static String _safeParseStringNonNull(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Utility getters
  double get totalPrice => isFree ? 0.0 : price * quantity;
  String get displayTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';
  String get displayUnitPrice => '\$${price.toStringAsFixed(2)}';
  bool get hasImage => image != null && image!.isNotEmpty;
  
  // Validation methods
  bool get isValid => productId > 0 && quantity > 0 && price >= 0;
}