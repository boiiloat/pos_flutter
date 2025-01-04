import 'package:flutter/material.dart';
import '../../../../models/api/receipt_model.dart';
import '../../../receipt/Widget/report_kpi_widget.dart';

class ReportTotalReceiptWidget extends StatelessWidget {
  ReportTotalReceiptWidget({super.key});

  final List<Receipt> receipts = [
    Receipt(
      invoiceNumber: 'INV24-0001',
      tableNumber: 'Table 5',
      dateTime: '2024-08-10',
      totalAmount: 22.00,
      discount: 0.00,
      grandTotal: 22.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0002',
      tableNumber: 'Table 2',
      dateTime: '2024-08-10',
      totalAmount: 12.00,
      discount: 0.00,
      grandTotal: 12.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0003',
      tableNumber: 'Table 7',
      dateTime: '2024-08-10',
      totalAmount: 15.00,
      discount: 2.00,
      grandTotal: 13.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0004',
      tableNumber: 'Table 9',
      dateTime: '2024-08-10',
      totalAmount: 9.00,
      discount: 0.00,
      grandTotal: 9.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0005',
      tableNumber: 'Table 11',
      dateTime: '2024-08-10',
      totalAmount: 18.00,
      discount: 0.00,
      grandTotal: 18.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0006',
      tableNumber: 'Table 8',
      dateTime: '2024-08-10',
      totalAmount: 5.00,
      discount: 1.00,
      grandTotal: 4.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0007',
      tableNumber: 'Table 15',
      dateTime: '2024-08-10',
      totalAmount: 200.00,
      discount: 20.00,
      grandTotal: 180.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0008',
      tableNumber: 'Table 20',
      dateTime: '2024-08-10',
      totalAmount: 13.00,
      discount: 2.00,
      grandTotal: 11.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0009',
      tableNumber: 'Table 15',
      dateTime: '2024-08-10',
      totalAmount: 200.00,
      discount: 20.00,
      grandTotal: 180.00,
      status: 'Paid',
    ),
    Receipt(
      invoiceNumber: 'INV24-0010',
      tableNumber: 'Table 3',
      dateTime: '2024-08-10',
      totalAmount: 200.00,
      discount: 20.00,
      grandTotal: 180.00,
      status: 'Paid',
    ),
    // Add more receipts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    'Total Invoice',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                    child: const Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text('Invoice No',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child: Text('Table Number',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child: Text('Date & Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child: Text('Sub Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child: Text('Discount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child: Text('Grand Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child: Text('Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)))),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: receipts.length,
                  itemBuilder: (context, index) {
                    final receipt = receipts[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text(
                            receipt.invoiceNumber,
                            style: const TextStyle(fontSize: 12),
                          ))),
                          Expanded(
                              child: Center(
                                  child: Text(
                            receipt.tableNumber,
                            style: const TextStyle(fontSize: 12),
                          ))),
                          Expanded(
                              child: Center(
                                  child: Text(
                            receipt.dateTime,
                            style: const TextStyle(fontSize: 12),
                          ))),
                          Expanded(
                              child: Center(
                                  child: Text(
                            '\$${receipt.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ))),
                          Expanded(
                              child: Center(
                                  child: Text(
                            '\$${receipt.discount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ))),
                          Expanded(
                              child: Center(
                                  child: Text(
                            '\$${receipt.grandTotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ))),
                          Expanded(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 3, 15, 3),
                                  child: Text(
                                    receipt.status,
                                    style: TextStyle(
                                      color: receipt.status == 'Paid'
                                          ? Colors.white
                                          : Colors.red,
                                      fontSize: 10,
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
        ),
      ),
    );
  }
}
