class InvoiceItem {
  final String description;
  final int quantity;
  final double price;
  final String discount;
  final String amount;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.amount,
  });
}

class Invoice {
  final String cashier;
  final String invoiceNumber;
  final DateTime date;
  final List<InvoiceItem> items;
  final double totalUsd;
  final double totalRiel;
  final double discount;
  final double grandTotalUsd;
  final double grandTotalRiel;

  Invoice({
    required this.cashier,
    required this.invoiceNumber,
    required this.date,
    required this.items,
    required this.totalUsd,
    required this.totalRiel,
    required this.discount,
    required this.grandTotalUsd,
    required this.grandTotalRiel,
  });
}
