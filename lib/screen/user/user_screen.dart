import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_controller.dart';

class UserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SNACK & RELAX CAFE'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _userController.fetchUsers,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
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
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 150,
                    height: 38,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle),
                        SizedBox(width: 10),
                        Text(
                          'Add Product',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _buildUserList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Obx(() {
      if (_userController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_userController.errorMessage.isNotEmpty) {
        return Center(
            child: Text('Error: ${_userController.errorMessage.value}'));
      }

      if (_userController.users.isEmpty) {
        return const Center(
          child: Text(
            'No users found',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView(
        children: [
          // Header Row
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                _buildHeaderCell('Profile', flex: 2),
                _buildHeaderCell('Full Name', flex: 3),
                _buildHeaderCell('Username', flex: 3),
                _buildHeaderCell('Created By', flex: 2),
                _buildHeaderCell('Role', flex: 2),
                _buildHeaderCell('Action', flex: 2),
              ],
            ),
          ),
          // Data Rows
          ..._userController.users.map((user) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade100),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  _buildDataCell(
                    CircleAvatar(
                      radius: 24, // Increased size
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: (user.profileImage != null &&
                              user.profileImage!.isNotEmpty)
                          ? NetworkImage(
                              'http://127.0.0.1:8000/storage/${user.profileImage}')
                          : const AssetImage("assets/images/logo_image.jpg")
                              as ImageProvider,
                    ),
                    flex: 2,
                  ),
                  _buildDataCell(
                    Text(
                      user.fullname ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    flex: 3,
                  ),
                  _buildDataCell(
                    Text(
                      user.username ?? 'N/A',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    flex: 3,
                  ),
                  _buildDataCell(
                    Text(
                      user.createBy ?? 'N/A',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    flex: 2,
                  ),
                  _buildDataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(int.tryParse(user.roleId ?? '')),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRoleName(int.tryParse(user.roleId ?? '')),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  _buildDataCell(
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 22),
                      onPressed: () {
                        // Implement delete functionality
                      },
                    ),
                    flex: 2,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(child: child),
    );
  }

  String _getRoleName(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cashier';
      default:
        return 'User';
    }
  }

  Color _getRoleColor(int? roleId) {
    switch (roleId) {
      case 1:
        return Colors.red.shade600;
      case 2:
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
