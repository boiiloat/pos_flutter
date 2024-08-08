import 'package:flutter/material.dart';

class SaleWidget extends StatelessWidget {
  const SaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 5, 7, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade100,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://whitneybond.com/wp-content/uploads/2021/06/steak-marinade-13.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  child: Text(
                    'Steak khmer',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  child: Row(
                    children: [
                      const Text(
                        'Qty :',
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '10',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '\$10.00',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  onSelected: (value) {
                    // Handle menu item selection
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'Re-order',
                        child: Text('Re-order'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Qty',
                        child: Text('Qty'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Price',
                        child: Text('Price'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Discount',
                        child: Text('Discount'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Remove Item',
                        child: Text('Remove Item'),
                      ),
                    ];
                  },
                  icon: Icon(
                    Icons.more_vert,
                    size: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
