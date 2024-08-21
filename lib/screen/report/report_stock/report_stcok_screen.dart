import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constans/constan.dart';
import '../../../models/api/simple_model.dart';

class ReportStockScreen extends StatelessWidget {
  ReportStockScreen({super.key});

  final List<Simple> items = [
    Simple(
      itemName: 'Coca cola',
      cost: 0.75,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.75,
      balance: 'Coca col',
    ),
    Simple(
      itemName: 'ABC Beer',
      cost: 1.00,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 1.00,
      balance: 'ABC Beer',
    ),
    Simple(
      itemName: 'Coffee pack',
      cost: 10.00,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 10.00,
      balance: 'Coffee pack',
    ),
    Simple(
      itemName: 'Water',
      cost: 0.25,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.25,
      balance: 'Water',
    ),
    Simple(
      itemName: 'Angkor beer',
      cost: 0.75,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.75,
      balance: 'Angkor beer',
    ),
    Simple(
      itemName: 'Sting',
      cost: 0.50,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.50,
      balance: 'Sting',
    ),
    Simple(
      itemName: 'Pepsi',
      cost: 0.50,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.50,
      balance: 'Pepsi',
    ),
    Simple(
      itemName: 'Heniken',
      cost: 1.00,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 1.00,
      balance: 'Heniken',
    ),
    Simple(
      itemName: 'Pepsi',
      cost: 0.50,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.50,
      balance: 'Pepsi',
    ),
    Simple(
      itemName: 'Anchor',
      cost: 0.50,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.50,
      balance: 'Anchor',
    ),
    Simple(
      itemName: 'Pepsi',
      cost: 0.50,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 0.50,
      balance: 'Pepsi',
    ),
    Simple(
      itemName: 'Tiger beer',
      cost: 10.00,
      qtyOrdered: 0,
      onHold: 0,
      onHand: 0,
      sold: 0,
      adjustment: 0,
      price: 15.00,
      balance: 'Tiger beer',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SNACK & RELAX CAFE',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: appColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Match the border radius
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Match the border radius
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Match the border radius
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        const Icon(Icons.downloading_sharp),
                        const SizedBox(width: 10),
                        const Text('Export To Excel'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text('Item Name',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Cost',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Qty Ordered',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('On Hold',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('On Hand',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Sold',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Adjustment',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Price',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Balance',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Center(child: Text(item.itemName))),
                        Expanded(
                            child: Center(
                                child: Text(
                                    '\$ ${item.cost.toStringAsFixed(2)}'))),
                        Expanded(
                            child: Center(child: Text('${item.qtyOrdered}'))),
                        Expanded(child: Center(child: Text('${item.onHold}'))),
                        Expanded(child: Center(child: Text('${item.onHand}'))),
                        Expanded(child: Center(child: Text('${item.sold}'))),
                        Expanded(
                            child: Center(child: Text('${item.adjustment}'))),
                        Expanded(
                            child: Center(
                                child: Text(
                                    '\$ ${item.price.toStringAsFixed(2)}'))),
                        Expanded(child: Center(child: Text('${item.balance}'))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
