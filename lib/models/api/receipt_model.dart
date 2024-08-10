class Receipt {
  final String invoiceNumber;
  final String tableNumber;
  final String dateTime;
  final double totalAmount;
  final double discount;
  final double grandTotal;
  final String status;

  Receipt({
    required this.invoiceNumber,
    required this.tableNumber,
    required this.dateTime,
    required this.totalAmount,
    required this.discount,
    required this.grandTotal,
    required this.status,
  });
}
