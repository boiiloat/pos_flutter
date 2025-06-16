class SalePayment {
  final String id;  // Changed from int to String
  final double paymentAmount;
  final double exchangeRate;
  final String paymentMethodName;
  final String saleId;  // Changed from int to String
  final String paymentMethodId;  // Changed from int to String
  final DateTime createdDay;
  final String createdBy;

  SalePayment({
    required this.id,
    required this.paymentAmount,
    required this.exchangeRate,
    required this.paymentMethodName,
    required this.saleId,
    required this.paymentMethodId,
    required this.createdDay,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_amount': paymentAmount,
      'exchange_rate': exchangeRate,
      'payment_method_name': paymentMethodName,
      'sale_id': saleId,
      'payment_method_id': paymentMethodId,
      'created_day': createdDay.toIso8601String(),
      'created_by': createdBy,
    };
  }
}