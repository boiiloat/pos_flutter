class Expense {
  final int id;
  final String referenceNumber;
  final String description;
  final double amount;
  final int paymentMethodId;
  final String? paymentMethodName;
  final int createdBy;
  final String? createdByName;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Expense({
    required this.id,
    required this.referenceNumber,
    required this.description,
    required this.amount,
    required this.paymentMethodId,
    this.paymentMethodName,
    required this.createdBy,
    this.createdByName,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? 0,
      referenceNumber: json['reference_number'] ?? '',
      description: json['description'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      paymentMethodId: json['payment_method_id'] ?? 0,
      paymentMethodName: json['payment_method'] != null
          ? json['payment_method']['payment_method_name']
          : null,
      createdBy: json['created_by'] is Map
          ? (json['created_by']['id'] ?? 0)
          : (json['created_by'] ?? 0),
      createdByName:
          json['created_by'] is Map ? json['created_by']['fullname'] : null,
      note: json['note'],
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      'payment_method_id': paymentMethodId,
      'note': note,
    };
  }
}
