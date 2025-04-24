// // Main Body Content
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// Widget UserBodyWidget() {
//   return Obx(() {
//     if (controller.loading.value) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (controller.errorMessage.isNotEmpty) {
//       return Center(child: Text(controller.errorMessage.value));
//     }

//     if (controller.users.isEmpty) {
//       return Center(child: Text('No users found'.tr));
//     }

//     return RefreshIndicator(
//       onRefresh: controller.fetchUsers,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: controller.users.length,
//         itemBuilder: (context, index) => _buildUserItem(controller.users[index]),
//       ),
//     );
//   });
// }