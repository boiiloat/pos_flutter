// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loading_overlay/loading_overlay.dart';

// class LoadingOverlayWidget extends StatelessWidget {
//   final bool isLoading;
//   final Widget child;
//   final bool isLoadingRenderUI;
//   const LoadingOverlayWidget({
//     super.key,
//     required this.child,
//     required this.isLoading,
//     this.isLoadingRenderUI = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LoadingOverlay(
//       color: Colors.black87,
//       opacity: 0.5,
//       progressIndicator: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const LinearProgressIndicator(),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     constraints: const BoxConstraints(
//                       minWidth: 100,
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "Processing".tr,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       isLoading: isLoading,
//       child: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/patterns/brickwall.png"),
//             repeat: ImageRepeat.repeat,
//           ),
//         ),
//         child: !isLoadingRenderUI && isLoading
//             ? Container()
//             : Container(
//                 color: Colors.grey[200]!.withOpacity(0.2),
//                 child: child,
//               ),
//       ),
//     );
//   }
// }
