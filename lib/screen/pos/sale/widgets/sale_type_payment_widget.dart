// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pos_system/controller/sale_controller.dart';

// class SaleTypePaymentWidget extends StatelessWidget {
//   final Icon icon;
//   final String label;
//   final String paymentType; // Add this to identify each payment type

//   const SaleTypePaymentWidget({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.paymentType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final SaleController controller = Get.find();
//     return Obx(
//       () => GestureDetector(
//         onTap: () {
//           controller.selectPaymentType(paymentType);
//         },
//         child: Container(
//           height: 80,
//           width: 130,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(
//               color: controller.selectedPaymentType.value == paymentType
//                   ? Colors.red
//                   : Colors.grey.shade300,
//             ),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon.icon,
//                 size: 35,
//                 color: Colors.red,
//               ),
//              const SizedBox(height: 5),
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 13),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
