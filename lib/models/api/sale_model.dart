// lib/models/api/sale_model.dart
class Sale {
  final int id;
  final String invoiceNumber;
  final double subTotal;
  final double tax;
  final double discount;
  final double grandTotal;
  final bool isPaid;
  final String status;
  final int? tableId;
  final String createdAt;
  final int createdBy;

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.subTotal,
    required this.tax,
    required this.discount,
    required this.grandTotal,
    required this.isPaid,
    required this.status,
    this.tableId,
    required this.createdAt,
    required this.createdBy,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      subTotal: json['sub_total']?.toDouble() ?? 0,
      tax: json['tax']?.toDouble() ?? 0,
      discount: json['discount']?.toDouble() ?? 0,
      grandTotal: json['grand_total']?.toDouble() ?? 0,
      isPaid: json['is_paid'] ?? false,
      status: json['status'] ?? 'pending',
      tableId: json['table_id'],
      createdAt: json['created_at'] ?? '',
      createdBy: json['created_by'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'sub_total': subTotal,
      'tax': tax,
      'discount': discount,
      'grand_total': grandTotal,
      'is_paid': isPaid,
      'status': status,
      'table_id': tableId,
      'created_at': createdAt,
      'created_by': createdBy,
    };
  }
}