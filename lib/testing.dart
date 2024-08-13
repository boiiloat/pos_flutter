import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/invoice_controller.dart';

class InvoiceScreen extends StatelessWidget {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Obx(() {
          final invoice = invoiceController.invoice.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'INVOICE',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('Table # : T02'),
                              Text('Cashier: Admin'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      Text('Invoice#: ${invoice.invoiceNumber}'),
                      Text('Date: ${invoice.date}'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Nº',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        flex: 3,
                        child: Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                        child: Text('Qty',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    Expanded(
                        child: Text('Price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right)),
                    Expanded(
                        child: Text('Discount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    Expanded(
                        child: Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey),
              ...invoice.items.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('${index + 1}',
                              textAlign: TextAlign.center)),
                      Expanded(
                          flex: 3,
                          child: Text(
                            item.description,
                            style: TextStyle(fontFamily: 'Khmer'),
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                          child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                          child: Text(
                        '\$ ${item.price.toStringAsFixed(2)}',
                        textAlign: TextAlign.end,
                      )),
                      Expanded(
                          child: Text(
                        '-',
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                          child: Text(
                        '\ ${item.amount}',
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                );
              }).toList(),
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text('Discount',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 50),
                          Text('\$ 0.00', textAlign: TextAlign.right),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Sub Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 50),
                          Text('\$ 15.00', textAlign: TextAlign.right),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Grand Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 50),
                          Text('\$ 15.00', textAlign: TextAlign.right),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Payment Type',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(width: 30),
                          Text(
                            'ABA Dollar',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
