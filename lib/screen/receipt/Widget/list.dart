import '../../../models/api/receipt_model.dart';

final List<Receipt> receipts = [
  Receipt(
    invoiceNumber: '0001',
    tableNumber: 'Table 1',
    dateTime: '2024-08-10 12:00 PM',
    totalAmount: 150.00,
    discount: 10.00,
    grandTotal: 140.00,
    status: 'Completed',
  ),
  Receipt(
    invoiceNumber: '0002',
    tableNumber: 'Table 2',
    dateTime: '2024-08-10 01:00 PM',
    totalAmount: 200.00,
    discount: 20.00,
    grandTotal: 180.00,
    status: 'Pending',
  ),
  // Add more sample receipts as needed
];
