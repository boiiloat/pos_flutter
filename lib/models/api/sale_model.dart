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
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] as int,
      subTotal: (json['sub_total'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      grandTotal: (json['grand_total'] as num).toDouble(),
      isPaid: json['is_paid'] as bool,
      status: json['status'] as String,
      saleDate: DateTime.parse(json['sale_date']),
      createdBy: json['created_by'] as int,
      invoiceNumber: json['invoice_number'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      products: json['products'] as List<dynamic>,
    );
  }
}
