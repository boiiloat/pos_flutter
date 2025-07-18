class Sale {
  final int id;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final bool isPaid;
  final String status;
  final DateTime saleDate;
  final int createdBy;
  final String invoiceNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> products;
  final int? tableId;

  Sale({
    required this.id,
    required this.subTotal,
    required this.discount,
    required this.grandTotal,
    required this.isPaid,
    required this.status,
    required this.saleDate,
    required this.createdBy,
    required this.invoiceNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
    this.tableId,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    // Debug print if table_id is missing
    if (json['table_id'] == null) {
      print('Warning: Sale created without table association');
    }
    return Sale(
      id: json['id'] as int,
      subTotal: (json['sub_total'] is String)
          ? double.parse(json['sub_total'])
          : (json['sub_total'] as num).toDouble(),
      discount: (json['discount'] is String)
          ? double.parse(json['discount'])
          : (json['discount'] as num).toDouble(),
      grandTotal: (json['grand_total'] is String)
          ? double.parse(json['grand_total'])
          : (json['grand_total'] as num).toDouble(),
      isPaid: json['is_paid'] as bool,
      status: json['status'] as String,
      saleDate: DateTime.parse(json['sale_date'] as String),
      createdBy: json['created_by'] as int,
      invoiceNumber: json['invoice_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      products: json['products'] != null
          ? (json['products'] as List)
              .map((p) => {
                    'product_name': p['product_name'] ?? 'Unknown',
                    'quantity': p['quantity'],
                    'price': (p['price'] is String)
                        ? double.parse(p['price'])
                        : (p['price'] as num).toDouble(),
                  })
              .toList()
          : [],
      tableId: json['table_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sub_total': subTotal,
        'discount': discount,
        'grand_total': grandTotal,
        'is_paid': isPaid,
        'status': status,
        'sale_date': saleDate.toIso8601String(),
        'created_by': createdBy,
        'invoice_number': invoiceNumber,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'products': products,
        'table_id': tableId,
      };
}
