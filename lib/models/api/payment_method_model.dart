class PaymentMethod {
  final String id; // e.g., '1', '2'
  final String paymentMethodName;
  final DateTime? createdDate;
  final String? createdBy;
  final bool? isDeleted;
  final DateTime? deletedDate;
  final String? deletedBy;

  PaymentMethod({
    required this.id,
    required this.paymentMethodName,
    this.createdDate,
    this.createdBy,
    this.isDeleted,
    this.deletedDate,
    this.deletedBy,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id']?.toString() ?? '',
      paymentMethodName: json['payment_method_name']?.toString() ?? '',
      createdDate: _parseDateTime(json['created_date']),
      createdBy: json['created_by']?['fullname']?.toString(),
      isDeleted: _parseBool(json['is_deleted']),
      deletedDate: _parseDateTime(json['deleted_date']),
      deletedBy: json['deleted_by']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_method_name': paymentMethodName,
      'created_date': createdDate?.toIso8601String(),
      'created_by': createdBy,
      'is_deleted': isDeleted,
      'deleted_date': deletedDate?.toIso8601String(),
      'deleted_by': deletedBy,
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return null;
  }

  @override
  String toString() => 'PaymentMethod($paymentMethodName)';
}
