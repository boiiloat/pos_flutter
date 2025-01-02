import 'package:get/get.dart';
import 'package:pos_system/models/api/invoice_item_model.dart';

class InvoiceController extends GetxController {
  var invoice = Invoice(
    cashier: 'Leam loat',
    invoiceNumber: 'INV-24-00002',
    date: DateTime.parse('2024-08-09 20:24:27'),
    items: [
      InvoiceItem(
          description: 'ណែម',
          quantity: 1,
          price: 1.5,
          discount: '',
          amount: 'Free'),
      InvoiceItem(
          description: 'ឆាត្រប់',
          quantity: 1,
          price: 1.5,
          discount: '',
          amount: '1.50'),
      InvoiceItem(
          description: 'ប្រហុកខ្ទឹមស',
          quantity: 2,
          price: 1.5,
          discount: '',
          amount: '3.00'),
      InvoiceItem(
          description: 'អាម៉ុក',
          quantity: 1,
          price: 1.5,
          discount: '',
          amount: '1.50'),
      InvoiceItem(
          description: 'បាយស',
          quantity: 4,
          price: 1,
          discount: '',
          amount: '4.00'),
      InvoiceItem(
          description: 'ទឹកដប',
          quantity: 5,
          price: 1,
          discount: '',
          amount: '5.00'),
    ],
    totalUsd: 12.75,
    totalRiel: 52275.0,
    discount: 0.0,
    grandTotalUsd: 12.75,
    grandTotalRiel: 52275.0,
  ).obs;
}
