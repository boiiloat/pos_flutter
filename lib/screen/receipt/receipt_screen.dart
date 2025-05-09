import 'package:flutter/material.dart';
import 'package:pos_system/models/api/receipt_model.dart';

class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({super.key});

  final List<Receipt> receipts = [
    Receipt(
      invoiceNumber: 'INV24-0001',
      tableNumber: 'Table 5',
      dateTime: '2024-08-10 12:00 PM',
      totalAmount: 22.00,
      discount: 0.00,
      grandTotal: 22.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0002',
      tableNumber: 'Table 2',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 12.00,
      discount: 0.00,
      grandTotal: 12.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0003',
      tableNumber: 'Table 7',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 15.00,
      discount: 2.00,
      grandTotal: 13.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0004',
      tableNumber: 'Table 9',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 9.00,
      discount: 0.00,
      grandTotal: 9.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0005',
      tableNumber: 'Table 11',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 18.00,
      discount: 0.00,
      grandTotal: 18.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0006',
      tableNumber: 'Table 8',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 5.00,
      discount: 1.00,
      grandTotal: 4.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0007',
      tableNumber: 'Table 15',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 20.00,
      discount: 20.00,
      grandTotal: 180.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0008',
      tableNumber: 'Table 20',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 13.00,
      discount: 20.00,
      grandTotal: 180.00,
      status: 'Paid',
    ),

    Receipt(
      invoiceNumber: 'INV24-0009',
      tableNumber: 'Table 15',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 200.00,
      discount: 20.00,
      grandTotal: 180.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: '00010',
      tableNumber: 'Table 3',
      dateTime: '2024-08-10 01:00 PM',
      totalAmount: 200.00,
      discount: 20.00,
      grandTotal: 180.00,
      status: 'Paid',
    ),
    // Add more receipts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Invoice No',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: Text('Table Number',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text('Date & Time',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text('Sub Total',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text('Discount',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text('Grand Total',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text('Status',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: receipts.length,
              itemBuilder: (context, index) {
                final receipt = receipts[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(child: Text(receipt.invoiceNumber))),
                      Expanded(child: Center(child: Text(receipt.tableNumber))),
                      Expanded(child: Center(child: Text(receipt.dateTime))),
                      Expanded(
                          child: Center(
                              child: Text(
                                  '\$ ${receipt.totalAmount.toStringAsFixed(2)}'))),
                      Expanded(
                          child: Center(
                              child: Text(
                                  '\$ ${receipt.discount.toStringAsFixed(2)}'))),
                      Expanded(
                          child: Center(
                              child: Text(
                                  '\$ ${receipt.grandTotal.toStringAsFixed(2)}'))),
                      Expanded(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                              child: Text(
                                receipt.status,
                                style: TextStyle(
                                  color: receipt.status == 'Paid'
                                      ? Colors.white
                                      : Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
