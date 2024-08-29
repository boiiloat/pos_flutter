// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pos_system/controller/sale_controller.dart';

// class SaleWidget extends StatelessWidget {
//   final String imageUrl; // Change type to String
//   final String qty;
//   final String productnam;
//   final String price;

//   const SaleWidget({
//     super.key,
//     required this.imageUrl, // Change parameter name to imageUrl
//     required this.qty,
//     required this.productnam,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SaleController());

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white,
//       ),
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: Colors.grey.shade100,
//                 ),
//                 image: DecorationImage(
//                   image: AssetImage(imageUrl), // Use imageUrl here
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 130,
//                 child: Text(
//                   productnam, // Use productnam parameter
//                   style: const TextStyle(color: Colors.black, fontSize: 15),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Container(
//                 child: Row(
//                   children: [
//                     const Text(
//                       'Qty :',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       qty, // Use qty parameter
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Text(
//                 "\$ $price", // Use price parameter
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(width: 5),
//               PopupMenuButton<String>(
//                 icon: Icon(Icons.more_vert, size: 20),
//                 onSelected: (value) {
//                   controller.handleMenuSelection(value);
//                 },
//                 itemBuilder: (BuildContext context) => [
//                   PopupMenuItem(
//                     value: 're_order',
//                     child: Text('Re-Order'),
//                   ),
//                   PopupMenuItem(
//                     value: 'qty',
//                     child: Text('Qty'),
//                   ),
//                   PopupMenuItem(
//                     value: 'price',
//                     child: Text('Price'),
//                   ),
//                   PopupMenuItem(
//                     value: 'discount',
//                     child: Text('Discount'),
//                   ),
//                   PopupMenuItem(
//                     value: 'remove_item',
//                     child: Text('Remove Item'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
